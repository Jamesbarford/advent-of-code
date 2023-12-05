#define HT_SIZE         512
#define LINE_LEN        512
#define TUPLE_SIZE      3
#define PUZZLE_LEN_IDX  2
#define PUZZLE_DST_IDX  0
#define PUZZLE_SRC_IDX  1

class HtNode
{
  U8 *key;
  I64 *tuple;
  U64 hash;
};

class Ht
{
  I64 len;
  HtNode **entries;
};

Ht HtNew()
{
  Ht *ht = MAlloc(sizeof(Ht));
  ht->len = 0;
  ht->entries = MAlloc(sizeof(HtNode *)*HT_SIZE);
  for (I64 i = 0; i < HT_SIZE; ++i) {
    ht->entries[i] = NULL;
  }
  return ht;
}

U64 HashFunction(U8 *str, I64 len)
{
  U64 hash = 0;
  for (U64 i = 0; i < len; i++) {
    hash = ((hash << 5) + hash) + str[i];
  }
  return hash;
}

U0 HtSet(Ht *ht, U8 *key, I64 *tuple)
{
  U64 hash,idx,key_len;
  HtNode *hn;
  key_len = StrLen(key);
  hash = HashFunction(key, key);
  idx = hash & HT_SIZE;
  hn = MAlloc(sizeof(HtNode));
  hn->key = MAlloc(sizeof(U8)*key_len+10);
  MemCpy(hn->key,key,key_len);
  hn->key[key_len] = '\0';
  hn->tuple = tuple;
  hn->hash = hash;
  ht->entries[idx] = hn;
  ht->len++;
}

Ht *HtGet(Ht *ht, U8 *key)
{
  U64 hash,idx,key_len;
  HtNode *hn;
  key_len = StrLen(key);
  hash = HashFunction(key, key);
  idx = hash & HT_SIZE;
  return ht->entries[idx];
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

U8 *GetKey(U8 **_ptr)
{
  U64 len;
  U8 *ptr, *key;
  ptr = *_ptr;
  key = MAlloc(sizeof(U8)*100);
  while (*ptr && *ptr != ':' && *ptr != ' ') {
    *key = *ptr;
    key++;
    ptr++;
  }
  *key = '\0';
  return key;
} 

U0 ParseInput(U8 *buffer)
{
  Ht *ht = HtNew();
  U8 *ptr, line[LINE_LEN],key;
  while (GetLine(&ptr,line)) {
    if ('a' <=line[0]<='z') {
      key = GetKey(line);
    }
  }
}


U0 Main()
{
  "DAY5\n";
}
