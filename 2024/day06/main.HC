#define UP    '^'
#define DOWN  'v'
#define LEFT  '<'
#define RIGHT '>'

#define OBSTICLE '#'
#define PATH     '.'
#define FREEDOM   420

class Board
{
  U8 **rows;
  I64 width, height;
};

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

U0 BoardRelease(Board *board)
{
  for (I64 i = 0; i < board->height; ++i) {
    Free(board->rows[i]);
  }
  Free(board->rows);
  Free(board);
}

Board *BoardNew(I64 width, I64 height)
{
  Board *board = MAlloc(sizeof(Board));
  I64 **entries = MAlloc(sizeof(I64 *)*height);
  for (I64 i = 0; i < height; ++i) {
    entries[i] = MAlloc(sizeof(I64)*width);
  }
  board->height = height;
  board->width = width;
  board->rows = entries;
  return board;
}

U0 BoardPrint(Board *b)
{
  for (I64 y = 0; y < b->height; y++) {
    for (I64 x = 0; x < b->width; x++) {
      "%c",b->rows[y][x];
    }
    "\n";
  }
}

U0 Parse(Board *board, U8 *buffer)
{
  I64 size = 0, idx = 0;
  for (U8 *ptr = buffer; *ptr; ptr++) {
    if (*ptr == '\n') {
      size++;
      idx = 0;
    } else {
      board->rows[size][idx++] = *ptr;
    }
  }
}

class Coord
{
  I64 x,y;
  I64 direction;
};

Coord *CoordNew(U0)
{
  Coord *c = MAlloc(sizeof(Coord));
  c->x = 0;
  c->y = 0;
  c->direction = UP;
  return c;
}

U0 CoordPrint(Coord *c)
{
  "y=%d y%=%d\n",c->y,c->y;
}

U0 FindStart(Board *b, Coord *c)
{
  for (c->y = 0; c->y < b->height; c->y++) {
    for (c->x = 0; c->x < b->width; c->x++) {
      if (b->rows[c->y][c->x] == UP) return;
    }
  }
}

/* When we hit an obsticle */
U0 ChangeDir(Coord *c)
{
  /* Set the direction and pull back */
  switch [c->direction] {
    case UP:    { c->direction = RIGHT; c->y++; break; }
    case DOWN:  { c->direction = LEFT;  c->y--; break; }
    case LEFT:  { c->direction = UP;    c->x++; break; }
    case RIGHT: { c->direction = DOWN;  c->x--; break; }
  }
}

Bool OutOfBounds(Board *board, Coord *c)
{
  if (c->y == 0 || c->y == board->height-1) return TRUE;
  if (c->x == 0 || c->x == board->width-1)  return TRUE;
  return FALSE;
}

I64 Travel(Board *board, Coord *c)
{
  board->rows[c->y][c->x] = 'X';
  switch [c->direction] {
    case UP:    c->y--; break;
    case DOWN:  c->y++; break;
    case LEFT:  c->x--; break;
    case RIGHT: c->x++; break;
  }
  
  I64 road = board->rows[c->y][c->x];

  if (road == '#') {
    ChangeDir(c);
    return OBSTICLE;
  }

  /* are we out of bounds? */
  if (OutOfBounds(board,c)) {
    board->rows[c->y][c->x] = '0';
    return FREEDOM;
  }

  return PATH;
}

I64 Part1(Board *board)
{
  I64 acc = 0;
  Coord *c = CoordNew;

  FindStart(board,c);

  while (Travel(board,c) != FREEDOM) ;

  for (I64 y = 0; y < board->height; y++) {
    for (I64 x = 0; x < board->width; x++) {
      if (board->rows[y][x] == 'X' || board->rows[y][x] == '0') acc++;
    }
  }

  return acc;
}

U0 Main()
{
  auto buffer = FileRead("./example.txt");
  if (!buffer) {
    "No buf!\n";
    Exit;
  }
  I64 width = 0, height = 0;
  Measure(buffer,&width,&height);
  Board *board = BoardNew(width,height);
  Parse(board,buffer);

  "parsed\n";
  "Part1: %d\n", Part1(board);
  BoardPrint(board);

  BoardRelease(board);
  Free(buffer);
}
