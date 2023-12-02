I64 RGB[3] = {0,0,0};

I64 HashFunction(I64 ch)
{
  if      (ch == 'r') return 0;
  else if (ch == 'g') return 1;
  else if (ch == 'b') return 2;
}

U0 ClearScores()
{
  for (I64 i = 0; i < 3; i++) {
    RGB[i] = 0;
  }
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
  I64 game_id = 0-1;
  I64 num = 0;
  I64 tmp = 0;
  I64 num_len = 0;
  I64 acc = 0;
  I64 product = 0;
  ClearScores();

  for (U8 *ptr = buffer; *ptr; ptr++) {
    num = *ptr - '0';

    if (*ptr == 'G') {
      ptr += 5;
      game_id = AtoI(ptr,&num_len);
      ptr += num_len;
      "GAME ID :%d\n", game_id;
    }

    if (num >= 0 && num <= 9) {
      num = AtoI(ptr,&num_len);
      ptr += num_len+1;
      I64 key = HashFunction(*ptr);
      if (RGB[key] < num) {
        RGB[key] = num;
      }
    }

    if (*ptr == '\n') {
      product = RGB[0] * RGB[1] * RGB[2];
      "====R:%d G:%d B:%d, product:%d\n", 
          RGB[0], RGB[1], RGB[2], product;
      acc += product;
      ClearScores();
    }
  }
  "total:%d\n",acc;
}
