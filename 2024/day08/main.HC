#define ANTENNA  0
#define ANTINODE 1

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
  IntSet *antenna;
  IntMap *antennas;
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
      "%c",b->rows[y][x];
    }
    "\n";
  }
}

Bool IsAntenna(U8 ch)
{
  return 'a'<=ch<='z' ||
         'A'<=ch<='Z' ||
         '0'<=ch<='9';
}

U64 HashAntenna(U8 ch, U8 x, U8 y)
{
  return (y << 16) | (x << 8) | ch;
}

U64 HashCoord(Coord *c)
{
  return (c->y << 16) | (c->x << 8) | c->ch;
}

U0 UnHashAntenna(U64 hash, Coord *c)
{
  c->y = (hash >> 16) & 0xFF;
  c->x = (hash >> 8) & 0xFF;
  c->ch = hash & 0xFF;
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
  board->antenna = IntSetNew;
  board->antennas = IntMapNew;
  for (U8 *ptr = buffer; *ptr; ptr++) {
    if (*ptr == '\n') {
      y++;
      x = 0;
    } else {
      board->rows[y][x] = *ptr;

      if (IsAntenna(*ptr)) {
        U64 hash = HashAntenna(*ptr, x, y);
        IntVec *vec = IntMapGet(board->antennas, *ptr);
        if (!vec) {
          vec = IntVecNew;
          IntMapSet(board->antennas, *ptr, vec);
        }
        IntVecPush(vec, hash);
        IntSetAdd(board->antenna,HashAntenna(*ptr,x,y));
      }
      x++;
    }
  }
  return board;
}

Bool OutOfBounds(Board *board, Coord *c)
{
    return (c->y < 0 || c->y >= board->height || 
            c->x < 0 || c->x >= board->width);
}

I64 Abs(I64 x)
{
  if (x < 0) return -x;
  return x;
}

I64 Gcd(I64 a, I64 b)
{
    if (b == 0) return a;
    return Gcd(b, a % b);
}

U0 CoordVecPrint(IntVec *vec)
{
  Coord c;
  "[";
  for (I64 i = 0; i < vec->size; ++i) {
    U64 hash = vec->entries[i];
    UnHashAntenna(hash,&c);
    "(%lld, %lld)", c.y, c.x;
    if (i+1 != vec->size) {
      ", ";
    }
  }
  "]\n";
}

IntSet *Part1(Board *board)
{
  Coord c1,c2,antinode;
  IntSetIter *it = IntSetIterNew(board->antenna);
  IntSetEntry *entry = NULL;
  IntSet *antinodes = IntSetNew;

  while ((entry = IntSetIterNext(it))) {
    UnHashAntenna(entry->key,&c1);

    IntVec *vec = IntMapGet(board->antennas, c1.ch);
    if (!vec) continue;


    for (I64 i = 0; i < vec->size; ++i) {
      U64 hash2 = vec->entries[i];
      /* skip self */
      if (entry->key == hash2) continue;

      UnHashAntenna(hash2, &c2);

      I64 dx = c2.x - c1.x;
      I64 dy = c2.y - c1.y;

      antinode.x = c1.x - dx;
      antinode.y = c1.y - dy;
      if (!OutOfBounds(board, &antinode)) {
        IntSetAdd(antinodes, HashCoord(&antinode));
      }

      antinode.x = c2.x + dx;
      antinode.y = c2.y + dy;
      if (!OutOfBounds(board, &antinode)) {
        IntSetAdd(antinodes, HashCoord(&antinode));
      }

    }
  }

  IntSetIterRelease(it);
  return antinodes;
}

IntSet *Part2(Board *board)
{
  Coord c1,c2,antinode;
  IntSet *antinodes = IntSetNew;
  IntMapNode *n = NULL;

  for (I64 idx = 0; IntMapIter(board->antennas,&idx,&n); ) {
    IntVec *vec = n->value(IntVec *);

    for (I64 i = 0; i < vec->size-1; ++i) {
      for (I64 j = 1; j < vec->size; ++j) {
        U64 hash = vec->entries[i];
        U64 hash2 = vec->entries[j];

        UnHashAntenna(hash, &c1);
        UnHashAntenna(hash2, &c2);

        I64 dy = c1.y - c2.y;
        I64 dx = c1.x - c2.x;
        /* XXX: this is me doing something very silly */
        if (dx == 0 && dy == 0) continue;
        I64 gcd = Gcd(Abs(dx), Abs(dy));
        dx /= gcd;
        dy /= gcd;


        I64 i = 0;
        while (1) {
          antinode.y = c2.y + dy * i;
          antinode.x = c2.x + dx * i;
          if (!OutOfBounds(board, &antinode)) {
            IntSetAdd(antinodes, HashCoord(&antinode));
            i++;
          } else {
            break;
          }
        }

        i = 0;
        while (1) {
          antinode.y = c1.y - dy * i;
          antinode.x = c1.x - dx * i;
          if (!OutOfBounds(board, &antinode)) {
            IntSetAdd(antinodes, HashCoord(&antinode));
            i++;
          } else {
            break;
          }
        }
      }
    }
  }

  return antinodes;
}

U0 Main()
{
  U8 *buffer = FileRead("./input.txt");
  Board *board = Parse(buffer);

  auto antinodes_pt1 = Part1(board);
  "Part1: %d\n", antinodes_pt1->tree->size;

  auto antinodes_pt2 = Part2(board);
  "Part2: %d\n", antinodes_pt2->tree->size;

  IntSetRelease(antinodes_pt1);
  IntSetRelease(antinodes_pt2);

  BoardRelease(board);
  Free(buffer);
}
