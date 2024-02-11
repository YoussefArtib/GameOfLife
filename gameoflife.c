#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <time.h>

#define WIDTH 40
#define HEIGHT 40
bool grid[HEIGHT][WIDTH] = {0};
bool grid_next[HEIGHT][WIDTH] = {0};

void init_grid() 
{
    grid[1][25] = 1;
    grid[2][23] = 1;
    grid[2][25] = 1;
    grid[3][13] = 1;
    grid[3][14] = 1;
    grid[3][21] = 1;
    grid[3][22] = 1;
    grid[3][35] = 1;
    grid[3][36] = 1;
    grid[4][12] = 1;
    grid[4][16] = 1;
    grid[4][21] = 1;
    grid[4][22] = 1;
    grid[4][35] = 1;
    grid[4][36] = 1;
    grid[5][1]  = 1;
    grid[5][2]  = 1;
    grid[5][11] = 1;
    grid[5][17] = 1;
    grid[5][21] = 1;
    grid[5][22] = 1;
    grid[6][1]  = 1;
    grid[6][2]  = 1;
    grid[6][11] = 1;
    grid[6][15] = 1;
    grid[6][17] = 1;
    grid[6][18] = 1;
    grid[6][23] = 1;
    grid[6][25] = 1;
    grid[7][11] = 1;
    grid[7][17] = 1;
    grid[7][25] = 1;
    grid[8][12] = 1;
    grid[8][16] = 1;
    grid[9][13] = 1;
    grid[9][14] = 1;
}

void display_grid(bool grid[HEIGHT][WIDTH])
{
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            if (grid[y][x]) {
                // printf("o");
                printf("\033[40;37mo\033[0m ");
            } else {
                printf(". ");
            }
        }
        printf("\n");
    }
}

int modulo(int a, int b) {
    return (a%b + b)%b;
}

int count_neighbors(int y, int x)
{
    int count = 0;
    for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
            int iy = modulo(y + dy, HEIGHT);
            int ix = modulo(x + dx, WIDTH);
            if (grid[iy][ix]) 
            {
                count += 1;
            }
        }
    }
    if (grid[y][x]) count -= 1;
    return count;
}

void next_gen() {
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            int count = count_neighbors(y, x);
            if (!grid[y][x])
            {
                if (count == 3) {
                    grid_next[y][x] = 1;
                }
                // } else {
                //     grid_next[y][x] = 0;
                // }
            }
            if (grid[y][x]) 
            {
                if (count == 2 || count == 3) {
                    grid_next[y][x] = 1;
                }
                // } else {
                //     grid_next[y][x] = 0;
                // }
            }
        }
    }
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            grid[y][x] = grid_next[y][x];
            grid_next[y][x] = 0;
        }
    }
}

int main(void) {
    init_grid();
    for(;;) {
        display_grid(grid);
        usleep(150000);
        printf("\033[2J\033[0;0f");
        next_gen();
    }
    return 0;
}
