I64 ParseOutNumber(U8 **buf, U8 terminator, Bool *_ok)
{
  U8 tmp[64];
  U8 *tmp_ptr = tmp;
  Bool ok = TRUE;
  I64 num = -1;
  U8 *ptr = *buf;

  while (*ptr) {
    if (*ptr == terminator) break;
    else if ('0'<=*ptr<='9') *tmp_ptr++ = *ptr;
    else { ok = FALSE; break; } 
    ptr++;
  }

  *tmp_ptr = '\0';
  if (ok && (tmp_ptr - tmp)(I64) <= 3) {
    num = Atoi(tmp);
  }

  *buf = ptr;
  *_ok = ok;
  return num;
}

I64 Part1(U8 *buffer)
{
  U8 *ptr = buffer;
  Bool ok = TRUE;
  I64 num1,num2,acc;
  
  acc = 0;
  while (*ptr) {
    if (!StrNCmp(ptr,"mul(",4)) {
      ptr += 4;
      num1 = ParseOutNumber(&ptr,',',&ok);
      if (!ok && *ptr != ',') {
        continue;
        ptr++;
      }
      /* move past ',' */
      ptr++;
      num2 = ParseOutNumber(&ptr,')',&ok);
      if (ok) {
        acc += (num1*num2);
      }
    }
    ptr++;
  }
  return acc;
}

#define STATE_COLLECT 1
#define STATE_SKIP    0

I64 Part2(U8 *buffer)
{
  U8 *ptr = buffer;
  Bool ok = TRUE;
  I64 num1,num2,acc,state;

  acc = 0;
  state = STATE_COLLECT;

  while (*ptr) {
    if (!StrNCmp(ptr,"mul(",4) && state == STATE_COLLECT) {
      ptr += 4;
      num1 = ParseOutNumber(&ptr,',',&ok);
      if (!ok && *ptr != ',') {
        continue;
        ptr++;
      }
      /* move past ',' */
      ptr++;
      num2 = ParseOutNumber(&ptr,')',&ok);
      if (ok) {
        acc += (num1*num2);
      }
    } else if (!StrNCmp(ptr,"don't(",6)) {
      state = STATE_SKIP;
      ptr += 5;
    } else if (!StrNCmp(ptr,"do(",3)) {
      state = STATE_COLLECT;
      ptr += 2;
    }
    ptr++;
  }
  return acc;
}

U0 Main()
{
  U8 *buffer = FileRead("./input.txt");
  "Part1 = %d\n", Part1(buffer);
  "Part2 = %d\n", Part2(buffer);
  Free(buffer);
}
