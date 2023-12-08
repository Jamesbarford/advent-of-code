#define HT_CAP      16777216 // 2^24
#define PT1_DESTINATION 0x191919
#define PT1_START       0x0

class HtEnt {
  U64 K;
  U64 L;
  U64 R;
};

class Ht {
  U64 cap;
  U64 len;
  U64 dirlen;
  U64 *dirs;
  U64 *keys; /* bit of a hack but easy to implement*/
  HtEnt **entries;
};

I64 GCD(I64  a, I64 b)
{
  if (b == 0) {
    return a;
  }
  return GCD(b,a % b);
}

I64 LCM(I64 a, I64 b)
{
  return (a / GCD(a, b)) * b;
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

U64 HashFunction(U8 *key)
{ // [A,A,A]. Minus ascii of 'A' gives 0 0 0
  return (*key++-'A') | 
         (*key++-'A') << 8 |
         (*key++-'A') << 16;
}

U0 UnHash(U64 K, U8 *key)
{ // converts 0x191919 -> ZZZ
  key[0] = K + 'A'; 
  key[1] = (K >> 8)  + 'A';
  key[2] = (K >> 16) + 'A';
  key[3] = '\0';
}

Ht *HtNew()
{
  Ht *ht = MAlloc(sizeof(Ht));
  ht->cap = HT_CAP;
  ht->len = 0;
  ht->dirlen = 0;
  ht->entries = MAlloc(sizeof(HtEnt *) * HT_CAP);
  ht->dirs = MAlloc(sizeof(U64) * HT_CAP);
  ht->keys = MAlloc(sizeof(U64) * HT_CAP);
  for (I64 i = 0; i < 1<<24; ++i) {
    ht->entries[i] = NULL;
  }

  return ht;
}

U0 HtPrint(Ht *ht)
{
  HtEnt *ent;
  I64 dirlen = ht->dirlen, K, len;

  for (I64 i = 0; i < dirlen; ++i) {
    "%c",ht->dirs[i];
  }
  "\n";

  len = ht->len;
  for (I64 i = 0; i < len; ++i) {
    K = ht->keys[i];
    ent = ht->entries[K];
    "[%p] ",ent;
    "<K->0x%06X> = (0x%06X, 0x%06X)\n",K,ent->K,ent->L;
  }
}

Ht *ParseProblem(U8 *ptr)
{
  Ht *ht;
  HtEnt *ent;
  U8 line[512], *K, *L, *R, *lptr;

  ht = HtNew();

  GetLine(&ptr,line);
  lptr = line;
  while (*lptr) {
    ht->dirs[ht->dirlen++] = *lptr++;
  }

  GetLine(&ptr,line);
  while (GetLine(&ptr,line)) {
    ent = MAlloc(sizeof(HtEnt));
    ent->K = HashFunction(line);
    ent->L = HashFunction(line + 7);
    ent->R = HashFunction(line + 12);
    ht->keys[ht->len++] = ent->K;
    ht->entries[ent->K] = ent;
  }
  return ht;
}

U64 Solver(Ht *ht, U64 start, U64 destination_mask)
{
  HtEnt *ent;
  U64 diridx,dirlen,K,L,R;
  I64 steps,acc;
  U8 dir;

  dir = diridx = steps = acc = 0;
  dirlen = ht->dirlen;
  K = start;

  while ((K & destination_mask) != destination_mask) {

    ent = ht->entries[K];
    dir = ht->dirs[diridx++];

    if (dir == 'L') K = ent->L;
    else K = ent->R;

    steps++;
    /* wrap around */
    if (diridx == dirlen) diridx = 0;
  }

  return steps;

}

U64 SolvePart1(Ht *ht)
{
  return Solver(ht,PT1_START,0x191919);
}

Bool EndsWithA(U64 hash) {
  return !(hash & 0xFF0000);
}

U64 SolvePart2(Ht *ht)
{
  U64 K,acc,steps,len;
  U64 *arr = MAlloc(sizeof(U64) * HT_CAP);
  U8 un[5];
  steps=K=len=acc=0;

  for (I64 i = 0; i < ht->len; ++i) {
    K = ht->keys[i];
    if (EndsWithA(K)) {
      steps = Solver(ht, K, 0x190000);
      arr[len++] = steps;
    }
  }

  acc = arr[0];
  for (I64 i = 1; i < len; ++i) {
    acc = LCM(acc,arr[i]);
  }

  return acc;
}

U0 Main()
{
  I64 len;
  U8 *buffer = FileRead("./input.txt", 20000, &len);
  Ht *ht = ParseProblem(buffer);
  U64 pt1 = SolvePart1(ht);
  "part1: %zu\n",pt1;
  U64 pt2 = SolvePart2(ht);
  "part2: %zu\n",pt2;
}
