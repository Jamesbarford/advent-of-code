#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>

#define HT_SIZE    16
#define LINE_LEN   512
#define ARRAY_SIZE 200
#define TUPLE_SIZE 3

#define LEN_IDX 2
#define DST_IDX 0
#define SRC_IDX 1

typedef struct Array {
    unsigned char *key;
    unsigned long *data;
    long rows;
    long cols;
} Array;

typedef struct Ht {
    long len;
    long cap;
    unsigned long bitmap;
    Array **entries;
} Ht;

typedef struct Tuple
{
long  t[2];
} Tuple;


Ht *htNew(long cap) {
    Ht *ht = malloc(sizeof(Ht));
    ht->entries = malloc(sizeof(Array *) * cap + 2000);
    ht->len = 0;
    ht->cap = cap;
    ht->bitmap = 0;
    for (long i = 0; i < cap; ++i) {
        ht->entries[i] = NULL;
    }
    return ht;
}

Array *arrayNew(unsigned char *key, long rows, long cols) {
    Array *arr;
    arr = malloc(sizeof(Array));
    arr->data = malloc(sizeof(unsigned long) * ARRAY_SIZE);
    arr->rows = rows;
    arr->cols = cols;
    arr->key = key;
    return arr;
}

void arrayPrint(Array *a) {
    long contents = a->rows * a->cols;
    printf("ARRAY[%s]: rows=%ld cols=%ld contents=%ld\n", a->key, a->rows,
           a->cols, contents);
    for (long i = 0; i < contents; ++i) {
        printf("%ld ", a->data[i]);
    }
    printf("\n");
}

unsigned long hashFunction(unsigned char *key, long len) {
    unsigned char *s = key;
    unsigned long h = *s;
    for (long i = 1; i < len; ++i) {
        h = (h << 5) - h + s[i];
    }
    return h;
}

unsigned long hashIdx(unsigned char *key) {
    unsigned long h;
    unsigned char *s = key;
    long len = strlen((void *)key);
    h = hashFunction(key, len);
    return h & HT_SIZE - 1;
}

void htSet(Ht *ht, unsigned char *key, Array *arr) {
    unsigned long hash, idx, key_len;
    Array *ptr, *pt2;
    key_len = strlen((void *)key);
    hash = hashFunction(key, key_len);
    idx = hash & (HT_SIZE - 1);
    if (ht->entries[idx]) {
        printf("HashTable Collision\n");
        exit(1);
    }
    ht->entries[idx] = arr;
    ht->bitmap |= 1 << idx;
    ht->len++;
}

Array *htGet(Ht *ht, unsigned char *key) {
    unsigned long hash, key_len, idx;
    Array *arr;
    key_len = strlen((void *)key);
    hash = hashFunction(key, key_len);
    idx = hash & (HT_SIZE - 1);
    arr = ht->entries[idx];
    return arr;
}

void htScan(Ht *ht) {
    Array *ptr;
    printf("TABLE SCAN==========\n");
    printf("TABLE bitmap: \n");
    for (long i = 0; i < HT_SIZE; ++i) {
        if ((ht->bitmap >> i) & 1)
            printf("1");
        else
            printf("0");
    }
    printf("\n");
    for (long i = 0; i < ht->cap; ++i) {
        if ((ht->bitmap >> i) & 1) {
            printf("TABLE IDX: %ld\n", i);
            arrayPrint(ht->entries[i]);
        }
    }
    printf("TABLE SCAN END=========\n");
}

long getLine(unsigned char **_src, unsigned char *dst) { // Will put a '\0' terminated string in 'dst'.
                                  // Containing one line,
    // mutates _src
    unsigned char *src = *_src;
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

long parseNumber(unsigned char *buffer, long *_len) { // A poor mans strtoll
    long number = *buffer++ - '0';
    long len = 0;
    while (*buffer >= '0' && *buffer <= '9') {
        number *= 10;
        number += *buffer++ - '0';
        len++;
    }
    *_len = len;
    return number;
}

long parseNumbersUntil(unsigned long *arr, long *_arr_len, unsigned char *ptr,
                      long ch) { // Parse numbers until 'ch' storing them in arr;
    // Returns the number of characters to skip
    long num, num_len, skip = 0, arr_len = 0;
    while (*ptr && *ptr != ch) {
        if (*ptr >= '0' && *ptr <= '9') {
            num = parseNumber(ptr, &num_len);
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

Array *parseMappings(unsigned char *key,
                     unsigned char **_ptr) { // Get the dimensions of the Almanac mappings
    unsigned char line[LINE_LEN], *ptr, *lptr;
    unsigned long arr[512]; 
    long arr_len, len;
    Array *mappings;

    mappings = NULL;
    ptr = *_ptr;
    len = 0;

    while (getLine(&ptr, line)) {
        lptr = line;
        if (*lptr == '\0') {
            goto out;
        }

        parseNumbersUntil(arr, &arr_len, lptr, '\0');
        if (!mappings) {
            mappings = arrayNew(key, 0, arr_len);
        }
        for (long i = 0; i < arr_len; ++i) {
            mappings->data[len++] = arr[i];
        }
        mappings->rows++;
    }
out:
    return mappings;
}

unsigned char *getKey(unsigned char *ptr, long *_len) {
    unsigned long len;
    unsigned char *key;
    key = malloc(sizeof(unsigned char) * 100);
    len = 0;
    while (*ptr && *ptr != ':' && *ptr != ' ') {
        key[len++] = *ptr;
        ptr++;
    }
    key[len] = '\0';
    *_len = len;
    return key;
}

Ht *parseInput(unsigned char *buffer) {
    Array *arr;
    Ht *ht = htNew(HT_SIZE);
    unsigned char line[LINE_LEN], *ptr, *lptr, *key, ch;
    long len, arr_len;
    ptr = buffer;

    while (getLine(&ptr, line)) {
        lptr = line;
        ch = *lptr;
        if (ch >= 'a' && ch <= 'z') {
            key = getKey(lptr, &len);
            lptr += len;
            while (*lptr != ':')
                lptr++;
            if (!strncmp((void *)key, "seeds", 5)) {
                arr = arrayNew(key, 100, 100);
                lptr += 2;
                parseNumbersUntil(arr->data, &arr->cols, lptr, '\0');
                arr->rows = 1;
                htSet(ht, key, arr);
            } else {
                arr = parseMappings(key, &ptr);
                htSet(ht, arr->key, arr);
            }
        }
    }
    return ht;
}

void qSort(long *arr, long high, long low) { // Simple quick sort
    if (low < high) {
        long pivot = arr[high];
        long idx = low;
        long i = low;
        long tmp;

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

        qSort(arr, high, idx + 1);
        qSort(arr, idx - 1, low);
    }
}

unsigned long solvePart1(Ht *t, Array *seeds) {
    unsigned long arr[7], *solutions, idx, key, src, dst, len, next, r1, r2, s1, s2,
            total, solution_idx;
    Array *ptr;
    solutions = malloc(sizeof(unsigned long) * seeds->cols);

    idx = key = src = dst = len = solution_idx = next = 0;
    arr[0] = hashIdx((unsigned char *)"seed-to-soil");
    arr[1] = hashIdx((unsigned char *)"soil-to-fertilizer");
    arr[2] = hashIdx((unsigned char *)"fertilizer-to-water");
    arr[3] = hashIdx((unsigned char *)"water-to-light");
    arr[4] = hashIdx((unsigned char *)"light-to-temperature");
    arr[5] = hashIdx((unsigned char *)"temperature-to-humidity");
    arr[6] = hashIdx((unsigned char *)"humidity-to-location");

    for (long i = 0; i < seeds->cols; ++i) {
        s1 = seeds->data[i];
        s2 = s1;
        idx = 0;
        while (idx < 7) {
            key = arr[idx];
            ptr = t->entries[key];
            total = (ptr->rows) * (ptr->cols);
            for (unsigned long row = 0; row < total; row += 3) {
                src = ptr->data[SRC_IDX + row];
                dst = ptr->data[DST_IDX + row];
                len = ptr->data[LEN_IDX + row];
                r1 = src + len;
                r2 = dst + len;
                if (src <= s2 <= r1) {
                    //"idx: %zu, src: %zu, dst: %zu,s2:%zu\n",
                    //  idx,src,dst,s2;
                    s2 -= src;
                    s2 += dst;
                    solutions[i] = s2;
                    if (idx < 7) {
                        goto jump1;
                    }
                }
            }
jump1:
            if (++idx < 7) {
                solutions[i] = s2;
            }
        }
    }
done:
    for (long i = 0; i < seeds->cols; ++i) {
        printf("seed:%zu => %zu\n", seeds->data[i], solutions[i]);
    }
    qSort((long *)solutions, seeds->cols - 1, 0);
    for (long i = 0; i < seeds->cols; ++i) {
        printf("%zu\n", solutions[i]);
    }
    return solutions[0];
}

unsigned long getNextLocation(Array *ptr, long seed) {
    unsigned long src, dst, len, r1, r2, total;
    total = ptr->rows * ptr->cols;
    for (unsigned long row = 0; row < total; row += 3) {
        src = ptr->data[SRC_IDX + row];
        dst = ptr->data[DST_IDX + row];
        len = ptr->data[LEN_IDX + row];
        r1 = src + len;
        r2 = dst + len;
        if (seed >= src && seed <= r1) {
            seed -= src;
            seed += dst;
            return seed;
        }
    }
    return seed;
}

typedef struct threadCtx {
    unsigned long start;
    unsigned long end;
    unsigned long min;
    unsigned long id;
    Ht *ht;
    pthread_t th;
} threadCtx;

void *threadRunner(void *argv) {
    threadCtx *ctx = (threadCtx *)argv;
    printf("Thread: %zu doing %zu to %zu\n",ctx->id,ctx->start,ctx->end);
    unsigned long arr[7], *solutions, *seen, key, src, dst, len, r1, r2, s1, s2, total,
            solution_idx, range;
    Array *ptr;
    range = ctx->end - ctx->start;
    unsigned long min = UINT_MAX;
    key = src = dst = len = solution_idx = 0;
    arr[0] = hashIdx((unsigned char *)"seed-to-soil");
    arr[1] = hashIdx((unsigned char *)"soil-to-fertilizer");
    arr[2] = hashIdx((unsigned char *)"fertilizer-to-water");
    arr[3] = hashIdx((unsigned char *)"water-to-light");
    arr[4] = hashIdx((unsigned char *)"light-to-temperature");
    arr[5] = hashIdx((unsigned char *)"temperature-to-humidity");
    arr[6] = hashIdx((unsigned char *)"humidity-to-location");
    for (long seed = ctx->start; seed <= ctx->end; ++seed) {
        s1 = seed;
        for (long idx = 0; idx < 7; ++idx) {
            key = arr[idx];
            ptr = ctx->ht->entries[key];
            s1 = getNextLocation(ptr, s1);
        }
        if (s1 < min) {
            min = s1;
        }
    }

    printf("THREAD: %zu min -> %zu\n", ctx->id, min);
    ctx->min = min;
    return NULL;
}

long solve2(Ht *ht) {
    long idx = hashIdx((unsigned char *)"seeds");
    Array *seeds = ht->entries[idx];
    long start, end, len;
    long *mins = malloc(sizeof(long) * 5000);
    len = 0;
    long id = 0;
    threadCtx *contexts, *ctx;
    contexts = malloc(sizeof(threadCtx) * 50);

    for (long i = 0; i < seeds->cols; i += 2) {
        ctx = &contexts[id++];
        ctx->id = id;
        ctx->start = seeds->data[i];
        ctx->end = ctx->start + seeds->data[i + 1];
        ctx->ht = ht;
        printf("start %zu end: %zu\n"
                "s: %zu len: %zu\n",ctx->start,ctx->end,
                seeds->data[i],seeds->data[i+1]);
        ctx->min = LONG_MAX;
        pthread_create(&ctx->th,NULL,threadRunner,ctx);
    }

    for (long i = 0; i < id; ++i) {
        pthread_join(contexts[i].th,NULL);
    }
    unsigned long min = LONG_MAX;
    for (long i = 0; i < id; ++i) {
        ctx = &contexts[i];
        if (ctx->min < min) {
            min = ctx->min;
        }
    }

    return min;
}

unsigned char *fileRead(char *file_name, long size, long *_len) {
    unsigned char *buffer = malloc(sizeof(unsigned char) * size);
    int fd;
    if ((fd = open(file_name, O_RDONLY, 0644)) == -1) {
        fprintf(stderr, "Cannot open file: %s\n", file_name);
        exit(1);
    }
    *_len = read(fd, buffer, size);
    buffer[*_len] = '\0';
    return buffer;
}

int main(int argc, char **argv) {
    long len;
    unsigned char *buffer = fileRead("./input.txt", 50000, &len);
    Ht *ht = parseInput(buffer);
    //  long idx = HashIdx("seeds");
    //  Array *seeds = ht->entries[idx];
    // Array *expanded_seeds = ExpandSeeds(seeds);
    //  "%zu\n",expanded_seeds->cols;
    //  HtScan(ht);
    // unsigned long pt1 = SolvePart1(ht,seeds);
    //"part1:%zu\n",pt1;
    unsigned long pt2 = solve2(ht);
    printf("part2:%zu\n", pt2);
}
