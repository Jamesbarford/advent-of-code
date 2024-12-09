IntVec *Parse(U8 *buffer)
{
  IntVec *vec = IntVecNew;
  for (U8 *ptr = buffer; *ptr; ptr++) {
    if ('0' <= *ptr <= '9') IntVecPush(vec,*ptr - '0');
  }
  return vec;
}

IntVec *Expand(IntVec *input)
{
  IntVec *vec = IntVecNew;
  I64 i = 0, j = 1, id = 0;
  while (i < input->size) {
    I64 size = input->entries[i];
    I64 free_space = input->entries[j];
    for (I64 ii = 0; ii < size; ++ii) {
      IntVecPush(vec,id);
    }
    for (I64 ii = 0; ii < free_space; ++ii) {
      IntVecPush(vec,-1);
    }
    i+=2;
    j+=2;
    ++id;
  }
  return vec;
}

U0 PrintBlocks(IntVec *blocks)
{
  for (auto it : blocks) {
    if (it == -1) ".";
    else "%d",it;
  }
  "\n";
}

I64 Part1(IntVec *vec)
{
  IntVec *blocks = Expand(vec);
  I64 *vector = MAlloc(sizeof(I64) * blocks->size);
  for (I64 i = 0; i < blocks->size; ++i) {
    vector[i] = -1;
  }
  I64 free_blk = 0;
  I64 acc = 0;
  I64 size = 0;
  I64 end_blk = blocks->size-1;

  while (1) {
    while (blocks->entries[free_blk] != -1) {
      vector[size++] = blocks->entries[free_blk];
      if (end_blk <= free_blk) break;
      free_blk++;
    }
    while (blocks->entries[end_blk] == -1) {
      end_blk--;
      if (end_blk <= free_blk) break;
    }
    if (end_blk <= free_blk) break;
    vector[size++] = blocks->entries[end_blk];
    end_blk--;
    free_blk++;
  }

  for (I64 i = 0; i < size; ++i) {
    acc += vector[i] * i;
  }

  IntVecRelease(blocks);
  Free(vector);
  return acc;
}

class Segment
{
  I64 len;
  Bool is_file;
};
#define MAX_DISK_SIZE (1<<16)
I64 Part2(IntVec *vec)
{
  Segment segments[MAX_DISK_SIZE];
  I64 count = 0;
  I64 file_count = 0;
  I64 total_len = 0;
  Bool is_file = TRUE;
  I64 *disk = MAlloc(sizeof(I64)*MAX_DISK_SIZE*100);
  I64 cur_id = 0, pos = 0;

  /* Alternate between files and free */
  for (auto it : vec) {
    segments[count].len = it;
    segments[count].is_file = is_file;
    total_len += it;
    count++;
    if (is_file && it > 0) {
      for (I64 k = 0; k < it; ++k) {
        disk[pos++] = cur_id;
      }
      cur_id++;
      file_count++;
    } else {
      for (I64 k = 0; k < it; ++k) {
        disk[pos++] = -1;
      }
    }
    is_file = !is_file;
  }

  I64 *file_start = MAlloc(sizeof(I64)*file_count);
  I64 *file_end = MAlloc(sizeof(I64)*file_count);

  for (I64 f = 0; f < file_count; ++f) {
    file_start[f] = -1;
    file_end[f] = -1;
  }

  for (I64 i = 0; i < total_len; ++i) {
    I64 fid = disk[i];
    if (fid >= 0) {
      if (file_start[fid] == -1) file_start[fid] = i;
      file_end[fid] = i;
    }
  }


  for (I64 f = file_count - 1; f >= 0; --f) {
    if (file_start[f] < 0) continue;
    I64 len = file_end[f]-file_start[f]+1;
    I64 best_start = -1;

    I64 run_start = -1;
    I64 run_len = 0;
    for (I64 i = 0; i < file_start[f]; i++){
      if (disk[i] == -1) {
        if (run_start == -1) {
          run_start = i;
          run_len = 1; 
        } else run_len++;
      } else {
        if (run_start !=- 1 && run_len>=len) {
          best_start = run_start;
          break;
        }
        run_start = -1; run_len=0;
      }
    }
    if (best_start == -1 && run_start != -1 && run_len >= len) {
      best_start=run_start;
    }

    if (best_start != -1) {
      I64 *temp = MAlloc(sizeof(I64)*len);
      for (I64 i = 0; i < len; i++){
        temp[i] = disk[file_start[f]+i];
      }
      for (I64 i = 0; i < len; i++){
        disk[best_start+i] = temp[i];
      }
      for (I64 i = file_start[f]; i <= file_end[f]; i++){
        disk[i] = -1;
      }
      Free(temp);
      file_start[f] = best_start;
      file_end[f] = best_start+len-1;
    }
  }

  I64 checksum=0;
  for (I64 i = 0; i < total_len; i++){
    if (disk[i] >= 0) {
      checksum += i(I64) * disk[i](I64);
    }
  }

  Free(disk);
  Free(file_start);
  Free(file_end);
  return checksum;
}

U0 Main()
{
  U8 *buffer = FileRead("./input2.txt");
  IntVec *vec = Parse(buffer);

  "Part1: %lld\n", Part1(vec);
  "Part2: %lld\n", Part2(vec);

  IntVecRelease(vec);
  Free(buffer);
}
