#define UP    '^'
#define DOWN  'v'
#define LEFT  '<'
#define RIGHT '>'

#define OBSTICLE '#'
#define PATH     '.'
#define FREEDOM  420
#define BOULDER  'O'

#define SET_CAPACITY (1<<10)

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

class SetNode;
class SetNode
{
  U64 value;
  SetNode *next;
};

class Set
{
  I64 size;
  SetNode **entries;
};

Set *SetNew(U0)
{
  Set *s = MAlloc(sizeof(Set));
  s->entries = CAlloc(sizeof(SetNode*)*SET_CAPACITY);
  s->size = 0;
  return s;
}

Bool SetHas(Set *set, U64 value)
{
  for (SetNode *sn = set->entries[value & (SET_CAPACITY-1)]; sn; sn = sn->next) {
    if (sn->value == value) return TRUE;
  }
  return FALSE;
}

U0 SetAdd(Set *set, U64 value)
{
  U64 hash = value & (SET_CAPACITY-1);
  for (SetNode *sn = set->entries[hash]; sn; sn = sn->next) {
    if (sn->value == value) return;
  }
  SetNode *new_node = MAlloc(sizeof(SetNode));
  new_node->value = value;
  new_node->next = set->entries[hash];
  set->entries[hash] = new_node;
}

U0 SetRelease(Set *set)
{
  for (I64 i = 0; i < SET_CAPACITY; ++i) {
    for (SetNode *sn = set->entries[i]; sn; sn = sn->next) {
      Free(sn);
    }
  }
  Free(set->entries);
  Free(set);
}

class Board
{
  U8 **rows;
  I64 width, height;
};


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

Board *BoardCpy(Board *board)
{
  Board *cpy = BoardNew(board->width,board->height);
  for (I64 i = 0; i < board->height; ++i) {
    MemCpy(cpy->rows[i],board->rows[i],sizeof(I64)*board->width);
  }
  return cpy;
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
  "y=%d x%=%d\n",c->y,c->x;
}

U64 CoordHash(Coord *c)
{
  return c->x << 24 | c->y << 16 | c->direction;
}

U64 CoordHashNoDir(Coord *c)
{
  return c->x << 16 | c->y;
}

U0 FindStart(Board *b, Coord *c)
{
  for (c->y = 0; c->y < b->height; c->y++) {
    for (c->x = 0; c->x < b->width; c->x++) {
      if (b->rows[c->y][c->x] == UP) return;
    }
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

  if (road == '#' || road == 'O') {
    /* Set the direction and pull back */
    switch [c->direction] {
      case UP:    { c->direction = RIGHT;c->y++;  break; }
      case DOWN:  { c->direction = LEFT; c->y--;  break; }
      case LEFT:  { c->direction = UP;   c->x++;  break; }
      case RIGHT: { c->direction = DOWN; c->x--;  break; }
    }
    return OBSTICLE;
  }

  /* are we out of bounds? */
  if (OutOfBounds(board,c)) {
    board->rows[c->y][c->x] = '@';
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

  Free(c);
  return acc;
}

Bool IsLoop(Board *board, Coord *c)
{
  Set *set = SetNew;

  while (1) {
    I64 result = Travel(board,c);
    if (result == FREEDOM) break;
    else if (result == '#' || result == 'O') {
      U64 hash = CoordHash(c);
      if (SetHas(set,hash)) {
        SetRelease(set);
        return TRUE;
      }
      SetAdd(set,hash);
    }
  }
  return FALSE;
}

Bool PlaceObsticle(Board *b, Set *placements, Coord *c)
{
  /* Find next place */
  while (SetHas(placements, CoordHashNoDir(c))) {
    if (c->x + 1 == b->width) {
      if (c->y + 1 == b->height) return TRUE;
      c->x = 0;
      c->y++;
    } else {
      c->x++;
    }
  }
  b->rows[c->y][c->x] = 'O';
  SetAdd(placements,CoordHashNoDir(c));
  return FALSE;
}

I64 Part2(Board *board)
{
  I64 acc = 0;
  Coord *c = CoordNew;
  Coord *obsticle_location = CoordNew;
  Set *placements = SetNew;
  Board *cpy = BoardCpy(board);

  FindStart(cpy,c);
  I64 iter = 0;

  I64 start_x = c->x;
  I64 start_y = c->y;

  while (!PlaceObsticle(cpy,placements,obsticle_location)) {
    Bool is_loop = IsLoop(cpy,c);
    if (is_loop) {
      acc++;
    }
    BoardRelease(cpy);
    cpy = BoardCpy(board);

    c->y = start_y;
    c->x = start_x;
    c->direction = UP;
  }

  BoardRelease(cpy);
  Free(c);
  Free(obsticle_location);
  SetRelease(placements);
  return acc;
}

U0 Main()
{
  auto buffer = FileRead("./input.txt");
  if (!buffer) {
    "No buf!\n";
    Exit;
  }
  I64 width = 0, height = 0;
  Measure(buffer,&width,&height);
  Board *board = BoardNew(width,height);
  Parse(board,buffer);
  Board *cpy = BoardCpy(board);

  "Part1: %d\n", Part1(board);
  "Part2: %d\n", Part2(cpy);

  BoardRelease(board);
  BoardRelease(cpy);
  Free(buffer);
}
