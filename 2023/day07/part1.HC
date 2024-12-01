#define CARDS      5
#define DECK      13
#define MAX_SCORE 13

#define FIVE_KIND  7
#define FOUR_KIND  6
#define FULL_HOUSE 5
#define THREE_KIND 4
#define TWO_PAIR   3
#define ONE_PAIR   2
#define RUNT       1

class Hand
{
  U64 bid;
  U64 type;
  U64 *cards; 
  U64 *original;
};

class Array
{
  U64 len;
  Hand **hands;
};

Array *ArrayNew()
{
  Array *arr;
  arr = MAlloc(sizeof(Array));
  arr->len = 0;
  arr->hands = MAlloc(sizeof(Hand *) * 2000);
  return arr;
}

U64 HandCmp(Hand *h1, Hand *h2)
{
  U64 t1,t2,c1,c2;
  t1 = h1->type;
  t2 = h2->type;

  if (t1 < t2) { 
    return -1;
  }

  if (t1 == t2) {
    for (U64 j = 0; j < CARDS; ++j) {
      c1 = h1->original[j];
      c2 = h2->original[j];
      if (c1 != c2) 
        return c1 - c2;
    }
  }

  return 1;
}

U0 QSortHands(Array *arr, I64 high, I64 low=0)
{ // Simple quick sort
  if (low < high) {
    Hand *pivot;
    Hand *cur;
    Hand *tmp;
    U64 t1,t2,c1,c2;

    pivot = arr->hands[high];
    I64 idx = low - 1, i = low, cmp = 0;

    while (i < high) {
      cur = arr->hands[i];
      t1 = cur->type;
      t2 = pivot->type;

      cmp = HandCmp(cur,pivot);
      if (cmp < 0) {
        ++idx;
        tmp = arr->hands[i];
        arr->hands[i] = arr->hands[idx];
        arr->hands[idx] = tmp;
      }
      i++;
    }

    ++idx;
    arr->hands[high] = arr->hands[idx];
    arr->hands[idx] = pivot;

    QSortHands(arr,idx - 1,low);
    QSortHands(arr,high, idx + 1);
  }
}

U64 Normalise(U8 ch)
{ // 13 numbers in total
  if      (ch == 'A') return 12;
  else if (ch == 'K') return 11;
  else if (ch == 'Q') return 10;
  else if (ch == 'J') return 9;
  else if (ch == 'T') return 8;
  else if (ch == '9') return 7;
  else if (ch == '8') return 6;
  else if (ch == '7') return 5;
  else if (ch == '6') return 4;
  else if (ch == '5') return 3;
  else if (ch == '4') return 2;
  else if (ch == '3') return 1;
  else if (ch == '2') return 0;
}

U8 DeNormalise(U64 ch)
{ // 13 numbers in total
  if      (ch == 12) return 'A';
  else if (ch == 11) return 'K';
  else if (ch == 10) return 'Q';
  else if (ch == 9) return  'J';
  else if (ch == 8) return  'T';
  else if (ch == 7) return  '9';
  else if (ch == 6) return  '8';
  else if (ch == 5) return  '7';
  else if (ch == 4) return  '6';
  else if (ch == 3) return  '5';
  else if (ch == 2) return  '4';
  else if (ch == 1) return  '3';
  else if (ch == 0) return  '2';
}

U0 QSort(I64 *arr, I64 high, I64 low)
{ // Simple quick sort
  if (low < high) {
    I64 pivot = arr[high];
    I64 idx = low;
    I64 i = low;
    I64 tmp;

    while (i < high) {
      if (arr[i] >= pivot) {
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

Hand *ParseHand(U8 *ptr)
{
  Hand *hand;
  U64 key,count,prevcount,*arr;
  arr = MAlloc(sizeof(U64) * DECK);
  hand = MAlloc(sizeof(Hand));
  hand->cards = MAlloc(sizeof(U64)*DECK);
  hand->original = MAlloc(sizeof(U64)*CARDS);
  hand->type = 0;
  hand->bid = 0;
  key = count = prevcount = 0;
  
  for (I64 i = 0; i < DECK; ++i) {
    hand->cards[i] = 0;
  }

  for (I64 i = 0; i < CARDS; ++i) {
    key = Normalise(ptr[i]);
    hand->original[i] = key;
    hand->cards[key] += 1;
    count = hand->cards[key];
    if (count > hand->type) {
      hand->type = count;
    }
  }
  for (I64 i = 0; i < DECK; ++i) {
    arr[i] = hand->cards[i];
  }

  QSort(arr,DECK-1,0);
  if (arr[0] == 5) hand->type = FIVE_KIND;
  else if (arr[0] == 4) hand->type = FOUR_KIND;
  else if (arr[0] == 3 && arr[1] == 2) hand->type = FULL_HOUSE;
  else if (arr[0] == 3) hand->type = THREE_KIND;
  else if (arr[0] == 2 && arr[1] == 2) hand->type = TWO_PAIR;
  else if (arr[0] == 2) hand->type = ONE_PAIR;
  else if (arr[0] == 1) hand->type = RUNT;

  ptr += 6;
  while ('0'<=*ptr<='9') {
    hand->bid *= 10;
    hand->bid += *ptr - '0';
    ptr++;
  }
  return hand;
}

U0 HandPrint(Hand *h)
{
  U8 ch;
  for (I64 i = 0; i < CARDS; ++i) {
    ch = DeNormalise(h->original[i]);
    "%c", ch;
  }
  " type: ";
  if (h->type == FIVE_KIND) "FIVE OF A KIND";
  else if (h->type == FOUR_KIND) "4 OF A KIND";
  else if (h->type == FULL_HOUSE) "FULL HOUSE";
  else if (h->type == THREE_KIND) "THREE OF A KIND";
  else if (h->type == TWO_PAIR) "TWO PAIR";
  else if (h->type == ONE_PAIR) "ONE PAIR";
  else if (h->type == RUNT) "RUNT";
  " bid: %3zu\n",h->bid;
}

U0 HandFree(Hand *h)
{
  Free(h->cards);
  Free(h);
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

Hand **SolvePart1(U8 *ptr)
{
  Array *arr;
  Hand *h;
  U8 line[100];
  U64 len = 0, rank = 1, total = 0;
  arr = ArrayNew();

  while (GetLine(&ptr,line)) {
    h = ParseHand(line);
    arr->hands[arr->len++] = h;
  }

  QSortHands(arr, arr->len-1);

  "SORTED\n";
  for (I64 i = 0; i < arr->len; ++i) {
    h = arr->hands[i];
    total += h->bid * rank;
    rank++;
  }
  return total;
}

U0 Main()
{
  I64 len;
  U8 *buffer = FileRead("./input.txt", 20000, &len);
  U64 s1 = SolvePart1(buffer);
  "part1: %zu\n",s1;
}
