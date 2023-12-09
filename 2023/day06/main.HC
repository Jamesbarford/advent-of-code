I64 NumbersInLine(U8 *ptr)
{
  I64 len = 0;
  while (*ptr != '\n') {
    if ('0' <= *ptr <= '9') {
      while ('0' <= *ptr <= '9') {
        ptr++;
      }
      len++;
    }
    if (*ptr == '\n') {
      return len;
    }
    ptr++;
  }
  return len;
}

I64 Part1(U8 *ptr, I64 len)
{
  I64 x = 0, y = 0, num = 0;
  I64 *counts = MAlloc(sizeof(I64)*4000);
  I64 count = 0, d,t,cur,acc=1;
  I64 *times = MAlloc(sizeof(I64)*len);
  I64 *distance = MAlloc(sizeof(I64)*len);

  while (*ptr) {
    if ('0' <= *ptr <= '9') {
      num = 0;
      while ('0' <= *ptr <= '9') {
        num *= 10;
        num += *ptr - '0';
        ptr++;
      }

      if (y == 0) {
        times[x++] = num;
      }
      if (y == 1) {
        distance[x++] = num;
      }
    }
    if (*ptr == '\n') {
      y = 1;
      x = 0;
    } 
    ptr++;
  }

  for (I64 i = 0; i < len; ++i) {
    t = times[i];
    d = distance[i];
    "T:%d D:%d\n",t,d;
    for (I64 j = 0; j < t; ++j) {
      cur = j * (t - j);
      if (cur > d) {
        count++;
      }
    }
    counts[i] = count; 
    count = 0;
  }

  for (I64 i = 0; i < len; ++i) {
    "%d\n",counts[i];
    acc *= counts[i];
  }
  "part1: %ld\n",acc;

  return acc;
}

U64 Part2(U8 *ptr)
{
  U64 x = 0, y = 0, num = 0, len = 1;
  U64 *counts = MAlloc(sizeof(I64)*4000);
  U64 count = 0, d,t,cur,acc=1;
  U64 *times = MAlloc(sizeof(I64)*len);
  U64 *distance = MAlloc(sizeof(I64)*len);

  while (*ptr) {
    if ('0' <= *ptr <= '9') {
      while ('0' <= *ptr <= '9') {
        num *= 10;
        num += *ptr - '0';
        ptr++;
      }

      if (*ptr == '\n') { 
        if (y == 0) {
          times[x++] = num;
        }
        if (y == 1) {
          distance[x++] = num;
        }
      }
    }

    if (*ptr == '\n') {
      y = 1;
      x = 0;
      num = 0;
    } 
    ptr++;
  }

  for (I64 i = 0; i < len; ++i) {
    t = times[i];
    d = distance[i];
    "T:%zu D:%zu\n",t,d;
    for (U64 j = 0; j < t; ++j) {
      cur = j * (t - j);
      if (cur > d) {
        count++;
      }
    }
    counts[i] = count; 
    count = 0;
  }

  for (U64 i = 0; i < len; ++i) {
    "%d\n",counts[i];
    acc *= counts[i];
  }
  return acc;
}

U0 Main()
{
  I64 len,pt1,pt2;
  U8 *buffer  = FileRead("./input.txt", 4000, &len);
  len = NumbersInLine(buffer);
  pt1 = Part1(buffer,len);
  pt2 = Part2(buffer,len);
  "part1: %ld\n",pt1;
  "part2: %zu\n",pt2;
}
