#define FILE_ALLOC    50000
#define MAX_GAMES     1024
#define MAX_LINE_LEN  512
#define MAX_GAME_NUMS 200

public class Card {
  I64 id;
  I64 *winning;
  I64 wlen;
  I64 *player;
  I64 plen;
};

Card *CardNew()
{
  Card *c = MAlloc(sizeof(Card));
  c->winning = MAlloc(sizeof(I64)*MAX_GAME_NUMS);
  c->player = MAlloc(sizeof(I64)*MAX_GAME_NUMS);
  c->plen = 0;
  c->wlen = 0;
  return c;
}

U0 CardPrint(Card *c)
{
  "Card %d: ",c->id;
  for (I64 i = 0; i < c->wlen; ++i) {
    "%2d ", c->winning[i];
  }
  "| ";
  for (I64 i = 0; i < c->plen; ++i) {
    "%2d ", c->player[i];
  }
  "\n";
}

U0 CardFree(Card *c)
{
  Free(c->winning);
  Free(c->player);
  Free(c);
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
    *dst = *src;
    dst++;
    src++;
  }

  if (*src == '\n') {
    *dst = '\0';
    src++;
  }

  *_src = src;
  return 1;
}

I64 ParseNumber(U8 *buffer, I64 *_len)
{ // A poor mans strtoll
  I64 number = *buffer++ - '0';
  I64 len = 0;
  while ('0' <= *buffer <= '9') {
    number *= 10;
    number += *buffer++ - '0';
    len++;
  }
  *_len = len;
  return number;
}

I64 ParseNumbersUntil(I64 *arr, I64 *_arr_len, U8 *ptr, I64 ch)
{ // Parse numbers until 'ch' storing them in arr;
  // Returns the number of characters to skip
  I64 num, num_len, skip = 0,arr_len = 0;
  while (*ptr && *ptr != ch) {
    if ('0' <= *ptr <= '9') {
      num = ParseNumber(ptr,&num_len);
      arr[arr_len++] = num;
      ptr += num_len;
      skip += num_len;
    }
    ptr++;
    skip++;
  }
  *_arr_len = arr_len;
  return skip;
}

U0 LineToCard(Card *card, U8 *ptr)
{ // Convert a line to a card
  I64 num, len;
  while (!('0' <= *ptr <= '9')) {
    ptr++;
  }
  num = ParseNumber(ptr,&len);
  ptr += len+1;
  card->id = num;

  ptr += ParseNumbersUntil(card->winning,&len,ptr,'|');
  card->wlen = len;
  ptr += ParseNumbersUntil(card->player,&len,ptr,'\0');

  card->plen = len;
}

U0 QSort(I64 *arr, I64 high, I64 low)
{ // Simple quick sort
  if (low < high) {
    I64 pivot = arr[high];
    I64 idx = low;
    I64 i = low;
    I64 tmp;

    while (i < high) {
      if (arr[i] <= pivot) {
        tmp = arr[i];
        arr[i] = arr[idx];
        arr[idx++] = tmp;
      }
      i++;
    }
    arr[high] = arr[idx];
    arr[idx] = pivot;

    QSort(arr,high,idx+1);
    QSort(arr,idx-1,low);
  }
}

U64 GetCardScore(Card *card, I64 *_matches)
{ // Returns the number of matches and the score of the card
  I64 w = 0, p = 0, w_num = 0, p_num = 0,
      score = 0, matches = 0;
  QSort(card->winning,card->wlen-1,0);
  QSort(card->player,card->plen-1,0);

  while (w < card->wlen && p < card->plen) {
    w_num = card->winning[w];
    p_num = card->player[p];

    if (p_num == w_num) {
      ++p;
      ++w;
      ++matches;
      if (score == 0) {
        ++score;
      } else {
        score *= 2;
      }
    } else if (p_num < w_num) {
      ++p;
    } else if (p_num > w_num) {
      ++w;
    }
  }
  if (_matches) {
    *_matches = matches;
  }
  return score;
}

public U64 SolvePart1(U8 *ptr)
{
  U8 *line[MAX_LINE_LEN];
  U64 total = 0;
  Card *card = CardNew();

  while (GetLine(&ptr,line)) {
    LineToCard(card,line);
    total += GetCardScore(card,NULL);
  }
  Free(card);
  return total;
}

public U64 SolvePart2(U8 *ptr)
{
  U8 *line[MAX_LINE_LEN];
  I64 cardcounts[MAX_GAMES],winners = 0, num_games = 0;
  U64 total = 0;
  Card *card = CardNew();

  for (I64 i = 1; i < MAX_GAMES; ++i) {
    cardcounts[i] = 1;
  }

  while (GetLine(&ptr,line)) {
    LineToCard(card,line);
    winners = 0;
    GetCardScore(card,&winners);
    for (I64 i = 1; i <= winners; ++i) {
      cardcounts[card->id+i] += cardcounts[card->id];
    }
    ++num_games;
  }

  for (I64 i = 1; i <= num_games; ++i) {
    total += cardcounts[i];
  }

  Free(card);
  return total;
}

U0 Main()
{
  U64 len;
  U8 *buffer = FileRead("./input.txt",FILE_ALLOC,&len);
  I64 s1 = SolvePart1(buffer);
  "part1: %zu\n", s1;
  I64 s2 = SolvePart2(buffer);
  "part2: %zu\n", s2;
  Free(buffer);
}
