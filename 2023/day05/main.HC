#define HT_SIZE         16
#define LINE_LEN        512
#define ARRAY_SIZE      200
#define TUPLE_SIZE      3
#define MAX_THREADS     32

#define LEN_IDX  2
#define DST_IDX  0
#define SRC_IDX  1

class Array
{
  U8 *key;
  I64 *data;
  I64 rows;
  I64 cols;
};


class Tuple
{
  U64 t[2];
};

class Ht
{
  I64 len;
  I64 cap;
  U64 bitmap;
  Array **entries;
};

U0 HtNew(I64 cap)
{
  Ht *ht = MAlloc(sizeof(Ht));
  ht->entries = MAlloc(sizeof(Array *) * cap + 2000);
  ht->len = 0;
  ht->cap = cap;
  ht->bitmap = 0;
  for (I64 i = 0; i < cap; ++i) {
    ht->entries[i] = NULL;
  }
  return ht;
}

Array *ArrayNew(U8 *key, I64 rows, I64 cols)
{
  Array *arr;
  arr = MAlloc(sizeof(Array));
  arr->data = MAlloc(sizeof(U64)*ARRAY_SIZE);
  arr->rows=rows;
  arr->cols=cols;
  arr->key=key;
  return arr;
}

U0 ArrayPrint(Array *a)
{
  I64 contents = a->rows * a->cols;
  "ARRAY[%s]: rows=%d cols=%d contents=%d\n",
      a->key, a->rows, a->cols, contents;
  for (I64 i = 0; i < contents; ++i) {
      "%ld ", a->data[i];
  }
  "\n";
}

U64 HashFunction(U8 *key, I64 len)
{ 
  U8 *s = key;
  U64 h = *s;
  for (I64 i = 1; i < len; ++i) {
    h = (h << 5) - h + s[i];
  }
  return h;
}

U64 HashIdx(U8 *key)
{
  U64 h;
  U8 *s = key;
  I64 len = StrLen(key);
  h = HashFunction(key,len);
  return h & (HT_SIZE-1);
}

U0 HtSet(Ht *ht, U8 *key, Array *arr)
{
  U64 hash, idx, key_len;
  Array *ptr, *pt2;
  key_len = StrLen(key);
  hash = HashFunction(key, key_len);
  idx = hash & (HT_SIZE - 1);
  if (ht->entries[idx]) {
    "HashTable Collision\n";
    exit(1);
  }
  ht->entries[idx] = arr;
  ht->bitmap |= 1 << idx;
  ht->len++;
}

Array *HtGet(Ht *ht, U8 *key)
{
  U64 hash,key_len,idx;
  Array *arr;
  key_len = StrLen(key);
  hash = HashFunction(key, key_len);
  idx = hash & (HT_SIZE - 1);
  arr = ht->entries[idx];
  return ht->entries;
}

U0 HtScan(Ht *ht)
{
  Array *ptr;
  "TABLE SCAN==========\n";
  "TABLE bitmap: \n";
  for (I64 i = 0; i < HT_SIZE; ++i) {
    if ((ht->bitmap >> i) & 1) "1";
    else  "0";
  }
  "\n";
  for (I64 i = 0; i < ht->cap; ++i) {
    if ((ht->bitmap >> i) & 1) {
      "TABLE IDX: %d\n",i;
      ArrayPrint(ht->entries[i]);
    }
  }
  "TABLE SCAN END=========\n";
}

public I64 GetLine(U8 **_src, U8 *dst)
{ // Will put a '\0' terminated string in 'dst'. Containing one line, 
  // mutates _src
  U8 *src = *_src;
  *dst = '\0';
  if (*src == '\0') {
    return 0;
  }

  while (*src && *src != '\n') {
    *dst = *src++;
    dst++;
  }

  if (*src == '\n') {
    *dst = '\0';
    src++;
  }

  *_src = src;
  return 1;
}

I64 ParseNumber(U8 *buffer, I64 *_len)
{ // A poor mans strtoll
  I64 number = *buffer++ - '0';
  I64 len = 0;
  while ('0' <= *buffer <= '9') {
    number *= 10;
    number += *buffer++ - '0';
    len++;
  }
  *_len = len;
  return number;
}

I64 ParseNumbersUntil(I64 *arr, I64 *_arr_len, U8 *ptr, I64 ch)
{ // Parse numbers until 'ch' storing them in arr;
  // Returns the number of characters to skip
  I64 num, num_len, skip = 0,arr_len = 0;
  while (*ptr && *ptr != ch) {
    if ('0' <= *ptr <= '9') {
      num = ParseNumber(ptr,&num_len);
      arr[arr_len++] = num;
      ptr += num_len;
      skip += num_len;
    }
    ptr++;
    skip++;
  }
  *_arr_len = arr_len;
  return skip;
}

Array *ParseMappings(U8 *key, U8 **_ptr)
{ // Get the dimensions of the Almanac mappings
  U8 line[LINE_LEN], *ptr, *lptr;
  U64 arr[512], arr_len, len;
  Array *mappings;

  mappings = NULL;
  ptr = *_ptr;
  len = 0;

  while (GetLine(&ptr,line)) {
    lptr = line;
    if (*lptr == '\0') {
      goto out;
    }

    ParseNumbersUntil(arr,&arr_len,lptr,'\0');
    if (!mappings) {
      mappings = ArrayNew(key,0,arr_len);
    }
    for (I64 i = 0; i < arr_len; ++i) {
      mappings->data[len++] = arr[i]; 
    }
    mappings->rows++;
  }
out:
  return mappings;
}

U8 *GetKey(U8 *ptr, I64 *_len)
{
  U64 len;
  U8 *key;
  key = MAlloc(sizeof(U8)*100);
  len = 0;
  while (*ptr && *ptr != ':' && *ptr != ' ') {
    key[len++] = *ptr;
    ptr++;
  }
  key[len] = '\0';
  *_len = len;
  return key;
}

Ht *ParseInput(U8 *buffer)
{
  Array *arr;
  Ht *ht = HtNew(HT_SIZE);
  U8 line[LINE_LEN], *ptr, *lptr, *key, ch;
  I64 len, *arr, arr_len;
  ptr = buffer;

  while (GetLine(&ptr,line)) {
    lptr = line;
    ch = *lptr;
    if ('a'<=ch<='z') {
      key = GetKey(lptr, &len);
      lptr += len;
      while (*lptr != ':') lptr++;
      if (!StrNCmp(key,"seeds",5)) {
        arr = ArrayNew(key,100,100);
        lptr += 2;
        ParseNumbersUntil(arr->data,&arr->cols,lptr,'\0');
        arr->rows = 1;
        HtSet(ht,key,arr);
      } else {
        arr = ParseMappings(key, &ptr);
        HtSet(ht,arr->key,arr);
      } 
    }
  }
  return ht;
}

U0 QSort(I64 *arr, I64 high, I64 low=0)
{ // Simple quick sort
  if (low < high) {
    I64 pivot = arr[high];
    I64 idx = low;
    I64 i = low;
    I64 tmp;

    while (i < high) {
      if (arr[i] <= pivot) {
        tmp = arr[i];
        arr[i] = arr[idx];
        arr[idx++] = tmp;
      }
      i++;
    }
    arr[high] = arr[idx];
    arr[idx] = pivot;

    QSort(arr,high,idx+1);
    QSort(arr,idx-1,low);
  }
}

U64 SolvePart1(Ht *t, Array *seeds)
{
  U64 arr[7],*solutions,idx,key,src,dst,
      len,next,r1,r2,s1,s2,total,solution_idx;
  Array *ptr;
  solutions = MAlloc(sizeof(U64)*seeds->cols);

  idx=key=src=dst=len=solution_idx=next=0;
  arr[0] = HashIdx("seed-to-soil");
  arr[1] = HashIdx("soil-to-fertilizer");
  arr[2] = HashIdx("fertilizer-to-water");
  arr[3] = HashIdx("water-to-light");
  arr[4] = HashIdx("light-to-temperature");
  arr[5] = HashIdx("temperature-to-humidity");
  arr[6] = HashIdx("humidity-to-location");

  for (I64 i = 0; i < seeds->cols; ++i) {
    s1 = seeds->data[i];
    s2 = s1;
    idx = 0;
    while (idx < 7) {
      key = arr[idx];
      ptr = t->entries[key];
      total = (ptr->rows) * (ptr->cols);
      for (U64 row = 0; row < total; row += 3) {
        src = ptr->data[SRC_IDX+row];
        dst = ptr->data[DST_IDX+row];
        len = ptr->data[LEN_IDX+row];
        r1 = src + len;
        r2 = dst + len;
        if (src <= s2 <= r1) {
          //"idx: %zu, src: %zu, dst: %zu,s2:%zu\n",
          //  idx,src,dst,s2;
          s2 -= src;
          s2 += dst;
          solutions[i] = s2;
          if (idx < 7) {
            goto jump1;
          }
        }
      }
jump1:
      if (++idx < 7) {
        solutions[i] = s2;
      }
    }
  }
done:
  for (I64 i = 0; i < seeds->cols;++i) {
    "seed:%zu => %zu\n",seeds->data[i],solutions[i];
  }
  QSort(solutions,seeds->cols-1,0);
  for (I64 i = 0; i < seeds->cols;++i) {
    "%zu\n",solutions[i];
  }
  return solutions[0];
}

U64 GetNextLocation(Array *ptr, I64 seed)
{
  U64 src,dst,len,r1,r2,total;
  total = (ptr->rows) * (ptr->cols);
  for (U64 row = 0; row < total; row += 3) {
    src = ptr->data[SRC_IDX+row];
    dst = ptr->data[DST_IDX+row];
    len = ptr->data[LEN_IDX+row];
    r1 = src + len;
    r2 = dst + len;
    if (seed >= src && seed <= r1) {
      seed -= src;
      seed += dst;
      return seed;
    }
  }
  return seed;
}

inline I64 Max(I64 i1, I64 i2)
{
  if (i1 > i2) return i1;
  return i2;
}

inline I64 Min(I64 i1, I64 i2)
{
  if (i1 < i2) return i1;
  return i2;
}

U0 StackPush(U64 **_arr, I64 *_sp, U64 num1, U64 num2)
{
  "PUSH start: %p\n", _sp;
  I64 sp = *_sp;
  _arr[sp][0] = num1;
  "PUSH SUCCESS\n";
  _arr[sp][1] = num2;
  sp++;
  *_sp = sp;
}

class ThreadCtx
{
  U64 start;
  U64 end;
  U64 min;
  U64 id;
  Ht *ht;
  I64 thread_;
};

U0 *ThreadRunner(ThreadCtx *ctx)
{
  "Thread: %zu\n",ctx->id;
  U64 arr[7];
  U64 s1,min,range,key;
  Array *ptr;
  
  range = ctx->end - ctx->start;
  min = 4294967295;
  arr[0] = HashIdx("seed-to-soil");
  arr[1] = HashIdx("soil-to-fertilizer");
  arr[2] = HashIdx("fertilizer-to-water");
  arr[3] = HashIdx("water-to-light");
  arr[4] = HashIdx("light-to-temperature");
  arr[5] = HashIdx("temperature-to-humidity");
  arr[6] = HashIdx("humidity-to-location");

  for (I64 seed = ctx->start; seed <= ctx->end; ++seed) {
    s1 = seed;
    for (I64 idx = 0; idx < 7; ++idx) {
      key = arr[idx];
      ptr = ctx->ht->entries[key];
      s1 = GetNextLocation(ptr,s1);
    }
    if (s1 < min) {
      min = s1;
    }
  }
  "THREAD: %zu min -> %zu\n",ctx->id,min;
  ctx->min = min;
  return NULL;
}

U64 SolvePart2(Ht *ht)
{
  I64 idx = HashIdx("seeds");
  "idx=>%ld\n",idx;
  Array *seeds = ht->entries[idx];
  I64 start,end,len,id,thread_;
  U64 min;
  I64 *mins = MAlloc(sizeof(I64) * 5000);

  ThreadCtx *contexts;
  ThreadCtx *ctx;
  
  id = start = end = len = 0;
  contexts = MAlloc(sizeof(ThreadCtx) * MAX_THREADS);
  ctx = NULL;

  "cols: %d\n",seeds->cols;
  for (I64 i = 0; i < seeds->cols; i += 2) {
    ctx = &contexts[id];
    id++;
    ctx->id = id;
    ctx->start = seeds->data[i];
    ctx->end = ctx->start + seeds->data[i + 1];
    ctx->ht = ht;
    ctx->min = 9223372036854775807;
    thread_ = ThreadNew(ThreadRunner,ctx);
    ctx->thread_ = thread_;
  }

  for (I64 i = 0; i < id; ++i) {
    ThreadJoin(contexts[i].thread_);
  }

  min = 9223372036854775807;
  for (I64 i = 0; i < id; ++i) {
    ctx = &contexts[i];
    if (ctx->min < min) {
      min = ctx->min;
    }
  }
  return min;
}

U0 Main(I64 argc, U8 **argv)
{
  I64 len;
  U8 *buffer = FileRead("./input.txt", 50000, &len);
  Ht *ht = ParseInput(buffer);
  U64 pt2 = SolvePart2(ht);
  "part2:%zu\n",pt2;
}
