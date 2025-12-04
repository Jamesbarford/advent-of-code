U0 PrintLine(U8 *buffer)
{
  while (*buffer != '\n') "%c", *buffer++;
  "\n";
}

U8 *GetLine(U8 **_buffer)
{
  static U8 tmp[1024];
  U8 *ptr = tmp;
  U8 *buffer = *_buffer;
  if (*buffer == '\0') return NULL;
  while (*buffer != '\n') {
    *ptr++ = *buffer++;
  }
  buffer++;
  *ptr = '\0';
  *_buffer = buffer;
  return tmp;
}

U8 GetBigFrom(U8 *line, I64 from, I64 to,I64 *_idx)
{
  U8 big = *(line + from);
  I64 idx = from;
  for (I64 i = from; i < to; ++i) {
    if (line[i] > big) {
      *_idx = i;
      big = line[i];
    }
  }
  return big;
}

I64 Solve1(U8 *buffer)
{
  I64 acc = 0;
  U8 *line = GetLine(&buffer);
  I64 line_len = StrLen(line);
  while (line) {
    I64 idx = 0;
    U8 s1 = GetBigFrom(line, 0, line_len-1, &idx);
    U8 s2 = GetBigFrom(line, idx + 1, line_len, &idx);
    line = GetLine(&buffer);
    I64 num = ((s1-'0')*10)+(s2-'0');
    acc += num;
  }
  return acc;
}

I64 Solve2(U8 *buffer)
{
  U8 *line = GetLine(&buffer);
  I64 len = StrLen(line);
  U8 stack[1000];
  I64 acc = 0;
  while (line) {
    I64 to_remove = len - 12;
    I64 top = 0;
    for (I64 i = 0; i < len; i++) {
      U8 ch = line[i];
      while (to_remove > 0 && top > 0 && stack[top - 1] < ch) {
        top--;
        to_remove--;
      }
      stack[top++] = ch;
    }

    if (top > 12) {
      top = 12;
    }

    stack[top] = '\0';
    acc += Atoi(stack);
    line = GetLine(&buffer);
  }
  return acc;
}

U0 Main(U0)
{
  U8 *buffer = FileRead("./input.txt");
  "s1 = %lld\n", Solve1(buffer);
  "s2 = %lld\n", Solve2(buffer);
  Free(buffer);
}
