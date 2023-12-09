#define GEAR     0
#define MODIFIER 1000

class Matrix 
{
  I64 rows;
  I64 cols;
  I64 xx; /* Current x */
  I64 yy; /* Current y */
  I64 *data;
};

/**
 * Bit pattern:
 * U  D
 * 0000
 *  LR
 *
 * Works it's way round clockwise
 */
I64 DIRS[8] = {
  0x8, /* 1000 U  */
  0xA, /* 1010 UR */
  0x2, /* 0010 R  */
  0x3, /* 0011 DR */
  0x1, /* 0001 D  */
  0x5, /* 0101 DL */
  0x4, /* 0100 L  */
  0xC, /* 1100 UL */
};

Matrix *MatrixNew(I64 rows, I64 cols)
{
  Matrix *m = MAlloc(sizeof(Matrix));
  m->rows = rows;
  m->cols = cols;
  m->data = MAlloc(sizeof(I64) * rows * cols);
  return m;
}

U0 MatrixFree(Matrix *m)
{
  Free(m->data);
  Free(m);
}

Bool InBounds(Matrix *m, I64 x, I64 y)
{
  return (0 <= x < m->cols) && 
         (0 <= y < m->rows);
}

U0 MatrixPrint(Matrix *m)
{
  for (I64 y = 0; y < m->rows; ++y) {
    for (I64 x = 0; x < m->cols; ++x) {
      "%d ", m->data[x+(y * m->cols)];
    }
    "\n";
  }
}

I64 LineLen(U8 *ptr)
{ /* Get length of a line */
  I64 len = 0;
  while (*ptr != '\n') {
    ptr++;
    len++;
  }
  return len;
}

I64 RowCount(U8 *ptr)
{ /* count number of rows */
  I64 *rows = 0;
  while (*ptr) {
    if (*ptr == '\n') {
      rows++;
    }
    ptr++;
  }
  return rows;
}

I64 ParseNumber(U8 *buffer, I64 *_len)
{
  /* A do while would be really nice here */
  I64 number = *buffer++ - '0';
  I64 len = 0;
  while ('0' <= *buffer <= '9') {
    number *= 10;
    number += *buffer++ - '0';
    len++;
  }
  *_len = len;
  return number;
}

Matrix *FileToMatrix(U8 *buffer)
{ /* Create data structure from file */
  I64 cols = LineLen(buffer);
  I64 rows = RowCount(buffer);
  Matrix *m = MatrixNew(rows, cols);
  I64 x = 0;
  I64 y = 0;
  I64 num = 0;
  I64 len;

  while (*buffer) {
    if ('0' <= *buffer <= '9') {
      num = ParseNumber(buffer,&len);
      buffer+=len;
      /* Pad out adjecent cells with the same number, saves messing around with
       * it later which turned out to be pretty difficult */
      while (len-- >= 0) { 
        m->data[x+++(y*m->cols)] = num;
      }
    } else {
      /* I don't think this is readible. It is, however, possible.
       * -99 to normalise the input */
      if (*buffer == '*') {
        m->data[x+++(y*m->cols)] = GEAR; 
      } else {
        m->data[x+++(y*m->cols)] = *buffer-MODIFIER;
      }
    }

    if (*(buffer + 1) == '\n') {
      x = 0;
      y++;
      buffer++;
    }
    buffer++;
  }

  return m;
}

U0 EmitCoord(Matrix *c, I64 idx)
{
  I64 movement = DIRS[idx];
  I64 u = (movement >> 3) & 1;
  I64 d = movement & 1;
  I64 l = (movement >> 2) & 1;
  I64 r = (movement >> 1) & 1;
  if (u) c->yy--;
  if (d) c->yy++;
  if (l) c->xx--;
  if (r) c->xx++;
}

Bool IsAdjacent(Matrix *m, I64 x, I64 y)
{
  for (I64 i = 0; i < 8; ++i) {
    m->yy = y;
    m->xx = x;
    EmitCoord(m,i);
    if (InBounds(m,m->xx,m->yy)) {
      I64 next = m->data[m->xx+(m->yy * m->cols)];
      if (next <= 0 && next != ('.'-MODIFIER)) {
        return TRUE;
      }
    }
  }
  return FALSE;
}

I64 SolvePart1(Matrix *m)
{
  I64 cur = 0;
  I64 xx;
  I64 yy;
  I64 count = 0;

  for (I64 y = 0; y < m->rows; ++y) {
    for (I64 x = 0; x < m->cols; ++x) {
      cur = m->data[x+(y*m->cols)];
      if (cur > 0 && IsAdjacent(m,x,y)) {
        count += cur;
        while ((cur = m->data[x+(y * m->cols)]) > 0) {
          ++x;
        }
      }
    }
  }
  return count;
}

Bool ArrayContains(I64 *arr, I64 len, I64 num)
{
  for (I64 j = 0; j < len; ++j) {
    if (arr[j] == num) {
      return TRUE;
    }
  }
  return FALSE;
}

Bool IsAdjacentToGear(Matrix *m, I64 x, I64 y)
{
  I64 count = 0;
  I64 seen[8];

  for (I64 i = 0; i < 8; ++i) {
    m->yy = y;
    m->xx = x;
    EmitCoord(m,i);
    if (InBounds(m,m->xx,m->yy)) {
      I64 next = m->data[m->xx+(m->yy * m->cols)];
      if (next > GEAR && !ArrayContains(seen,count,next)) {
        seen[count++] = next; 
      }
    }
  }

  if (count == 2) {
    return seen[0] * seen[1];
  }
  return 0;
}

I64 SolvePart2(Matrix *m)
{
  I64 count = 0;
  I64 cur = 0;
  for (I64 y = 0; y < m->rows; ++y) {
    for (I64 x = 0; x < m->cols; ++x) {
      cur = m->data[x+(y*m->cols)];
      if (cur == GEAR) {
        count += IsAdjacentToGear(m,x,y);
      }
    }
  }
  return count;
}

U0 Main()
{
  I64 len;
  I64 answer;
  U8 *buffer = FileRead("./input.txt", 50000, &len);
  U8 *ptr = buffer;
  Matrix *m = FileToMatrix(buffer);

  answer = SolvePart1(m);
  "pt1: %d\n",answer;

  answer = SolvePart2(m);
  "pt2: %d\n",answer;
  MatrixFree(m);
  Free(buffer);
}
