U0 Measure(U8 *buffer, I64 *_width, I64 *_height)
{
  U8 *ptr = buffer;
  I64 width = 0;
  I64 height = 0;

  while (*ptr != '\n') ptr++;

  width = ptr-buffer;

  ptr = buffer;
  while (*ptr) {
    if (*ptr == '\n') height++;
    ptr++;
  }

  *_width = width;
  *_height = height;
}

class Board
{
  U8 **rows;
  I64 width, height;
};

class Coord
{
  U8 ch;
  I64 x;
  I64 y;
};


U0 BoardRelease(Board *board)
{
  for (I64 i = 0; i < board->height; ++i) {
    Free(board->rows[i]);
  }
  Free(board->rows);
  Free(board);
}

U0 BoardPrint(Board *b)
{
  for (I64 y = 0; y < b->height; y++) {
    for (I64 x = 0; x < b->width; x++) {
      if (b->rows[y][x] == '.') ".";
      else "%d",b->rows[y][x];
    }
    "\n";
  }
}

Board *Parse(U8 *buffer)
{
  I64 y = 0, x = 0;
  Board *board = MAlloc(sizeof(Board));
  Measure(buffer,&board->width,&board->height);
  I64 **rows = MAlloc(sizeof(I64 *)*board->height);
  for (I64 i = 0; i < board->height; ++i) {
    rows[i] = MAlloc(sizeof(I64)*board->width);
  }
  board->rows = rows;

  for (U8 *ptr = buffer; *ptr; ptr++) {
    if (*ptr == '\n') {
      y++;
      x = 0;
    } else {
      if ('0'<=*ptr<='9') {
        board->rows[y][x] = *ptr-'0';
      } else {
        board->rows[y][x] = *ptr;
      }
      x++;
    }
  }
  return board;
}

Bool BoardBoundsChk(Board *b, I64 y, I64 x)
{
  if (x >= b->width  || x < 0) return FALSE;
  if (y >= b->height || y < 0) return FALSE;
  return TRUE;
}

U64 HashXY(U8 Y, U8 X, U8 num, U8 cnt)
{
  return X << 24 | Y << 16 | num << 8 | cnt;
}

U0 UnHashXY(U64 hash, I64 *_y, I64 *_x, I64 *_num, I64 *_cnt)
{
  *_x = hash >> 24 & 0xFF;
  *_y = hash >> 16 & 0xFF;
  *_num = hash >> 8 & 0xFF;
  *_cnt = hash & 0xFF;
}


U0 QueueAll(Board *board, List * Q, I64 y, I64 x, I64 num, I64 cnt)
{
  I64 directions[4][2] = {
    {-1,  0}, // UP
    {1,   0}, // DOWN
    {0,   1}, // LEFT 
    {0,  -1}  // RIGHT
  };
  for (I64 i = 0; i < 4; ++i) {
    I64 yy = y + directions[i][0];
    I64 xx = x + directions[i][1];
    if (BoardBoundsChk(board,yy,xx)) {
      U64 hash = HashXY(yy,xx,num,cnt);
      ListAppend(Q,hash(U0*));
    }
  }
}

I64 IsPath(IntSet *seen = NULL, Board *board, I64 y, I64 x)
{
  List *Q = ListNew;
  U64 hash;
  I64 yy, xx, acc = 0, num, cnt;

  QueueAll(board,Q,y,x,0,8);

  while (!ListEmpty(Q)) {
    hash = ListPop(Q)(U64);
    UnHashXY(hash,&yy,&xx,&num,&cnt);

    if (cnt < 0) continue;
    if (seen != NULL) {
      if (IntSetHas(seen,hash)) continue;
      IntSetAdd(seen,hash);
    }

    I64 next_num = board->rows[yy][xx];
    if (next_num == 9 && cnt == 0) {
      acc++;
    } else if (next_num == num+1) {
      QueueAll(board,Q,yy,xx,next_num,cnt-1);
    }
  }

  ListRelease(Q,NULL);
  return acc;
}

I64 Part1(Board *board)
{
  I64 acc = 0;

  for (I64 y = 0; y < board->height; ++y) {
    for (I64 x = 0; x < board->width; ++x) {
      I64 num = board->rows[y][x];
      if (num == 0) {
        IntSet *seen = IntSetNew;
        acc += IsPath(seen,board,y,x);
        IntSetRelease(seen);
      }
    }
  }

  return acc;
}

I64 Part2(Board *board)
{
  I64 acc = 0;

  for (I64 y = 0; y < board->height; ++y) {
    for (I64 x = 0; x < board->width; ++x) {
      I64 num = board->rows[y][x];
      if (num == 0) {
        acc += IsPath(,board,y,x);
      }
    }
  }

  return acc;
}

U8 *buffer = FileRead("./input.txt");
Board *board = Parse(buffer);

"Part1: %lld\n", Part1(board);
"Part2: %lld\n", Part2(board);

BoardRelease(board);
Free(buffer);
