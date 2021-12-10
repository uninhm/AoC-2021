module day06.part1;

import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.array;

void main() {
    File input = File("input.txt", "r");
    int[] l = input.readln.chomp.split(",").map!(to!int).array;
    for (int i = 0; i < 80; ++i) {
        int[] new_generation;
        foreach (elem; l)
            if (elem == 0) {
                new_generation ~= 6;
                new_generation ~= 8;
            } else
                new_generation ~= elem - 1;
        l = new_generation;
    }
    l.length.writeln;
}