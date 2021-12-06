import std.stdio;
import std.string;
import std.conv: to;
import std.typecons: tuple, Tuple;
import std.algorithm: map, filter;
import std.array: array;
import std.ascii: isWhite;

bool all(bool[] arr) {
    foreach (elem; arr)
        if (!elem)
            return false;
    return true;
}

Tuple!(int, int) solve(
    int[] numbers,
    int[][][] boards,
    Tuple!(int, int)[int][] indices,
    bool[5][5][] checkboards
) {
    foreach (int number; numbers) {
        for (int i = 0; i < boards.length; ++i) {
            Tuple!(int, int)* p = number in indices[i];
            if (p !is null) {
                auto index = *p;
                int row = index[0];
                int col = index[1];
                checkboards[i][row][col] = true;
            }
        }
        for (int i = 0; i < checkboards.length; ++i) {
            foreach (row; checkboards[i])
                if (all(row))
                    return tuple(i, number);
            for (int col = 0; col < checkboards[i][0].length; ++col) {
                bool flag = true;
                for (int row = 0; row < checkboards[i].length; ++row)
                    flag = flag && checkboards[i][row][col];
                if (flag)
                    return tuple(i, number);
            }
        }
    }
    assert(0);
}

auto print(T)(T x) {
    x.writeln;
    return x;
}

void main() {
    File input = File("input.txt", "r");
    int[] numbers = input
        .readln.chomp
        .split(",")
        .map!(to!int)
        .array;
    string line = input.readln;
    int[][][] boards;
    Tuple!(int, int)[int][] indices;
    int count = 0;
    int i = 0;
    while (!line.empty()) {
        if (line == "\n") {
            boards ~= new int[][](5, 5);
            Tuple!(int, int)[int] m;
            indices ~= m;
            i = 0;
            ++count;
            line = input.readln;
        }

        int[] row = line
            .split!isWhite
            .filter!(x => !x.empty)
            .map!(to!int)
            .array;

        for (int j = 0; j < 5; ++j) {
            boards[$-1][i][j] = row[j];
            indices[$-1][row[j]] = tuple(i, j);
        }
        ++i;

        line = input.readln;
    }

    auto checkboards = new bool[5][5][](count);

    auto result = solve(numbers, boards, indices, checkboards);
    int board_i = result[0];
    int n = result[1];
    int a = 0;
    for (i = 0; i < 5; ++i)
        for (int j = 0; j < 5; ++j)
            if (!checkboards[board_i][i][j])
                a += boards[board_i][i][j];

    writeln(n * a);
}