#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Max dimensions of one of these things is 4 x 4
 * Can be represented by a 16bit integer
 *
 * 0000
 * 0000
 * 0000
 * 0000
 *
 * thus
 * ....
 * ....
 * ....
 * ####
 * 0000 0000 0000 1111
 *
 * .#..
 * ###.
 * .#..
 *
 * 0000 0100 1110 0100
 *
 * ..#.
 * ..#.
 * ..#.
 * ###.
 * 0010 0010 0010 1110
 *
 * #...
 * #...
 * #...
 * #...
 * 0001 0001 0001 0001
 *
 * ....
 * ....
 * ##..
 * ##..
 * 1100 1100 0000 0000
 * */
#define FLAT (0xF000)
#define PLUS (0x4E40L)
#define LPLATE (0x7444)
#define LINE (0x1111L)
#define BOX (0x3300L)

static const unsigned int SK5 = 0x55555555;
static const unsigned int SK3 = 0x33333333;
static const unsigned int SKF0 = 0xF0F0F0F;

static inline int popcount(unsigned int bits) {
	bits -= ((bits >> 1) & SK5);
	bits = (bits & SK3)  + ((bits >> 2) & SK3);
	bits = (bits & SKF0) + ((bits >> 4) & SKF0);
	bits += bits >> 8;
	return (bits + (bits >> 16)) & 0x3F;
}

/**
 *
 *
 * 16bit
 * 00000001 0000 0001
 *        | .... ...|
 *        + ---- ---+
 * 00000001 1111 1111
 */
short *makePlayingGrid(int max_height, int rounds) {
    /* A short gives us 16 bits to play with */
    short *grid = calloc(max_height * rounds, sizeof(short));

    for (int i = 0; i < max_height * rounds; ++i) {
        if (i == max_height*rounds-1 || i == 0) {
            grid[i] = 0x1FF;
        } else {
            grid[i] = 0x101;
        }
    }

    return grid;
}

void gridPrint(short *grid) {
    for (int i = 50; i >= 0; --i) {
        short row = grid[i];
        for (int n = 0; n < 9; ++n) {
            int has_bit = row >> n & 1;
            /* if something there the nth bit */
            if (has_bit && i == 0) {
                printf("-");
            }else if (has_bit) {
                printf("@");
            } else {
                printf(".");
            }
        }
        printf(":%d\n",i);
    }
    printf("\n");
}

short rockRowBits(short rock, int row) {
    short width = 0;
    for (short x = 0; x < 4; ++x) {
        width += rock >> (x+row*4) & 1;
    }
    return width;
}

short rockFirstBitPosition(short rock) {
    for (short x = 0; x < 4; ++x) {
        if (rock >> (x+4*4) & 1) {
            return x;
        }
    }
    return -1;
}

short rockHeight(short rock) {
    short max_height = 0;
    for (short y = 0; y < 4; ++y) {
        short acc = 0;
        for (short x = 0; x < 4; ++x) {
            acc += rock >> (y+x*4) & 1;      
        } 
        if (acc > max_height) {
            max_height = acc;
        }
    }
    return max_height;
}

void printRock(short rock) {
    for (short i = 0; i < 16; ++i) {
        if (i != 0 && i % 4 == 0) {
            printf("\n");
        }
        if (rock >> i & 1) {
            printf("#");
        } else {
            printf(".");
        }
    }
    printf("\n");
}

int boundedIncr(int x, int bounds) {
    return x + 1 == bounds ? 0 : x + 1;
}

int boundedDecr(int x) {
    return x - 1 == -1 ? 0 : x - 1;
}

/* As the grid fills up this will get slow */
int nextClearRow(short *grid, int height) {
    int row = 0;
    for (int i = height; i >= 0; --i) {
        int clear = 1;
        for (int x = 1; x < 7; ++x) {
            if (row >> x & 1) {
                clear = 0;
            } 
        }

        if (clear) {
            row = i;
            return row;
        }
    }
    return row;
}

int simulateRockFall(short *grid, char *shifts, int shift_len) {
    int run = 2023;
    int height = 0;
    int rocks[] = {FLAT,PLUS,LPLATE,LINE,BOX};
    int rock_len = sizeof(rocks) / sizeof(rocks[0]);
    int cur = -1;
    int loc = -1;

    while (run--) {
        int rock = rocks[boundedIncr(cur,rock_len-1)];
        int rock_height = rockHeight(rock);
        int clear_row = nextClearRow(grid,rock_height);
        int shift = 3;
        int rock_post = rockFirstBitPosition(rock);
        printRock(rock);
        printf("bits: %d\n", rockRowBits(rock,3));
        printf("bitpos: %d\n", rock_post);
        printf("clear row: %d\n", clear_row);
        int rock_row = 0;


        for (int y = clear_row + 2; y >= 0; --y) {
            short row = grid[y];
            short lshift = 1;

            if (shifts[boundedIncr(loc,shift_len-1)] == '>') {
                printf("is right\n");
                shift = shift + 1 > 7 ? 7 : shift + 1;
                lshift = 0;
            } else {
                shift = shift - 1 < 0 ? 0 : shift -1;
            }

            for (int n = 1; n < 7; ++n) {
                /* if something there the nth bit */
                int collision = y+1;
                if (row >> n & 1) {
                    /* how many bits to OR in from where 
                     * then loop up doing the same
                     * */
                    int bits = popcount((rock >> (0+rock_row*4)));
                    if (lshift) {
                        grid[collision] |= ((1 << bits) - 1) << n;
                        printf("row: %d, lshift y: %d 0x%X mask: 0x%X\n", y+1, y, bits, ((1 << bits) - 1));
                        printf("y:%d\n", y);
                        break;
                        //exit(1);
                    } else {
                        int mask = ((1 << bits) - 1);
                        grid[collision] |= mask << shift;
                        printf("row: %d, lshift y: %d 0x%X mask: 0x%X\n", y+1, shift, bits,  mask);
                        break;
                    }
                } else {
                    printf(".");
                }
            }
            printf("\n");
        }
        run = 0;
    }

    gridPrint(grid);

    return height;
}

int main(void) {
    FILE *fp = fopen("./warmup.txt", "r");

    if (fp == NULL) {
        perror("Failed to open file");
        exit(1);
    }

    fseek(fp,0,SEEK_END);
    size_t len = ftell(fp);
    fseek(fp,0,SEEK_SET);
    char *buf = malloc(sizeof(char)*len);
    long nbytes = fread(buf,len,len*sizeof(char),fp);

    if (nbytes == 0) {
        fprintf(stderr,"Failed to fread: %s\n",strerror(ferror(fp)));
        exit(1);
    } 

    short *grid = makePlayingGrid(4,2022);
    simulateRockFall(grid,buf,len);
    printf("%s\n",buf);

    fclose(fp);
}
