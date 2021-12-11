import std.stdio;
import std.string;
import std.container;
import std.typecons;

void main() {
    File input = File("input.txt", "r");
    char[10][10] grid;
    for (int i = 0; i < 10; ++i)
        grid[i] = input.readln.chomp;
    for (int i = 0; i < 10; ++i)
        for (int j = 0; j < 10; ++j)
            grid[i][j] -= '0';
    
    int ans;
    for (int step = 1; true; ++step) {
        auto flashed_set = redBlackTree!(Tuple!(int, int))();
        bool flashed = true;
        while(flashed) {
            flashed = false;
            for (int i = 0; i < 10; ++i)
                for (int j = 0; j < 10; ++j)
                    if (grid[i][j] >= 9) {
                        flashed = true;
                        flashed_set.insert(tuple(i, j));
                        foreach (int y_offset; [-1, 0, 1])
                            foreach (int x_offset; [-1, 0, 1]) {
                                int y = i + y_offset;
                                int x = j + x_offset;
                                if (0 <= x && x < 10 &&
                                    0 <= y && y < 10 &&
                                    tuple(y, x) !in flashed_set)
                                    ++grid[y][x];
                            }
                        grid[i][j] = 0;
                    }
        }
        if (flashed_set.length == 100) {
            ans = step;
            break;
        }
        for (int i = 0; i < 10; ++i)
            for (int j = 0; j < 10; ++j)
                if (tuple(i, j) !in flashed_set)
                    ++grid[i][j];
    }
    ans.writeln;
}