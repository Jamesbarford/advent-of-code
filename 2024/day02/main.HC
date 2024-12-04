I64 Abs(I64 i)
{
  if (i > 0) return i;
  return -i;
}

Bool IsSafeDiff(I64 i1, I64 i2)
{
  I64 abs_diff = Abs(i1 - i2);
  return abs_diff <= 3;
}

#define START 0
#define ASC   1
#define DESC  2

Bool IsSafe(IntVec *vec)
{
  I64 len = vec->size;
  I64 i = 0;
  I64 j = 1;
  I64 state = START;

  while (i < len-1) {
    I64 i1 = vec->entries[i];
    I64 i2 = vec->entries[j];

    /* easier to check here and applicable for all cases */
    if (!IsSafeDiff(i1,i2)) {
      return FALSE;
    }

    switch (state) {
      /* Set the state to decide which way we are going */
      case START: {
        if (i1 > i2) {
          state = DESC;
          break;
        }
        if (i1 < i2) {
          state = ASC;
          break;
        }
        return FALSE;
      }

      case ASC: {
        if (i1 < i2) break;
        return FALSE;
      }

      case DESC: {
        if (i1 > i2) break;
        return FALSE;
      }
    }
    ++i;
    ++j;
  }

  return TRUE; 
}

U0 ParseLine(U8 *line, IntVec *vec)
{
  U8 *ptr = line;
  U8 tmp[64];
  U8 *tmp_ptr = tmp;
  while (1) {
    if (IsSpace(*ptr) || *ptr == '\0') {
      *tmp_ptr = '\0';
      I64 i = Atoi(tmp);
      IntVecPush(vec,i);
      tmp_ptr = tmp;
      if (*ptr == '\0') break;
      ptr++;
    } else {
      *tmp_ptr++ = *ptr++;
    }
  }
}

I64 Part1(U8 *buffer)
{
  U8 tmp[128];
  U8 *ptr = buffer;
  U8 *tmp_ptr = tmp;
  IntVec *vec = IntVecNew;
  I64 acc = 0;

  while (*ptr) {
    *tmp_ptr++ = *ptr++;
    if (*ptr == '\n') {
      *tmp_ptr = '\0';
      IntVecClear(vec);
      ParseLine(tmp,vec);
      if (IsSafe(vec)) {
        acc++;
      }
      tmp_ptr = tmp;
      ptr++;
    }
  }

  IntVecRelease(vec);
  return acc;
}

Bool IsSafePart2()
{

  return FALSE;
}

I64 Part2(U8 *buffer)
{
  U8 tmp[128];
  U8 *ptr = buffer;
  U8 *tmp_ptr = tmp;
  IntVec *vec = IntVecNew;
  I64 acc = 0;

  while (*ptr) {
    *tmp_ptr++ = *ptr++;
    if (*ptr == '\n') {
      *tmp_ptr = '\0';
      IntVecClear(vec);
      ParseLine(tmp,vec);
      /* XXX: Solve part2 */

      tmp_ptr = tmp;
      ptr++;
    }
  }

  IntVecRelease(vec);
  return acc;
}

U0 Main(U0)
{
  U8 *buffer = FileRead("./.txt");
  "%d\n", Part1(buffer);
  "%d\n", Part2(buffer);
  Free(buffer);
}
