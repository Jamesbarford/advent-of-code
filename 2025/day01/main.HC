I64 EmitNumber(U8 *line)
{
  U8 tmp[32];
  U8 *tmp_ptr = tmp;
  while (*line != '\n') {
    *tmp_ptr++ = *line++;
  }
  *tmp_ptr = '\0';
  return Atoi(tmp);
}

I64 Solve(U8 *buffer)
{
  U8 tmpnum[32];
  U8 *num_ptr = tmpnum;
  U8 dir = 0;
  I64 cur = 50;
  I64 acc = 0;

  while (*buffer) {
    dir = *buffer;
    buffer++;
    while (*buffer != '\n') {
      *num_ptr++ = *buffer++;
    }
    *num_ptr = '\0';
    I64 num = Atoi(tmpnum);
    if (dir == 'L') {
      while (num) {
        cur--;
        num--;
        if (cur == -1) cur = 99;
      }
    } else {
      while (num) {
        cur++;
        num--;
        if (cur == 100) cur = 0;
      }
    }

    if (cur == 0) {
      acc++;
    }
    num_ptr = tmpnum;
    buffer++;
  }
  return acc;
}

I64 Solve2(U8 *buffer)
{
  U8 tmpnum[32];
  U8 *num_ptr = tmpnum;
  U8 dir = 0;
  I64 cur = 50;
  I64 acc = 0;

  while (*buffer) {
    dir = *buffer;
    buffer++;
    while (*buffer != '\n') {
      *num_ptr++ = *buffer++;
    }
    *num_ptr = '\0';
    I64 num = Atoi(tmpnum);
    if (dir == 'L') {
      while (num) {
        cur--;
        num--;
        if (cur == 0) acc++;
        if (cur == -1) cur = 99;
      }
    } else {
      while (num) {
        cur++;
        num--;
        if (cur == 100) cur = 0;
        if (cur == 0) acc++;
      }
    }

    num_ptr = tmpnum;
    buffer++;
  }
  return acc;
}

U0 Main()
{
  U8 *buffer = FileRead("./input.txt");
  I64 s1 = Solve(buffer);
  I64 s2 = Solve2(buffer);
  "s1 = %d\n", s1;
  "s2 = %d\n", s2;
  Free(buffer);
}
