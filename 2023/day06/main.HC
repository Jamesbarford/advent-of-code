U0 Main()
{
  I64 len;
  U8 *buffer  = FileRead("./sample.txt", 4000, &len);
  I64 times[3];
  I64 distance[3];
  I64 x = 0, y = 0, num = 0;
  U8 *ptr = buffer;
  I64 *counts = MAlloc(sizeof(I64)*4000);
  I64 count = 0;
  I64 d,t,cur;

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

out:
  I64 acc = 1;
  for (I64 i = 0; i < 3;++i) {
    t = times[i];
    d = distance[i];
    for (I64 j = 0; j < t; ++j) {
      cur = j * (t - j);
      if (cur > d) {
        count++;
      }
    }
    counts[i] = count; 
  }

  for (I64 i = 0; i < 3; ++i) {
    acc *= count[i];
  }
  "%ld\n",acc;
}
