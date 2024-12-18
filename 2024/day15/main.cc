#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#define MAX_ROWS 100
#define MAX_COLS 100

char grid[MAX_ROWS][MAX_COLS];
char *input_moves;
int moves = 0;
int rows, cols;
int RX, RY;

// Movement directions: Up, Down, Left, Right
int dx[] = {-1, 1, 0, 0};
int dy[] = {0, 0, -1, 1};

// Direction map: '^' -> 0, 'v' -> 1, '<' -> 2, '>' -> 3
int getDirection(char c) {
    if (c == '^') return 0;
    if (c == 'v') return 1;
    if (c == '<') return 2;
    if (c == '>') return 3;
    return -1;
}

// Function to move the robot
void moveRobot(char dir) {
    int D = getDirection(dir);
    int DX = dx[D];
    int DY = dy[D];

    int nx = RX;
    int ny = RY;

    while (1) {
        nx += DX;
        ny += DY;
        char next = grid[ny][nx];
        if (next == '#') return;
        if (next == '.') break;
    }

    while (1) {
        int PX = nx - DX;
        int PY = ny - DY;
        grid[ny][nx] = grid[PY][PX];
        nx = PX;
        ny = PY;
        if (nx == RX && ny == RY) break;
    }

    grid[RY][RX] = '.';
    RX += DX;
    RY += DY;
}

// Calculate GPS coordinates of all boxes
int part1(void) {
    int gps_sum = 0;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] == 'O') {
                gps_sum += (100 * i) + j;
            }
        }
    }
    return gps_sum;
}

void init(const char *path) {
    int state = 0, X=0, Y=0, move=0;
    int fd = open(path, O_RDONLY,0664);
    long len = lseek(fd,0,SEEK_END);
    lseek(fd,0,SEEK_SET);

    char *buf = (char *)malloc(sizeof(char)*len);
    read(fd,buf,len);
    input_moves = (char *)malloc(sizeof(char)*100000);

    for (char *ptr = buf; *ptr; ptr++) {
        if (*ptr == '\n' && *(ptr+1) =='\n') {
            state = 1;
            ptr += 2;
        } else if (*ptr == '\n') {
            switch (state) {
                case 0: Y++; X = 0; ptr++; break;
                case 1: ptr++; break;
            }
        }

        if (*ptr == '\0') break;
        if (*ptr == '@') { RX = X; RY = Y; }

        switch (state) {
            case 0: grid[Y][X++] = *ptr; break;
            case 1: input_moves[move++] = *ptr; break;
        }
    }

    rows = Y;
    cols = X;
    printf("rows=%d cols=%d\n",rows,cols);
    printf("RX=%d RY=%d\n",RX,RY);

    moves = move;
    close(fd);
    free(buf);
}

int main() {
    init("./example.txt");
    rows = 0;

    for (int i = 0; i < moves; ++i) {
        moveRobot(input_moves[i]);
    }

    // Output the sum of GPS coordinates
    printf("GPS: %d\n", part1());
    free(input_moves);
    return 0;
}

