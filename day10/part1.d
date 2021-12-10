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
    value[')'] = 3;
    value[']'] = 57;
    value['}'] = 1197;
    value['>'] = 25_137;

    char[100] stack;
    int stack_i = -1;
    long ans = 0;
    while (!line.empty()) {
        foreach (char c; line) {
            if (c in delimiters) {
                ++stack_i;
                stack[stack_i] = c;
            } else {
                if (stack_i == -1 || delimiters[stack[stack_i]] != c) {
                    ans += value[c];
                    break;
                }
                --stack_i;
            }
        }
        stack_i = -1;
        line = input.readln.chomp;
    }
    ans.writeln;
}