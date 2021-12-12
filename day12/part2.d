import std.stdio;
import std.string;
import std.typecons;
import std.container;
import std.ascii: isUpper;

bool isBig(string s) {
    return s[0].isUpper;
}

void unpack(T)(T*[] vars, T[] data) {
    for (int i = 0; i < vars.length; ++i)
        *vars[i] = data[i];
}

void main() {
    File input = File("input.txt", "r");
    string line = input.readln.chomp;
    string[][string] graph;
    while (!line.empty()) {
        string a, b;
        [&a, &b].unpack(line.chomp.split("-"));
        graph[a] ~= b;
        graph[b] ~= a;
        line = input.readln.chomp;
    }
    Tuple!(RedBlackTree!string, string, bool)[1000] stack;
    int stack_i = 0;
    stack[stack_i++] = tuple(redBlackTree!string(), "start", false);
    int ans = 0;
    while(stack_i) {
        auto t = stack[--stack_i];
        auto rbt = t[0];
        string last = t[1];
        bool visited_small = t[2];
        rbt.insert(last);

        foreach (elem; graph[last]) {
            if (elem == "end") ++ans;
            else if (elem != "start")
                if (elem.isBig || elem !in rbt)
                    stack[stack_i++] = tuple(rbt.dup, elem, visited_small);
                else if (!visited_small)
                    stack[stack_i++] = tuple(rbt.dup, elem, true);
        }
    }
    ans.writeln;
}