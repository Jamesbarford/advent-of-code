class DiffLists
{
  IntVec *vec1;
  IntVec *vec2;
};

DiffLists *DiffListsNew(U0)
{
  DiffLists *dl = MAlloc(sizeof(DiffLists));
  dl->vec1 = IntVecNew;
  dl->vec2 = IntVecNew;
  return dl;
}

U0 DiffListsRelease(DiffLists *dl)
{
  IntVecRelease(dl->vec1);
  IntVecRelease(dl->vec2);
}

I64 CollectInt(U8 **_ptr)
{
  U8 tmp[64];
  U8 *tmp_ptr = tmp;
  U8 *ptr = *_ptr;
  while ('0' <= *ptr<='9') {
    *tmp_ptr++ = *ptr++;
  }
  *tmp_ptr='\0';
  *_ptr = ptr;
  return Atoi(tmp);
}

DiffLists *ParseInput(U8 *buffer)
{
  DiffLists *dl = DiffListsNew;
  U8 *ptr = buffer;
  I64 num1,num2;
  while (*ptr) {
    num1 = CollectInt(&ptr);
    while (IsSpace(*ptr)) ptr++;
    num2 = CollectInt(&ptr);
    IntVecPush(dl->vec1,num1);
    IntVecPush(dl->vec2,num2);
    ptr++;
  }
  return dl;
}

I64 Part1(DiffLists *dl)
{
  IntVecSort(dl->vec1);
  IntVecSort(dl->vec2);
  I64 len = dl->vec1->size;
  I64 num1,num2,diff,acc = 0;
  for (I64 i = 0; i < len; ++i) {
    num1 = dl->vec1->entries[i];
    num2 = dl->vec2->entries[i];
    diff = num2-num1;
    acc += Abs(diff);
  }
  return acc;
}

I64 Part2(DiffLists *dl)
{
  I64 len = dl->vec1->size;
  I64 num1,num2,diff,acc = 0;
  IntMap *map = IntMapNew;
  for (I64 it : dl->vec2) {
    I64 val = IntMapGet(map,it)(I64);
    val++;
    IntMapSet(map,it,val(U0 *));
  }

  for (I64 it : dl->vec1) {
    I64 modifier = IntMapGet(map,it)(I64);
    acc += (it * modifier);
  }

  return acc;
}


U0 Main()
{
  U8 *buffer = FileRead("./input.txt");
  DiffLists *dl = ParseInput(buffer);
  
  "part1 = %d\n",Part1(dl);
  "part2 = %d\n",Part2(dl);

  DiffListsRelease(dl);
  Free(buffer);
}
