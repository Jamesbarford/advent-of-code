class PuzzleLine
{
  I64 test_case;
  I64 size;
  I64 entries[1<<8];
};

class Puzzle
{
  I64 size;
  PuzzleLine entries[1<<12];
};

I64 Pow3(I64 N)
{
  I64 result = 1;
  for (I64 i = 0; i < N; ++i) {
    result *= 3;
  }
  return result;
}

Puzzle *Parse(U8 *buffer)
{
  U8 *ptr = buffer;
  Puzzle *p = MAlloc(sizeof(Puzzle));
  p->size = 0;

  while (*ptr) {
    PuzzleLine *line = &p->entries[p->size++];
    for (line->test_case = 0; '0' <= *ptr <= '9';) {
      line->test_case = line->test_case * 10 + *ptr++ - '0';
    }

    /* move past ':' */
    ptr++;
    while (*ptr != '\n') {
      while (IsSpace(*ptr)) ptr++;
      I64 num = 0;
      while ('0' <= *ptr <= '9') {
        num = num * 10 + *ptr++ - '0';
      }
      line->entries[line->size++] = num;
    }
    ptr++;
  }

  return p;
}

I64 IntConcat(I64 n1, I64 n2)
{ /* A horrendous way of concatinating numbers */
  I64 arr[] = {n1,n2};
  U8 buf[256];
  U8 concat_buf[256];
  U8 *p1 = concat_buf;

  for (I64 i = 0; i < 2; ++i) {
    I64 num = arr[i];
    I64 len = I64ToStr(buf,num);
    StrReverse(buf,len);
    for (U8 *p2 = buf; *p2; ++p2) {
      *p1++ = *p2;
    }
  }
  *p1 = '\0';
  return Atoi(concat_buf);
}

Bool MatchesTest(PuzzleLine *line)
{
  U8 ops[] = {'+', '*'};
  I64 len = line->size - 1;
  I64 max_combos = (1 << len); /* 2^(n-1) */

  for (I64 i = 0; i < max_combos; ++i) {
    I64 result = line->entries[0];
    for (I64 j = 0; j < len; ++j) {
      U8 op = ops[(i >> j) & 1];
      if      (op == '+') result += line->entries[j+1];
      else if (op == '*') result *= line->entries[j+1];
    }
    if (result == line->test_case) return TRUE;
  }
  return FALSE;
}

Bool MatchesTestPt2(PuzzleLine *line)
{
  U8 ops[] = {'+', '*', '@'};
  I64 len = line->size - 1;
  I64 max_combos = Pow3(len); /* 3^(n-1) mercifully this isn't too slow */

  for (I64 i = 0; i < max_combos; ++i) {
    I64 result = line->entries[0];
    I64 current = i;

    for (I64 j = 0; j < len; ++j) {
      U8 op = ops[current % 3];
      current /= 3;
      if      (op == '+') result += line->entries[j+1];
      else if (op == '*') result *= line->entries[j+1];
      else if (op == '@') result = IntConcat(result, line->entries[j+1]);
    }
    if (result == line->test_case) return TRUE;
  }

  return FALSE;
}

I64 Part1(Puzzle *p)
{
  I64 acc = 0;
  for (PuzzleLine *line : p) {
    if (MatchesTest(line)) {
      acc += line->test_case;
    }
  }
  return acc;
}

I64 Part2(Puzzle *p)
{
  I64 acc = 0;
  I64 vec[1<<10];
  I64 vec_size = 0;

  /* Keep doing the old way as it's more efficient */
  for (I64 i = 0; i < p->size; ++i) {
    PuzzleLine *line = &p->entries[i];
    if (MatchesTest(line)) {
      acc += line->test_case;
    } else {
      /* Store the ones that weren't solvable */
      vec[vec_size++] = i;
    }
  }

  /* This is abominably slow */
  for (I64 i = 0; i < vec_size; ++i) {
    PuzzleLine *line = &p->entries[vec[i]];
    if (MatchesTestPt2(line)) {
      acc += line->test_case;
    }
  }

  return acc;
}

U0 Main()
{
  U8 *buffer = FileRead("./input.txt");
  auto puzzle = Parse(buffer);

  "Part1: %ld\n", Part1(puzzle);
  "Part2: %ld\n", Part2(puzzle);

  Free(puzzle);
  Free(buffer);
}
