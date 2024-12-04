#define UP         0
#define UP_LEFT    1
#define UP_RIGHT   2
#define DOWN       3
#define DOWN_LEFT  4
#define DOWN_RIGHT 5
#define LEFT       6
#define RIGHT      7

#define LEN 4

class Board
{
  U8 **rows;
  I64 width, height;
};

class Dir
{
  I64 vertical;
  I64 horizontal;
};

U0 Measure(U8 *buffer, I64 *_width, I64 *_height)
{
  U8 *ptr = buffer;
  I64 width = 0;
  I64 height = 0;

  while (*ptr != '\n') {
    ptr++;
  }

  width = ptr-buffer;

  ptr = buffer;
  while (*ptr) {
    if (*ptr == '\n') height++;
    ptr++;
  }

  *_width = width;
  *_height = height;
}

Bool BoardBoundsChk(Board *b, I64 x, I64 y)
{
  if (x >= b->width  || x < 0) return FALSE;
  if (y >= b->height || y < 0) return FALSE;
  return TRUE;
}

Bool BoardChk(Board *b, I64 x, I64 y, I64 direction)
{
  Dir directions[] = {
    {-1,  0}, // UP
    {-1, -1}, // UP_LEFT
    {-1,  1}, // UP_RIGHT
    {1,   0}, // DOWN
    {1,  -1}, // DOWN_LEFT
    {1,   1}, // DOWN_RIGHT
    {0,   1}, // LEFT 
    {0,  -1}  // RIGHT
  };
  U8 *chk = NULL;

  if      (b->rows[y][x] == 'X') chk = "XMAS";
  else if (b->rows[y][x] == 'S') chk = "SAMX";
  else return FALSE;

  Dir *dir = &directions[direction];
  I64 _x = x, _y = y;
  I64 height_modifier = dir->vertical;
  I64 width_modifier = dir->horizontal;

  for (I64 i = 0; i < LEN; ++i) {
    if (!BoardBoundsChk(b,_x,_y)) { 
      return FALSE;
    }
    if (b->rows[_y][_x] != chk[i]) {
      return FALSE;
    }
    _y += dir->vertical;
    _x += dir->horizontal;
  }

  return TRUE;
}

I64 BoardChkAllDirs(Board *b, I64 x, I64 y)
{
  I64 len = 8;
  I64 acc = 0;
  for (I64 i = 0; i < len; ++i) {
    if (BoardChk(b,x,y,i)) {
      acc++;
    }
  }
  return acc;
}

I64 BoardChkX(Board *b, I64 x, I64 y)
{ /* This is not fancy */
  if (b->rows[y][x] != 'A') return FALSE;

  I64 top = x-1;
  I64 bottom = x+1;
  I64 left = y-1;
  I64 right = y+1;

  if (!BoardBoundsChk(b,top,right)) return FALSE;
  if (!BoardBoundsChk(b,top,left)) return FALSE;
  if (!BoardBoundsChk(b,bottom,right)) return FALSE;
  if (!BoardBoundsChk(b,bottom,left)) return FALSE;

  if      (b->rows[left][top] == 'M' && b->rows[right][bottom] == 'S' && b->rows[right][top] == 'S' && b->rows[left][bottom] == 'M') return TRUE;
  else if (b->rows[left][top] == 'M' && b->rows[right][bottom] == 'S' && b->rows[right][top] == 'M' && b->rows[left][bottom] == 'S') return TRUE;
  else if (b->rows[left][top] == 'S' && b->rows[right][bottom] == 'M' && b->rows[right][top] == 'S' && b->rows[left][bottom] == 'M') return TRUE;
  else if (b->rows[left][top] == 'S' && b->rows[right][bottom] == 'M' && b->rows[right][top] == 'M' && b->rows[left][bottom] == 'S') return TRUE;
  else return FALSE;
}

Board *SplitToBoard(U8 *buffer)
{
  Board *board = MAlloc(sizeof(Board));
  I64 size = 0;
  I64 capacity = 10;
  U8 *ptr = buffer;
  U8 **entries = MAlloc(sizeof(U8*)*capacity);
  U8 *buf = MAlloc(sizeof(U8) * 10);
  U8 *dst = buf;
  Measure(buffer,&board->width,&board->height);

  while (*ptr) {
    if (*ptr == '\n') {
      if (size+1 >= capacity) {
        capacity *= 2;
        entries = ReAlloc(entries, sizeof(U8*)*capacity);
      }
      entries[size++] = buf;
      buf = MAlloc(sizeof(U8) * 10);
      dst = buf;
      ptr++;
    } else {
      SPutChar(&dst,*ptr,&buf);
      ptr++;
    }
  }
  board->rows = entries;
  return board;
}

U0 BoardRelease(Board *board)
{
  for (I64 i = 0; i < board->height; ++i) {
    Free(board->rows[i]);
  }
  Free(board->rows);
  Free(board);
}

I64 Part1(Board *board)
{
  I64 acc = 0;
  for (I64 i = 0; i < board->height; ++i) {
    for (I64 j = 0; j < board->width; ++j) {
      acc += BoardChkAllDirs(board,j,i);
    }
  }

  /* Divide by 2 as I double count everything :D */
  return acc/2;
}

I64 Part2(Board *board)
{
  I64 acc = 0;
  for (I64 i = 0; i < board->height; ++i) {
    for (I64 j = 0; j < board->width; ++j) {
      if (BoardChkX(board,j,i)) acc++;
    }
  }
  return acc;
}

U0 Main()
{
  U8 *buffer = FileRead("./input.txt");
  Board *b = SplitToBoard(buffer);
  "Part1: %d\n", Part1(b);
  "Part2: %d\n", Part2(b);

  BoardRelease(b);
  Free(buffer);
}
