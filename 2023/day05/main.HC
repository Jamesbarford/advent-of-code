#define HT_SIZE         512
#define LINE_LEN        512
#define TUPLE_SIZE      3
#define PUZZLE_LEN_IDX  2
#define PUZZLE_DST_IDX  0
#define PUZZLE_SRC_IDX  1

class Array
{
  I64 *data;
  U8 *key;
  I64 len;
};

/**
 * XXX: URGENT:
 * This is seriously broken, to the point of unusable
 * should be ht->entries[idx] = hn;
 */
class Ht
{
  I64 len;
  I64 cap;
  Array **entries;
};

U0 HtNew(I64 cap)
{
  Ht *ht = MAlloc(sizeof(Ht));
  ht->entries = MAlloc(sizeof(Array *) * cap + 2);
  ht->len = 0;
  ht->cap = cap;
  for (I64 i = 0; i <= cap; ++i) {
    ht->entries[i] = NULL;
  }
  return ht;
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

U0 HtSet(Ht *ht, U8 *key, I64 key_len, I64 arr_len, I64 *arr)
{
  U64 hash, idx;
  Array *ptr, *pt2;
  hash = HashFunction(key, key_len);
  idx = hash & (HT_SIZE - 1);
  
  if (ht->entries[idx]) {
    "HashTable Collision\n";
  }

  ptr = MAlloc(sizeof(Array));
  ptr->key = key;
  ptr->data = arr;
  ptr->len = arr_len;
  ht->entries[idx] = ptr;
  ht->len++;
  "IDX: %d\n",idx;
}

Ht *HtGet(Ht *ht, U8 *key)
{
  U64 hash,key_len,idx;
  Array *arr;
  key_len = StrLen(key);
  hash = HashFunction(key, key_len);
  idx = hash & (HT_SIZE - 1);
  arr = ht->entries[idx];
  "IDX: %d\n",idx;
  return ht->entries;
}

U0 HtScan(Ht *ht)
{
  "TABLE SCAN\n";
  Array *ptr;
  for (I64 i = 0; i < (ht->cap-1); ++i) {
    ptr = ht->entries[i];
    if (ptr) {
      "ADDR: %p\n", ptr;
      //"ENTRY: %s len%d", ptr->key, ptr->len;
      //"\n===\n";
    }
  }
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
  "ret\n";
  return skip;
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

U0 ParseInput(U8 *buffer)
{
  Array *arr;
  Ht *ht = HtNew(HT_SIZE);
  U8 line[LINE_LEN], *ptr, *lptr, *key, ch;
  I64 len, *arr, arr_len;
  ptr = buffer;

  while (GetLine(&ptr,line)) {
    // "%c\n",line[0];
    lptr = line;
    ch = *lptr;
    if ('a'<=ch<='z') {
      ">>%s\n",lptr;
      key = GetKey(lptr, &len);
      lptr += len;
      while (*lptr != ':') {
        lptr++;
      }

      if (!StrNCmp(key,"seeds",5)) {
        "here: %d\n",len;
        "key=%s\n",key;
        arr = MAlloc(sizeof(I64) * 32);
        lptr += 2;
        ParseNumbersUntil(arr,&arr_len,lptr,'\0');
        HtSet(ht,key,len,arr_len,arr);
        "%s\n",lptr;
      } else {
        while (GetLine(&ptr, line)) {
          if (line[0] == '\n') {
            /* I don't have break clauses */
            goto done;
          }

          ParseNumbersUntil(arr,&arr_len,lptr,'\0');
        }
      }
    }
  }

  HtScan(ht);
  arr = HtGet(ht,"seeds");
  if (arr) {
     "seeds: %d\n",arr->len;
  }

  return;
}


U0 Main()
{
  I64 *len;
  U8 *buffer = FileRead("./sample.txt", 5000, &len);
  ParseInput(buffer);
}
