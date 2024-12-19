#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#include <vector>

#define MAX_ROWS 100
#define MAX_COLS 100

// Movement directions: Up, Down, Left, Right
static const int dirs[][2] = {
    {-1,0},
    {1, 0},
    {0,-1},
    {0, 1},
};

int getDirection(char dir) {
    if      (dir == '^') return 0;
    else if (dir == 'v') return 1;
    else if (dir == '<') return 2;
    else if (dir == '>') return 3;
    return -1;
}

struct RobotMap {
    int RX, RY; // robot
    int BX, BY; // bounds
    char grid[MAX_ROWS][MAX_COLS];
    std::vector<char> moves;

    void PrintGrid(void) {
        for (int y = 0; y < BY; ++y) {
            for (int x = 0; x < BX; ++x) {
                printf("%c",grid[y][x]);
            }
            printf("\n");
        }
    }

    void PrintMoves(void) {
        for (const auto &ch : moves) {
            printf("%c", ch);
        }
        printf("\n");
    }

    void Walk(int DY, int DX) {
        int nx = RX,ny=RY,PX,PY;
        char next;

        while (1) {
            nx += DX;
            ny += DY;
            next = grid[ny][nx];
            if (next == '#') return;
            if (next == '.') break;
        }

        while (1) {
            PX = nx - DX;
            PY = ny - DY;
            grid[ny][nx] = grid[PY][PX];
            nx = PX;
            ny = PY;
            if (nx == RX && ny == RY) break;
        }

        grid[RY][RX] = '.';
        RX += DX;
        RY += DY;
    }

    ssize_t Part1(void) {
        for (char ch : moves) {
            int D = getDirection(ch);
            Walk(dirs[D][0],dirs[D][1]);
        }

        ssize_t acc = 0;
        for (int y = 0; y < BY; y++) {
            for (int x = 0; x < BX; x++) {
                if (grid[y][x] == 'O') {
                    acc += (100 * y) + x;
                }
            }
        }
        return acc;
    }
};

char *readFile(const char *path) {
    int state = 0, X=0, Y=0, move=0;
    int fd = open(path, O_RDONLY,0664);
    long len = lseek(fd,0,SEEK_END);
    lseek(fd,0,SEEK_SET);

    char *buf = (char *)malloc(sizeof(char)*len);
    read(fd,buf,len);
    close(fd);
    return buf;
}

RobotMap *parse(char *buffer) {
    int state = 0, x = 0, y = 0;
    char *ptr = buffer;
    RobotMap *map = new RobotMap();
    while (1) {
        if (*ptr == '\n'  && *(ptr+1) == '\n') {
            map->BY++;
            ptr += 2;
            break;
        }
        if (*ptr == '\n') {
            map->BX = 0;
            map->BY++;
            ptr++;
        }

        if (*ptr == '@') {
            map->RX = map->BX;
            map->RY = map->BY;
        }
        map->grid[map->BY][map->BX++] = *ptr++;
    }

    while (1) {
        if (*ptr == '\n') ptr++;
        if (*ptr == '\0') break;
        map->moves.push_back(*ptr++);
    }

    return map;
}


int main() {
    char *buffer = readFile("./input.txt");
    auto robot = parse(buffer);
    printf("Part1: %ld\n", robot->Part1());

    free(buffer);

    delete robot;
    return 0;
}
