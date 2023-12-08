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
  HtEnt **entries;
};

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

Ht *HtNew()
{
  Ht *ht = MAlloc(sizeof(Ht));
  ht->cap = HT_CAP;
  ht->len = 0;
  ht->dirlen = 0;
  ht->entries = MAlloc(sizeof(HtEnt *) * HT_CAP);
  ht->dirs = MAlloc(sizeof(U64) * HT_CAP);
  for (I64 i = 0; i < 1<<24; ++i) {
    ht->entries[i] = NULL;
  }

  return ht;
}

U0 HtPrint(Ht *ht)
{
  HtEnt *ent;
  I64 dirlen = ht->dirlen;

  for (I64 i = 0; i < dirlen; ++i) {
    "%c",ht->dirs[i];
  }
  "\n";

  for (I64 i = 0; i < HT_CAP; ++i) {
    ent = ht->entries[i];
    if (ent) {
      "<K->0x%X> = (0x%X, 0x%X)\n",ent->K,ent->K,ent->L;
    }
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
    ht->entries[ent->K] = ent;
  }
  return ht;
}

U0 SolvePart1(Ht *ht)
{
  HtEnt *ent;
  I64 diridx,dirlen,run,K,L,R;
  U8 dir;
  U64 steps = 0;

  dir = diridx = 0;
  dirlen = ht->dirlen;
  K = PT1_START;

  while (K != PT1_DESTINATION) {
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

U0 Main()
{
  I64 len;
  U8 *buffer = FileRead("./input.txt", 20000, &len);
  Ht *ht = ParseProblem(buffer);
  U64 pt1 = SolvePart1(ht);
  "part1: %zu\n",pt1;
}
