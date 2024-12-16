#define MAX 200

class Coord
{
  I64 x,y;
};

I64 rows;
I64 cols;
I64 grid_size;
U8 grid[MAX][MAX];
Bool visited[MAX][MAX];

Coord *CoordAlloc(I64 y, I64 x)
{
  Coord *coord = MAlloc(sizeof(Coord));
  coord->x = x;
  coord->y = y;
  return coord;
}

U0 Measure(U8 *buffer, I64 *_width, I64 *_height)
{
  for (U8 *ptr = buffer; *ptr != '\n'; ptr++) {
    (*_width)++;
  }
  for (U8 *ptr = buffer; *ptr; ptr++) {
    if (*ptr == '\n') {
      (*_height)++;
    }
  }
}

I64 **NxN(I64 N)
{
  I64 **M = MAlloc(sizeof(I64*)*N);
  for (I64 i = 0; i < N; ++i) {
    M[i] = CAlloc(sizeof(I64)*N);
  }
  return M;
}

U0 NxNFree(I64 **M, I64 N)
{
  for (I64 i = 0; i < N; ++i) {
    Free(M[i]);
  }
  Free(M);
}

U0 Init()
{
  U8 *buffer = FileRead("./input.txt");
  Measure(buffer,&rows,&cols);
  grid_size = 0;
  I64 x = 0, y = 0;
  for (U8 *ptr = buffer; *ptr; ptr++) {
    if (*ptr == '\n') {
      y++;
      x = 0;
    } else {
      grid[y][x] = *ptr;
      visited[y][x] = FALSE;
      x++;
    }
  }
  grid_size = y;
  Free(buffer);
}

Bool IsValid(I64 x, I64 y, U8 type)
{
  Bool has_visited = visited[x][y];
  return x >= 0 && x < rows && y >= 0 && y < cols && 
    grid[x][y] == type && !has_visited;
}

U0 DFS(I64 x, I64 y, U8 type, I64 *area, I64 *perimeter)
{
  I64 dx[] = {-1, 1, 0, 0};
  I64 dy[] = {0, 0, -1, 1};
  visited[x][y] = TRUE;
  (*area)++;

  for (I64 i = 0; i < 4; i++) {
    I64 nx = x + dx[i];
    I64 ny = y + dy[i];
    if (IsValid(nx, ny, type)) {
      DFS(nx, ny, type, area, perimeter);
    } else if (nx < 0 || nx >= rows || ny < 0 || ny >= cols || grid[nx][ny] != type) {
      (*perimeter)++;
    }
  }
}

// Calculate the total price of fencing all regions
I64 Part1()
{
  I64 total = 0;
  for (I64 i = 0; i < rows; i++) {
    for (I64 j = 0; j < cols; j++) {
      Bool has_visited = visited[i][j];
      if (!has_visited) {
        I64 area = 0, perimeter = 0;
        DFS(i, j, grid[i][j], &area, &perimeter);
        total += area * perimeter;
      }
    }
  }
  return total;
}

U8 GridGet(I64 y, I64 x)
{
  if (y < 0 || x < 0 || y >= grid_size || x >= grid_size) {
    return 0;
  }
  return grid[y][x];
}

Bool InBounds(I64 y, I64 x)
{
  return y >= 0 && x >= 0 && y < grid_size && x < grid_size;
}

U64 CoordHash(Coord *c)
{
  return (c->x << 8) | c->y;
}

U0 CoordSetAdd(IntSet *set, Coord *c)
{
  IntSetAdd(set, CoordHash(c));
}

Bool CoordSetHas(IntSet *set, Coord *c)
{
  return IntSetHas(set, CoordHash(c));
}

Bool CoordSetHasYX(IntSet *set, I64 Y, I64 X)
{
  return IntSetHas(set, ((X << 8) | Y));
}

U0 QIfNotSeen(List *Q, IntSet *seen, I64 yy, I64 xx, U8 target)
{
  Bool not_seen = InBounds(yy,xx) && !CoordSetHasYX(seen,yy,xx);
  if (not_seen && GridGet(yy,xx) == target) {
    auto new_coord = CoordAlloc(yy,xx);
    ListAppend(Q,new_coord);
    CoordSetAdd(seen,new_coord);
  }
}

PtrVec *FloodFill(I64 start_y, I64 start_x, U8 target)
{
  List *Q = ListNew;
  IntSet *seen = IntSetNew;
  PtrVec *cluster = PtrVecNew;
  Coord *coord = CoordAlloc(start_y,start_x);

  ListAppend(Q,coord);
  CoordSetAdd(seen,coord);

  while (!ListEmpty(Q)) {
    Coord *c = ListDeque(Q)(Coord *);
    U8 ch = GridGet(c->y,c->x);
    if (ch != target) continue;
    PtrVecPush(cluster,c);
    QIfNotSeen(Q,seen,c->y,c->x-1,ch);
    QIfNotSeen(Q,seen,c->y,c->x+1,ch);
    QIfNotSeen(Q,seen,c->y-1,c->x,ch);
    QIfNotSeen(Q,seen,c->y+1,c->x,ch);
  }

  ListRelease(Q,NULL);
  IntSetRelease(seen);
  return cluster;
}

Bool In(IntSet *seen, I64 y, I64 x)
{
  if (!InBounds(y,x)) return FALSE;
  return CoordSetHasYX(seen,y,x);
}

I64 NumSides(PtrVec *vec)
{
  I64 sides = 0;
  IntSet *seen = IntSetNew;
  for (Coord *c : vec) {
    CoordSetAdd(seen,c);
  }

  for (Coord *c : vec) {
    I64 y = c->y;
    I64 x = c->x;

    Bool l =  In(seen, y,   x-1);
    Bool r =  In(seen, y,   x+1);
    Bool u =  In(seen, y-1, x);
    Bool d =  In(seen, y+1, x);
    Bool lu = In(seen, y-1, x-1);
    Bool ru = In(seen, y-1, x+1);
    Bool ld = In(seen, y+1, x-1);
    Bool rd = In(seen, y+1, x+1);

    // Isolated cell
    if (!l && !r && !u && !d) {
      sides += 4;
      continue;
    }

    // Fully surrounded
    if (l && r && u && d && lu && ru && ld && rd) {
      continue;
    }

    // Horizontal line
    if (l && r && !u && !d) {
      continue;
    }

    // Vertical line
    if (u && d && !l && !r) {
      continue;
    }

    // Check each corner
    // top-left corner
    if (!l && !u) sides++;
    else if (l && u && !lu) sides++;

    // top-right corner
    if (!u && !r) sides++;
    else if (u && r && !ru) sides++;

    // bottom-right corner
    if (!r && !d) sides++;
    else if (r && d && !rd) sides++;

    // bottom-left corner
    if (!d && !l) sides++;
    else if (d && l && !ld) sides++;

  }

  IntSetRelease(seen);
  return sides;
}

I64 Part2()
{
  I64 acc = 0;
  IntSet *seen = IntSetNew;

  for (I64 y = 0; y < grid_size; ++y) {
    for (I64 x = 0; x < grid_size; ++x) {
      if (CoordSetHasYX(seen,y,x)) continue;
      U8 ch = GridGet(y,x);
      if (!ch) continue;
      PtrVec *vec = FloodFill(y,x,ch);

      for (Coord *c : vec) {
        CoordSetAdd(seen,c);
      }

      if (vec->size > 0) {
        I64 sides = NumSides(vec);
        acc += vec->size * sides;
      }

      PtrVecRelease(vec);
    }
  }

  IntSetRelease(seen);
  return acc;
}

U0 Main()
{
  Init;
  printf("Part1: %d\n", Part1());
  printf("Part2: %d\n", Part2());
}
