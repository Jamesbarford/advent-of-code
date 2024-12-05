class PrinterRules
{
  IntMap *map;
  IntMap *reverse_map;
  IntVec **entries;
  I64 size;
};

auto IntVecToString(IntVec *vec)
{
  U8 tmp[64];
  U8 *buf = MAlloc(sizeof(U8)*64);
  auto dst = buf;

  SPutChar(&dst,'[',&buf);
  for (auto i = 0; i < vec->size; ++i) {
    auto num = vec->entries[i];
    auto len = snprintf(tmp,sizeof(tmp),"%lld",num);
    tmp[len] = '\0';
    OutStr(tmp,&buf,&dst);
    if (i+1 != vec->size) {
      OutStr(", ",&buf,&dst,0,0);
    }
  }
  SPutChar(&dst,']',&buf);
  return buf;
}

U0 PrintVec(IntVec *vec)
{
  auto str = IntVecToString(vec);
  "%s\n",str;
  Free(str);
}

PrinterRules *Parse(U8 *buffer)
{
  PrinterRules *pr = MAlloc(sizeof(PrinterRules));
  U8 tmp[64];
  U8 *ptr = buffer, *tmp_ptr;
  auto state = 0, key = 0, value = 0, capacity = 32, size = 0;
  auto map = IntMapNew;
  auto reverse_map = IntMapNew;
  IntVec **entries = MAlloc(sizeof(IntVec *)*capacity);
  IntVec *vec = NULL;

  while (*ptr) {

    switch [state] {
      case 0: {
        tmp_ptr = tmp;
        while (*ptr != '|') *tmp_ptr++ = *ptr++;
        *tmp_ptr = '\0';
        key = Atoi(tmp); 
        ptr++;
        tmp_ptr = tmp;
        while (*ptr != '\n') *tmp_ptr++ = *ptr++;
        *tmp_ptr = '\0';
        value = Atoi(tmp);

        vec = IntMapGet(map,key);
        if (!vec) {
          vec = IntVecNew;
          IntVecPush(vec,value);
          IntMapSet(map,key,vec);
        } else {
          IntVecPush(vec,value);
        }

        vec = IntMapGet(reverse_map,value);
        if (!vec) {
          vec = IntVecNew;
          IntVecPush(vec,key);
          IntMapSet(reverse_map,value,vec);
        } else {
          IntVecPush(vec,key);
        }
        break;
      }

      case 1: {
        while (*ptr) {
          IntVec *vec = IntVecNew;
          while (*ptr != '\n' && *ptr != '\0') {
            tmp_ptr = tmp;
            while (*ptr != ',' && *ptr != '\n' && * ptr != '\0') {
              *tmp_ptr++ = *ptr++;
            }
            *tmp_ptr = '\0';
            value = Atoi(tmp);
            IntVecPush(vec,value);
            if (*ptr == ',') ptr++;
          }

          if (size+1 >= capacity) {
            capacity *= 2;
            entries = ReAlloc(entries, sizeof(IntVec *)*capacity);
          }
          entries[size++] = vec;
          if (*ptr != '\0') ptr++;
        }
        tmp_ptr = tmp;
        break;
      }
    } // switch end.
    if (*ptr == '\n' && *(ptr+1) == '\n') {
      state = 1;
      ptr += 2;
    } else {
      ptr++;
    }
  }

  pr->map = map;
  pr->entries = entries;
  pr->size = size;
  pr->reverse_map = reverse_map;
  IntMapSetFreeValue(pr->map,&IntVecRelease);
  IntMapSetFreeValue(pr->reverse_map,&IntVecRelease);
  return pr;
}

U0 PrinterRulesRelease(PrinterRules *pr)
{
  IntMapRelease(pr->map);
  IntMapRelease(pr->reverse_map);
  for (auto vec : pr) {
    IntVecRelease(vec);
  }
  Free(pr->entries);
  Free(pr);
}

U0 PrinterRulesPrint(PrinterRules *rules)
{
  "Order map:\n";
  for (auto i = 0; i < rules->map->indexes->size; ++i) {
    IntMapNode *n = rules->map->entries[rules->map->indexes->entries[i]];
    IntVec *vec = n->value(IntVec *);
    "%d => ",n->key;
    PrintVec(vec);
  }

  "Reverse order map:\n";
  for (auto i = 0; i < rules->reverse_map->indexes->size; ++i) {
    auto n = rules->reverse_map->entries[rules->reverse_map->indexes->entries[i]];
    auto vec = n->value(IntVec *);
    "%d => ",n->key;
    PrintVec(vec);
  }

  "\nOrders:\n";
  for (IntVec *vec : rules) {
    PrintVec(vec);
  }
  "\n\n";
}

auto IntVecHas(IntVec *vec, I64 needle)
{
  for (auto it : vec) {
    if (it == needle) return TRUE;
  }
  return FALSE;
}

auto IsOrdered(PrinterRules *rules, IntVec *vec, I64 *_bad_idx=NULL)
{
  auto rule_idx = 0;
  auto ok = FALSE;

  while (rule_idx < vec->size) {
    auto rule = vec->entries[rule_idx];
    auto pages = IntMapGet(rules->map, rule);
    ok = FALSE;

    auto i = rule_idx+1;
    for (; i < vec->size; ++i) {
      I64 next_rule = vec->entries[i];
      IntVec *reverse = IntMapGet(rules->reverse_map, next_rule);

      if (pages) {
        if (!IntVecHas(pages,next_rule)) {
          goto out;
        }
      } else if (reverse) {
        if (!IntVecHas(reverse,rule)) {
          goto out;
        }
      }
    }

    /* We are at the end */
    if (i >= vec->size) {
      ok = TRUE;
    }

    rule_idx++;
  }

out:
  if (!ok && _bad_idx != NULL) *_bad_idx = rule_idx;

  return ok;
}

auto GetOrder(PrinterRules *rules, Bool incorrect=FALSE)
{
  auto indexes = IntVecNew;
  
  for (auto idx = 0; idx < rules->size; ++idx) {
    auto vec = rules->entries[idx];
    auto ok = IsOrdered(rules,vec,NULL);

    if (!incorrect && ok) {
      IntVecPush(indexes,idx);
    }
    if (incorrect && !ok) {
      IntVecPush(indexes,idx);
    }
  }

  return indexes;
}


U0 Swap(IntVec *vec, I64 i1, I64 i2)
{
  auto tmp = vec->entries[i1];
  vec->entries[i1] = vec->entries[i2];
  vec->entries[i2] = tmp;
}

U0 ReOrder(PrinterRules *rules, IntVec *unordered)
{
  auto bad_idx = -1, idx = 0;
  while (!IsOrdered(rules,unordered,&bad_idx)) {
    Swap(unordered,bad_idx,idx);
    idx = (idx + 1) % unordered->size;
  }
}

auto Part1(PrinterRules *rules)
{
  auto indexes = GetOrder(rules);
  auto acc = 0;
 
  for (auto idx : indexes) {
    auto vec = rules->entries[idx];
    acc += vec->entries[vec->size/2];
  }

  IntVecRelease(indexes);
  return acc;
}

auto Part2(PrinterRules *rules)
{
  auto indexes = GetOrder(rules,TRUE);
  auto acc = 0;

  for (auto idx : indexes) {
    auto vec = rules->entries[idx];
    ReOrder(rules,vec);
    acc += vec->entries[vec->size/2];
  }

  return acc;
}

auto Main()
{
  auto buffer = FileRead("./input.txt");
  if (buffer == NULL) {
    "buf Null!\n";
    Exit;
  }

  PrinterRules *rules = Parse(buffer);

  "Part1: %d\n", Part1(rules);
  "Part2: %d\n", Part2(rules);

  PrinterRulesRelease(rules);
  Free(buffer);
}
