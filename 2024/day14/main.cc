#include <stdio.h>

#include <set>
#include <vector>
#include <array>

#define WIDTH  (101)
#define HEIGHT (103)
#define T      (100)
#define CX     (WIDTH/2)
#define CY     (HEIGHT/2)

struct Robot {
    long x, y,vx, vy;
    Robot(long _x, long _y, long _vx, long _vy):
        x(_x), y(_y), vx(_vx), vy(_vy) {}
    std::pair<long, long> at(long t) const {
        long nx = (x + vx * t) % WIDTH;
        long ny = (y + vy * t) % HEIGHT;
        if (nx < 0) nx += WIDTH;
        if (ny < 0) ny += HEIGHT;
        return {nx, ny};
    }
};

std::vector<Robot> parse(void) {
    std::vector<Robot> robots;
    char line[256];
    long px, py, vx, vy;

    while (fgets(line, sizeof(line), stdin)) {
        if (sscanf(line, "p=%ld,%ld v=%ld,%ld", &px, &py, &vx, &vy) == 4) {
            robots.push_back(Robot(px,py,vx,vy));
        }
    }
    return robots;
}

long computeSafety(const std::vector<Robot> &robots, int time) {
    std::array<long,4> Q = {0,0,0,0};
    for (const auto &r : robots) {
        auto [x, y] = r.at(time);
        if (x < CX && y < CY) Q[0]++;
        if (x > CX && y < CY) Q[1]++;
        if (x < CX && y > CY) Q[2]++;
        if (x > CX && y > CY) Q[3]++;
    }
    return Q[0] * Q[1] * Q[2] * Q[3];
}

long findEasterEgg(const std::vector<Robot> &robots) {
    for (long t = 1; t < WIDTH * HEIGHT; ++t) {
        std::set<std::pair<long, long>> S;
        for (const auto &r : robots) {
            S.insert(r.at(t));
        }
        if (S.size() == robots.size()) return t;
    }
    return -1;
}

long part1(const std::vector<Robot> &robots) {
    return computeSafety(robots, 100);
}

long part2(const std::vector<Robot> &robots) {
    return findEasterEgg(robots);
}

/* reads from stdin */
int main(void) {
    auto robots = parse();
    printf("Part1: %ld\n",part1(robots));
    printf("Part2: %ld\n",part2(robots));
}
