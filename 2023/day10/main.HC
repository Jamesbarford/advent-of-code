/**
 *  | is a vertical pipe connecting north and south.
 *  - is a horizontal pipe connecting east and west.
 *  L is a 90-degree bend connecting north and east.
 *  J is a 90-degree bend connecting north and west.
 *  7 is a 90-degree bend connecting south and west.
 *  F is a 90-degree bend connecting south and east.
 *  . is ground; there is no pipe in this tile.
 *  S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
 */
#define MATRIX_SIZE 256
#define ARRAY_SIZE  256

#define V_PIPE      0x1  // |
#define H_PIPE      0x2  // -
#define NE_PIPE     0x4  // L
#define NW_PIPE     0x8  // J
#define SW_PIPE     0x10 // 7
#define SE_PIPE     0x20 // F
#define GROUND_PIPE 0x80 // .
#define START       420  // S

I64 HashFunction(I64 ch)
{
  if      (ch == '|') return V_PIPE;
  else if (ch == '-') return H_PIPE;
  else if (ch == 'L') return NE_PIPE;
  else if (ch == 'J') return NW_PIPE;
  else if (ch == '7') return SW_PIPE;
  else if (ch == 'F') return SE_PIPE;
  else if (ch == '.') return GROUND_PIPE;
  else if (ch == 'S') return START;
  "ERROR - HashFunc invalid piece: %c %ld\n",
    ch, ch;
  exit(1);
}

I64 UnHash(I64 ch)
{
  if      (ch == V_PIPE)  return '|';
  else if (ch == H_PIPE)  return '-';
  else if (ch == NE_PIPE) return 'L';
  else if (ch == NW_PIPE) return 'J';
  else if (ch == SW_PIPE) return '7';
  else if (ch == SE_PIPE) return 'F';
  else if (ch == GROUND_PIPE) return '.';
  else if (ch == START) return 'S';
  "ERROR - UnHash invalid piece: %c %ld\n",
    ch, ch;
  exit(1);
}

class Coord
{
  I64 x;
  I64 y;
  I64 start;
};

U0 CoordPrint(Coord *crd)
{ // Print out coord and it's start location
  U8 ch = UnHash(crd->start);
  "(x=%ld,y=%ld,start_char=%c)\n",
      crd->x,crd->y,ch;
}

class Array
{
  I64 len;
  I64 size;
  I64 *data;
};

class Matrix
{
  I64 len;
  I64 size;
  Array **entries;
};

Array *ArrayNew(I64 size)
{
  Array *arr = MAlloc(sizeof(Array));
  arr->len = 0;
  arr->size = size;
  arr->data = MAlloc(sizeof(I64) * size);
  return arr;
}

U0 ArrayPrint(Array *arr)
{
  "[";
  U8 ch;
  for (I64 i = 0; i < arr->len; ++i) {
    ch = UnHash(arr->data[i]);
    if (i + 1 == arr->len) "%c",ch;
    else "%c, ",ch;
  }
  "]\n";
}

Matrix *MatrixNew(I64 size)
{
  Matrix *mat = MAlloc(sizeof(Matrix));
  mat->len = 0;
  mat->size = size;
  mat->entries = MAlloc(sizeof(Array *) * size);
  return mat;
}

U0 MatrixPrint(Matrix *mat)
{
  "[\n";
  for (I64 i = 0; i < mat->len; ++i) {
    "  ";
    ArrayPrint(mat->entries[i]);
  }
  "]\n";
}

public I64 GetLine(U8 **_src, U8 *dst)
{ // Will put a '\0' terminated string in 'dst'. Containing one line, 
  // mutates _src
  U8 *src = *_src;
  *dst = '\0';

  if (*src == '\0') {
    return 0;
  }

  while (*src && *src != '\n') {
    *dst = *src++;
    dst++;
  }

  if (*src == '\n') {
    *dst = '\0';
    src++;
  }

  *_src = src;
  return 1;
}

Matrix *ParseInput(U8 *ptr)
{
  U8 line[256];
  U8 *lptr;
  Array *arr;
  Matrix *mat = MatrixNew(MATRIX_SIZE);

  while (GetLine(&ptr,line)) {
    arr = ArrayNew(ARRAY_SIZE);
    lptr = line;
    while (*lptr) {
      arr->data[arr->len++] = HashFunction(*lptr++);
    }
    mat->entries[mat->len++] = arr;
    "%s\n",line;
  }
  return mat;
}

/*
U0 TakeDirection(Coord *crd, I64 x, I64 y, I64 ch)
{
  // | is a vertical pipe connecting north and south.
  if (ch == '|') {

  // - is a horizontal pipe connecting east and west.
  } else if (ch == '-') {

  //  L is a 90-degree bend connecting north and east.
  } else if (ch == 'L') {

  //  J is a 90-degree bend connecting north and west.
  } else if (ch == 'J') {

  //  7 is a 90-degree bend connecting south and west.
  } else if (ch == '7') {

  //  F is a 90-degree bend connecting south and east.
  } else if (ch == 'F') {

  //  . is ground; there is no pipe in this tile.
  } else if (ch == '.') {

  // S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
  } else if (ch == 'S') {

  }
}
*/


U0 FindS(Coord *crd, Matrix *mat)
{
  Array *arr;
  for (I64 y = 0; y < mat->len; ++y) {
    arr = mat->entries[y];
    for (I64 x = 0; x < arr->len; ++x) {
      if (arr->data[x] == START) {
        crd->x = x;
        crd->start = START;
        crd->y = y;
        return;
      }
    }
  }
}

public U8 GetTile(Matrix *mat, I64 x, I64 y)
{
  if (0 <= y < mat->len) {
    Array *arr = mat->entries[y];
    if (0 <= x < arr->len) {
      return arr->data[x];
    }
  }
  return '\0';
}

U8 DeterminePiece(Coord *crd, Matrix *mat)
{
  Array *arr;
  I64 ch = '\0',c1,c2,c3,c4,tmp;
  I64 x1,x2,y1,y2,h = 0;
  x1 = crd->x - 1; // left
  x2 = crd->x + 1; // right 
  y1 = crd->y - 1; // up
  y2 = crd->y + 1; // down;
  
  c1 = GetTile(mat,x1,crd->y); // LEFT <-> EAST
  c2 = GetTile(mat,x2,crd->y); // RIGHT <-> WEST 
  c3 = GetTile(mat,crd->x,y1); // UP
  c4 = GetTile(mat,crd->x,y2); // DOWN

  if (c3 & (V_PIPE|SW_PIPE|SE_PIPE)) {
    tmp = UnHash(c3);
    h |= c3;

    "COULD BE: V_PIPE|SW_PIPE|SE_PIPE: %c\n",
      tmp; 
  }

  if (c4 & (V_PIPE|NW_PIPE|NE_PIPE)) {
    h |= c4;
    tmp = UnHash(c4);
    "COULD BE: V_PIPE|NW_PIPE|NE_PIPE: %c\n", tmp; 
  }
  
  if (c1 & (H_PIPE|SE_PIPE|NE_PIPE)) {
    h |= c1;
    tmp = UnHash(c1);
    "COULD BE: H_PIPE|SE_PIPE|SW_PIPE: %c\n", tmp; 
  }

  if (c2 & (H_PIPE|SW_PIPE|NW_PIPE)) {
    h |= c2;
    tmp = UnHash(c2);
    "COULD BE: H_PIPE|SW_PIPE|NW_PIPE: %c\n", tmp; 
  }
  "FLAGS: 0x%LX\n",h;

  return ch;
}

U64 SolvePart1(Matrix *mat)
{
  U64 acc = 0;
  Coord crd;
  FindS(&crd,mat);
  CoordPrint(&crd);
  DeterminePiece(&crd,mat);
  return acc;
}

U0 Main()
{
  I64 len;
  U8 *buffer = FileRead("./sample.txt", 50000, &len);
  "%s\n",buffer;
  Matrix *problem = ParseInput(buffer);
  SolvePart1(problem);
}
