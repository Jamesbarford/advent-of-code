class PrinterRules
{
  IntMap *map;
  IntVec **entries;
  I64 size;
};

U0 PrintVec(IntVec *vec)
{
  "[";
  for (I64 i = 0; i < vec->size; ++i) {
    "%d",vec->entries[i];
    if (i+1!=vec->size) {
      ", ";
    }
  }
  "]\n";
}


PrinterRules *Parse(U8 *buffer)
{
  PrinterRules *pr = MAlloc(sizeof(PrinterRules));
  U8 tmp[64];
  U8 *ptr = buffer, *tmp_ptr;
  I64 state = 0, key = 0, value = 0, capacity = 32, size = 0;
  IntMap *map = IntMapNew;
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
  IntMapSetFreeValue(pr->map,&IntVecRelease);
  return pr;
}

U0 PrinterRulesRelease(PrinterRules *pr)
{
  IntMapRelease(pr->map);
  for (IntVec *vec : pr) {
    IntVecRelease(vec);
  }
  Free(pr->entries);
  Free(pr);
}

U0 PrinterRulesPrint(PrinterRules *rules)
{
  for (I64 i = 0; i < rules->map->indexes->size; ++i) {
    IntMapNode *n = rules->map->entries[rules->map->indexes->entries[i]];
    IntVec *vec = n->value(IntVec *);
    "%d => ",n->key;
    PrintVec(vec);
  }

  "\nOrders:\n";
  for (IntVec *vec : rules) {
    PrintVec(vec);
  }
}

Bool IntVecHas(IntVec *vec, I64 needle)
{
  for (I64 it : vec) {
    if (it == needle) return TRUE;
  }
  return FALSE;
}

/* IntSet would be better than IntVec */
I64 Part1(PrinterRules *rules)
{
  I64 acc = 0, rule = 0, rule_idx = 0, ok = 0;
  IntVec *indexes = IntVecNew;
  
  for (I64 idx = 0; idx < rules->size; ++idx) {
    IntVec *vec = rules->entries[idx];

    while (rule_idx < vec->size) {
      rule = vec->entries[rule_idx];
      IntVec *pages = IntMapGet(rules->map, rule);
      I64 i;
      if (!IntVecHas(pages,
      for (i = 0; i < pages->size; ++i) {
        if (!IntVecHas(pages,vec->entries[i])) {
          break;
        }
      }
      if (i+1 == vec->size;) {
        ok++;
      }
      rule_idx++;
    }
    if (ok == vec->size) {
      IntVecPush(indexes,idx);
    }
  }
  
  PrintVec(indexes);
  return acc;
}

U0 Main()
{
  U8 *buffer = FileRead("./example.txt");
  if (buffer == NULL) {
    "buf Null!\n";
    Exit;
  }
  PrinterRules *rules = Parse(buffer);

  "Part1: %d\n", Part1(rules);

  PrinterRulesRelease(rules);
  Free(buffer);
}
