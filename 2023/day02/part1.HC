I64 RGB_THREASHOLDS[3] = {12,13,14};

I64 HashFunction(I64 ch)
{
  if      (ch == 'r') return 0;
  else if (ch == 'g') return 1;
  else if (ch == 'b') return 2;
}

I64 AtoI(U8 *ptr, I64 *_len)
{
  I64 len;
  I64 num;
  I64 tmp;

  num = 0-1;
  len = 0;
  if (*ptr == '\0') {
    goto parsed_number;
  }

  num = 0;
  while (1) {
    tmp = *ptr - '0';
    /* This is not a number */
    if (tmp < 0) {
      goto parsed_number;
    }
    if (tmp > 9) {
      goto parsed_number;
    }
    num *= 10;
    num += tmp;
    ptr++;
    len++;
  }

parsed_number:
  if (_len) {
    *_len = len;
  }
  return num;
}

U0 Main()
{
  I64 len;
  U8 *buffer = FileRead("./input.txt", 50000, &len);
  I64 game_id;
  I64 num = 0;
  I64 num_len = 0;
  I64 is_pos = 1;
  I64 acc = 0;

  for (U8 *ptr = buffer; *ptr; ptr++) {
    num = *ptr - '0';

    if (*ptr == 'G') {
      ptr += 5;
      game_id = AtoI(ptr,&num_len);
      ptr += num_len;
    }

    if (num >= 0 && num <= 9) {
      num = AtoI(ptr,&num_len);
      ptr += num_len+1;
      I64 key = HashFunction(*ptr);
      if (num > RGB_THREASHOLDS[key]) {
        is_pos = 0;
      }
    }

    if (*ptr == '\n') {
      "====GAME: %d, posible: %d\n",game_id,is_pos;
      if (is_pos) {
        acc += game_id;
      }
      is_pos = 1;
    }
  }
  "total:%d\n",acc;
}
