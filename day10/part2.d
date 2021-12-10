import std.stdio;
import std.string;
import std.algorithm;

void main() {
    File input = File("input.txt", "r");
    string line = input.readln.chomp;

    char[char] delimiters;
    delimiters['('] = ')';
    delimiters['['] = ']';
    delimiters['{'] = '}';
    delimiters['<'] = '>';

    long[char] value;
    value['('] = 1;
    value['['] = 2;
    value['{'] = 3;
    value['<'] = 4;

    char[100] stack;
    int stack_i = -1;
    long[] scores;
    while (!line.empty()) {
        bool flag = false;
        foreach (char c; line) {
            if (c in delimiters) {
                ++stack_i;
                stack[stack_i] = c;
            } else {
                if (stack_i == -1 || delimiters[stack[stack_i]] != c) {
                    flag = true;
                    break;
                }
                --stack_i;
            }
        }
        if (flag) {
            line = input.readln.chomp;
            stack_i = -1;
            continue;
        }
        long score = 0;
        while (stack_i > -1) {
            score *= 5;
            score += value[stack[stack_i]];
            --stack_i;
        }
        scores ~= score;
        stack_i = -1;
        line = input.readln.chomp;
    }
    scores.sort;
    scores[scores.length/2].writeln;
}