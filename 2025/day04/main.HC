#define MAX_ROWS 1000
#define MAX_COLS 1000

U8 *GetLine(U8 **_buffer)
{
  static U8 tmp[1024];
  U8 *ptr = tmp;
  U8 *buffer = *_buffer;
  if (*buffer == '\0') return NULL;
  while (*buffer != '\n') {
    *ptr++ = *buffer++;
  }
  buffer++;
  *ptr = '\0';
  *_buffer = buffer;
  return tmp;
}

I64 Solve1(U8 *buffer)
{
  I64 acc = 0;
  U8 grid[MAX_ROWS][MAX_COLS + 1];
  U8 *line = GetLine(&buffer);
  I64 line_len = StrLen(line);
  I64 rows = 0;

  // Directions for the 8 neighbors
  I64 dr[8] = {-1, -1, -1,  0, 0, 1, 1, 1};
  I64 dc[8] = {-1,  0,  1, -1, 1,-1, 0, 1};


  // Copy into the grid.
  while (line) {
    StrCpy(grid[rows], line);
    line = GetLine(&buffer);
    rows++;
  }

  for (I64 r = 0; r < rows; r++) {
    for (I64 c = 0; c < line_len; c++) {

      if (grid[r][c] != '@') {
        continue;
      }

      I64 neighbor_at_count = 0;

      // Check all 8 neighbors
      for (I64 k = 0; k < 8; k++) {
        I64 nr = r + dr[k];
        I64 nc = c + dc[k];

        if (nr < 0 || nr >= rows || nc < 0 || nc >= line_len) {
          continue; // out of bounds
        }

        if (grid[nr][nc] == '@') {
          neighbor_at_count++;
        }
      }

      if (neighbor_at_count < 4) {
        acc++;
      }
    }
  }
  return acc;
}

I64 Solve2(U8 *buffer)
{
  I64 acc = 0;
  U8 grid[MAX_ROWS][MAX_COLS + 1];
  U8 marked[MAX_ROWS][MAX_COLS + 1];
  U8 to_remove[MAX_ROWS][MAX_COLS + 1];
  U8 *line = GetLine(&buffer);
  I64 line_len = StrLen(line);
  I64 rows = 0;

  // Directions for the 8 neighbors
  I64 dr[8] = {-1, -1, -1,  0, 0, 1, 1, 1};
  I64 dc[8] = {-1,  0,  1, -1, 1,-1, 0, 1};


  // Copy into the grid.
  while (line) {
    StrCpy(grid[rows], line);
    StrCpy(marked[rows], line);
    line = GetLine(&buffer);
    rows++;
  }

  while (1) {
    I64 removed_this_round = 0;

    // Clear removal mask
    MemSet(to_remove, 0, sizeof(to_remove));

    for (I64 r = 0; r < rows; r++) {
      for (I64 c = 0; c < line_len; c++) {
        if (grid[r][c] != '@') {
          continue;
        }

        I64 neighbor_at_count = 0;


        // Count neighboring '@'
        // Check all 8 neighbors
        for (I64 k = 0; k < 8; k++) {
          I64 nr = r + dr[k];
          I64 nc = c + dc[k];

          if (nr < 0 || nr >= rows || nc < 0 || nc >= line_len) {
            continue;
          }

          if (grid[nr][nc] == '@') {
            neighbor_at_count++;
          }
        }

        if (neighbor_at_count < 4) {
          to_remove[r][c] = 1;
          removed_this_round++;
        }

      }
    }

    // If nothing to remove this round, we're done
    if (removed_this_round == 0) {
      break;
    }

    // Remove all marked rolls simultaneously
    for (I64 r = 0; r < rows; r++) {
      for (I64 c = 0; c < line_len; c++) {
        if (to_remove[r][c]) {
          grid[r][c] = '.';  // or any non-'@' char, doesn't matter
        }
      }
    }
    acc += removed_this_round;
  }

  return acc;
}

U0 Main()
{
  U8 *buffer = FileRead("./input.txt");
  I64 s1 = Solve1(buffer);
  I64 s2 = Solve2(buffer);
  "s1 = %ld\n", s1;
  "s2 = %ld\n", s2;
  Free(buffer);
}
