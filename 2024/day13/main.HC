I64 *RowNew(U0)
{
  return MAlloc(sizeof(I64)*6);
}

U0 RowPrint(I64 *row)
{
  "Button A: X+%ld, Y+%ld
Button B: X+%ld, Y+%ld
Prize: X=%ld, Y=%ld\n",row[0],row[1],row[2],row[3],row[4],row[5];
}

List *Parse(U8 *buffer)
{
  List *list = ListNew;
  I64 len = StrLen("Button C: Z+");
  I64 num[6];
  U8 *ptr = buffer;
  while (*ptr) {
    num[0] = 0;
    while (*ptr != '+') ptr++;
    ptr++;
    while (*ptr != ',') num[0] = num[0] * 10 + *ptr++ - '0';

    num[1] = 0;
    while (*ptr != '+') ptr++;
    ptr++;
    while (*ptr != '\n') num[1] = num[1] * 10 + *ptr++ - '0';

    num[2] = 0;
    while (*ptr != '+') ptr++;
    ptr++;
    while (*ptr != ',') num[2] = num[2] * 10 + *ptr++ - '0';

    num[3] = 0;
    while (*ptr != '+') ptr++;
    ptr++;
    while (*ptr != '\n') num[3] = num[3] * 10 + *ptr++ - '0';

    num[4] = 0;
    while (*ptr != '=') ptr++;
    ptr++;
    while (*ptr != ',') num[4] = num[4] * 10 + *ptr++ - '0';

    num[5] = 0;
    while (*ptr != '=') ptr++;
    ptr++;
    while (*ptr != '\n' && *ptr != '\0') num[5] = num[5] * 10 + *ptr++ - '0';

    if (*ptr != '\0') ptr++;
    I64 *row = MAlloc(sizeof(I64)*6);
    MemCpy(row,num,6*sizeof(I64));
    ListAppend(list,row);
  }
  return list;
}

I64 Solve(List *list, I64 modifier = 0)
{
  I64 acc = 0, prizes_won = 0, D, A, B;
  for (List *n = list->next; n != list; n = n->next) {
    I64 *row = n->value(I64 *);
    I64 ax = row[0];
    I64 ay = row[1];
    I64 bx = row[2];
    I64 by = row[3];
    I64 px = row[4] + modifier;
    I64 py = row[5] + modifier;

    D = ax*by - ay*bx;
    if (D == 0) continue;

    A = px*by - py*bx;
    B = py*ax - px*ay;
    if (A % D != 0 || B % D != 0) continue;

    A /= D;
    B /= D;
    if (A < 0 || B < 0) continue;

    prizes_won++;
    acc += 3*A+B;
  }

  return acc;
}

U0 Main()
{
  U8 *buffer = FileRead("./input.txt");
  List *list = Parse(buffer);

  "Part1: %lld\n",Solve(list);
  "Part2: %lld\n",Solve(list, 10000000000000);

  ListRelease(list,&Free);
  Free(buffer);
}
