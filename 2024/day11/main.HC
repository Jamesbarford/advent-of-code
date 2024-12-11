List *Parse(U8 *buffer)
{
  List *list = ListNew;
  I64 num = 0;
  for (U8 *ptr = buffer; *ptr; ptr++) {
    if (IsSpace(*ptr)) {
      ListAppend(list,num(U0*));
      num = 0;
    } else {
      num = num * 10 + *ptr-'0';
    }
  }
  return list;
}

U0 ListPrint(List *l)
{
  List *node = l->next;
  I64 val = -1;
  "[";
  while (node != l) {
    val = node->value(I64);
    "%lld", val;
    if (node->next != l) {
      ", ";
    }
    node = node->next;
  }
  "]\n";
}

Bool NumEvenLen(U8 *buf, I64 num, I64 *_len)
{
  I64 len = I64ToStr(buf,num);
  StrReverse(buf,len);
  *_len = len;
  return len % 2 == 0;
}

/* Make the redblack tree behave like an interger hashtable map<int, int>. 
 * @Bug - 2024/12/11 IntMap's in HolyC are well and truly broken, finding a 
 * free slot spins indefinitely. Thankfully the redblack tree does not suffer 
 * from the same bug, but the trade off is it is slower. */
class IntTree : RBTree
{
};

I64 IntKeyCmp(U0 *k1, U0 *k2)
{
  I64 _k1 = k1(I64);
  I64 _k2 = k2(I64);
  if (_k1 < _k2) return -1;
  if (_k1 > _k2) return 1;
  return 0;
}

IntTree *IntTreeNew(U0)
{
  return RBTreeNew(NULL,NULL,&IntKeyCmp);
}

U0 IntTreeInsert(IntTree *tree, I64 key, I64 value)
{
  RBTreeInsert(tree,key(U0*),value(U0*));
}

I64 IntTreeGet(IntTree *tree, I64 key)
{
  return RBTreeGet(tree,key(U0*))(I64);
}

Bool IntTreeHas(IntTree *tree, I64 key)
{
  return RBTreeHas(tree,key(U0*));
}

U0 IntTreePrint(IntTree *tree)
{
  "{";
  RBIter *it = RBIterNew(tree);
  IntTree *cpy = IntTreeNew;
  RBNode *node = NULL;
  while ((node = RBIterNext(it))) {
    "%d: %d, ",node->key(I64),node->value(I64);
  }
  RBIterRelease(it);
  "}\n";
}

/* Brute force :) */
I64 Part1(List *list, I64 rounds)
{
  U8 tmp[64];
  I64 num_len;

  while (rounds > 0) {
    for (List *node = list->next; node != list; node = node->next) {
      I64 stone = node->value(I64);
      if (stone == 0) {
        node->value = 1(U0*);
      } else if (NumEvenLen(tmp,stone,&num_len)) {
        List *n2 = ListNew;
        List *next = node->next;
        I64 half = num_len/2;
        I64 num = 0;
        for (I64 i = 0; i < half; ++i) {
          num = num * 10 + tmp[i] - '0'; 
        }
        node->value = num(U0 *);

        num = 0;
        for (U8 *ptr = tmp+half; *ptr; ++ptr) {
          num = num * 10 + *ptr - '0';
        }

        n2->value = num(U0*);

        node->next = n2;
        next->prev = n2;
        n2->prev = node;
        n2->next = next;
        node = n2;
      } else {
        stone *= 2024;
        node->value(I64) = stone;
      }
    }
    rounds--;
  }

  return ListCount(list);
}

U0 IntTreeIncr(IntTree *tree, I64 key, I64 prev_cnt)
{
  if (!IntTreeHas(tree,key)) {
    if (prev_cnt >= 1) {
      IntTreeInsert(tree,key,prev_cnt);
    } else {
      IntTreeInsert(tree,key,1);
    }
  } else {
    I64 cur_cnt = IntTreeGet(tree,key);
    cur_cnt += prev_cnt;
    IntTreeInsert(tree,key,cur_cnt);
  }
}

I64 Part2(List *list, I64 rounds)
{
  U8 tmp[64];
  I64 num_len;
  I64 acc = 0;
  /* Pre allocate all trees */
  I64 TREE_ARRAY_SIZE = rounds+10;
  IntTree **trees = MAlloc(sizeof(IntTree *) * TREE_ARRAY_SIZE);

  for (I64 i = 0; i < TREE_ARRAY_SIZE; ++i) {
    trees[i] = IntTreeNew;
  }

  I64 tree_idx = 0;
  IntTree *tree = trees[tree_idx];

  for (List *node = list->next; node != list; node = node->next) {
    I64 stone = node->value(I64);
    IntTreeIncr(tree,stone,0);
  }

  RBNode *node = NULL;
  for (I64 round = 0; round < rounds; ++round) {
    IntTree *new_tree = trees[++tree_idx];
    RBIter *it = RBIterNew(tree);

     while ((node = RBIterNext(it))) {
      I64 stone = node->key(I64);
      I64 cnt = node->value(I64);

      if (stone == 0) {
        IntTreeIncr(new_tree,1,cnt);
      } else if (NumEvenLen(tmp,stone,&num_len)) {
        I64 half = num_len/2;
        I64 left = 0,right = 0;

        for (I64 i = 0; i < half; ++i) {
          left = left * 10 + tmp[i] - '0'; 
        }
        for (U8 *ptr = tmp+half; *ptr; ++ptr) {
          right = right * 10 + *ptr - '0';
        }

        IntTreeIncr(new_tree,left,cnt);
        IntTreeIncr(new_tree,right,cnt);
      } else {
        IntTreeIncr(new_tree,stone*2024,cnt);
      }
    }

    tree = new_tree;
    RBIterRelease(it);
  }

  RBIter *it = RBIterNew(tree);
  while ((node = RBIterNext(it))) {
    acc += node->value(I64);
  }
  RBIterRelease(it);

  for (I64 i = 0; i < TREE_ARRAY_SIZE; ++i) {
    RBTreeRelease(trees[i]);
  }

  return acc;
}

U0 Main()
{
  U8 *buffer = FileRead("./input.txt");
  List *lists[2] = { Parse(buffer), Parse(buffer) };

  "Part1: %lld\n",Part1(lists[0],25);
  "Part2: %lld\n",Part2(lists[1],75);
  
  ListRelease(lists[0],NULL);
  ListRelease(lists[1],NULL);
  Free(buffer);
}
