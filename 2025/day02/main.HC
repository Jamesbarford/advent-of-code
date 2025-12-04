class Range
{
  U8 _s[128];
  U8 _e[128];
  I64 s, e;
};

U0 PrintRange(Range *r)
{
  "Range(start = %d, end = %d)\n", r->s, r->e;
}

I64 ParseRange(U8 *buf, Range *r)
{
  U8 *start = buf;
  U8 tmp[64];
  U8 *tmp_ptr = tmp;
  while (*buf != '-') *tmp_ptr++ = *buf++;
  *tmp_ptr = '\0';
  MemCpy(r->_s, tmp, sizeof(tmp));
  r->s = Atoi(tmp);
  tmp_ptr = tmp;
  buf++;
  while (*buf != ',' && *buf != '\0') *tmp_ptr++ = *buf++;
  *tmp_ptr = '\0';
  MemCpy(r->_e, tmp, sizeof(tmp));
  r->e = Atoi(tmp);
  buf++;
  return buf-start;
}

I64 NumDigits(I64 n)
{
  if (n == 0) return 1;
  I64 c = 0;
  while (n > 0) {
    n /= 10;
    c++;
  }
  return c;
}

Bool IsRepeater(I64 n)
{
  if (n <= 10) return FALSE;
  I64 len = NumDigits(n);

  Bool rv = 0;
  U8 *s = MAlloc(len + 10);
  U8 *ss = MAlloc((len * 2) + 10);

  s = StrPrint(s,"%d", n);
  ss = StrPrint(ss,"%d%d", n, n);

  if (!ss) return FALSE;
  ss[2 * len - 1] = '\0';   // cut off the last char
  if (strstr(ss + 1, s) != NULL) {
    rv = TRUE;
  }

  Free(ss);
  Free(s);
  return rv;
}

I64 RangeRepeaterCnt(Range *r)
{
  I64 acc = 0;
  for (I64 i = r->s; i <= r->e; ++i) {
    if (IsRepeater(i)) {
      acc += i;
    }
  }
  return acc;
}

Bool MemCmp(U8 *s1, U8 *s2, I64 len)
{
  while (len) {
    if (*s1++ != *s2++) return s1 - s2;
    len--;
  }
  return 0;
}

Bool IsRepeatedTwice(I64 n)
{
  I64 len = NumDigits(n);
  U8 *s = MAlloc(len + 10);
  s = StrPrint(s,"%d", n);
  if (len % 2 != 0) return 0;
  I64 half = len / 2;
  Bool match = MemCmp(s, s + half, half) == 0;
  Free(s);
  return match;
}

I64 RangeRepeatedTwiceCnt(Range *r)
{
  I64 acc = 0;
  for (I64 i = r->s; i <= r->e; ++i) {
    if (IsRepeatedTwice(i)) {
      acc += i;
    }
  }
  return acc;
}

I64 Solve1(U8 *buffer)
{
  I64 acc = 0;
  Range r;
  while (*buffer != '\0' && *buffer != '\n') {
    MemSet(&r, 0, sizeof(Range));
    auto n = ParseRange(buffer, &r);
    buffer += n;
    acc += RangeRepeatedTwiceCnt(&r);
  } 
  return acc;
}

I64 Solve2(U8 *buffer)
{
  I64 acc = 0;
  Range r;
  while (*buffer != '\0' && *buffer != '\n') {
    MemSet(&r, 0, sizeof(Range));
    auto n = ParseRange(buffer, &r);
    buffer += n;
    acc += RangeRepeaterCnt(&r);
  } 
  return acc;
}

U0 Main()
{
  U8 *buffer = FileRead("./input.txt");
  "s1 = %lld\n", Solve1(buffer);
  "s2 = %lld\n", Solve2(buffer);
  Free(buffer);
}
