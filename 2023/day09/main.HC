class Array
{
  U64 len;
  I64 *data;
};

Array *ArrayNew()
{
  Array *arr = MAlloc(sizeof(Array));
  arr->len = 0;
  arr->data = MAlloc(sizeof(U64) * 2000);
  return arr;
}

U0 ArrayPrint(Array *arr)
{
  "[";
  I64 len = arr->len;
  for (U64 i = 0; i < len; ++i) {
    if (i + 1 == len) "%ld",arr->data[i];
    else "%ld, ",arr->data[i];
  }
  "]\n";
}

I64 ParseNumber(U8 *buffer, I64 *_len)
{ // A poor mans strtoll
  Bool isneg = 0;
  I64 len = 0;
  if (*buffer == '-') {
    isneg = 1;
    buffer++;
    len++;
  }
  I64 number = *buffer++ - '0';
  while ('0' <= *buffer <= '9') {
    number *= 10;
    number += *buffer++ - '0';
    len++;
  }
  *_len = len;
  if (isneg) {
    return -number;
  }
  return number;
}

I64 ParseNumbersUntil(I64 *arr, I64 *_arr_len, U8 *ptr, I64 ch)
{ // Parse numbers until 'ch' storing them in arr;
  // Returns the number of characters to skip
  I64 num, num_len, skip = 0,arr_len = 0;
  while (*ptr && *ptr != ch) {
    if ('0' <= *ptr <= '9' || *ptr == '-') {
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

Bool ArrayIsZero(Array *arr)
{
  for (I64 i = 0; i < arr->len; ++i) {
    if (arr->data[i] != 0) {
      return FALSE;
    }
  }
  return TRUE;
}

U64 Part1Iter(Array *arr)
{
  if (ArrayIsZero(arr)) {
    return 0;
  }

  Array *diff = MAlloc(sizeof(Array));
  diff->data = MAlloc(sizeof(U64)*1000);
  diff->len = 0;
  I64 next;
  for (U64 i = 1; i < arr->len; ++i) {
    next = arr->data[i] - arr->data[i-1];
    diff->data[diff->len++] = next;
  }

  return arr->data[arr->len-1] + Part1Iter(diff);
}

U64 SolvePart1(U8 *ptr)
{
  U8 line[512];
  U64 arr_len,acc,next;
  acc = next = 0;
  while (GetLine(&ptr,line)) {
    Array *arr = ArrayNew();
    ParseNumbersUntil(arr->data,&arr_len,line,'\0');
    arr->len = arr_len;
    next = Part1Iter(arr);
    acc += next;
  }
  return acc;
}


U64 Part2Iter(Array *arr)
{
  if (ArrayIsZero(arr)) {
    return 0;
  }

  Array *diff = MAlloc(sizeof(Array));
  diff->data = MAlloc(sizeof(U64)*1000);
  diff->len = 0;
  I64 next;
  for (U64 i = 1; i < arr->len; ++i) {
    next = arr->data[i] - arr->data[i-1];
    diff->data[diff->len++] = next;
  }

  return arr->data[0] - Part2Iter(diff);
}

U64 SolvePart2(U8 *ptr)
{
  U8 line[512];
  U64 arr_len,acc,next;
  acc = next = 0;
  while (GetLine(&ptr,line)) {
    Array *arr = ArrayNew();
    ParseNumbersUntil(arr->data,&arr_len,line,'\0');
    arr->len = arr_len;
    next = Part2Iter(arr);
    acc += next;
  }
  return acc;
}

U0 Main()
{
  U64 len;
  U8 *buffer = FileRead("./input.txt", 50000, &len);
  U64 pt1 = SolvePart1(buffer);
  "%ld\n",pt1;
  U64 pt2 = SolvePart2(buffer);
  "%ld\n",pt2;
}
