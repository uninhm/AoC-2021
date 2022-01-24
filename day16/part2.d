import std.stdio;
import std.string;
import std.ascii : isDigit;

ulong idx;

class Node {
  ulong ver;
  ulong type_id;

  this() {
  }

  this(ulong ver, ulong type_id) {
    this.ver = ver;
    this.type_id = type_id;
  }
}

class LiteralNode : Node {
  ulong value;

  this(ulong ver, ulong value) {
    this.ver = ver;
    this.type_id = 4;
    this.value = value;
  }

  this(ulong value) {
    this.value = value;
  }
}

class OperatorNode : Node {
  Node[] children;
}

ubyte char_to_hex(char c) {
  if (c.isDigit)
    return cast(ubyte)(c - '0');
  return cast(ubyte)(c - 'A' + 10);
}

ubyte get_bit(const ref string line, ulong i) {
  int char_idx = cast(int)(i / 4);
  int half_byte = line[char_idx].char_to_hex;
  return (half_byte >> (3 - (i % 4))) & 1;
}

ulong get_bits(const ref string line, ulong n) {
  ulong result = 0;
  for (ulong o = 0; o < n; ++o) // o stands for offset
    result |= line.get_bit(idx++) << (n - o - 1);
  return result;
}

Node parse_packet(const ref string line) {
  ulong ver = line.get_bits(3);
  ulong type_id = line.get_bits(3);
  if (type_id == 4) {
    LiteralNode n = line.parse_literal();
    n.ver = ver;
    n.type_id = 4;
    return n;
  } else {
    OperatorNode n = line.parse_operator();
    n.ver = ver;
    n.type_id = type_id;
    return n;
  }
}

LiteralNode parse_literal(const ref string line) {
  ulong value = 0;
  ubyte prefix;
  do {
    prefix = line.get_bit(idx++);
    value <<= 4;
    value |= line.get_bits(4);
  }
  while (prefix);
  return new LiteralNode(value);
}

OperatorNode parse_operator(const ref string line) {
  ubyte length_type_id = line.get_bit(idx++);
  auto res = new OperatorNode();
  if (length_type_id == 0) {
    ulong length_subpackets = line.get_bits(15);
    ulong start = idx;
    while (idx < start + length_subpackets)
      res.children ~= line.parse_packet();
  } else {
    ulong number_of_subpackets = line.get_bits(11);
    while (number_of_subpackets--)
      res.children ~= line.parse_packet();
  }
  return res;
}

ulong solve(Node n) {
  if (auto ln = cast(LiteralNode) n)
    return ln.value;

  auto on = cast(OperatorNode) n;

  switch (on.type_id) {
  case 0:
    return solve_sum(on);
  case 1:
    return solve_product(on);
  case 2:
    return solve_min(on);
  case 3:
    return solve_max(on);
  case 5:
    return solve_gt(on);
  case 6:
    return solve_lt(on);
  case 7:
    return solve_eq(on);
  default:
    assert(0);
  }
}

ulong solve_sum(OperatorNode n) {
  ulong res = 0;
  foreach (child; n.children)
    res += solve(child);
  return res;
}

ulong solve_product(OperatorNode n) {
  ulong res = 1;
  foreach (child; n.children)
    res *= solve(child);
  return res;
}

ulong solve_min(OperatorNode n) {
  ulong res = ulong.max;
  ulong sol;
  foreach (child; n.children)
    if ((sol = solve(child)) < res)
      res = sol;
  return res;
}

ulong solve_max(OperatorNode n) {
  ulong res = 0;
  ulong sol;
  foreach (child; n.children)
    if ((sol = solve(child)) > res)
      res = sol;
  return res;
}

ulong solve_gt(OperatorNode n) {
  assert(n.children.length == 2);
  return solve(n.children[0]) > solve(n.children[1]);
}

ulong solve_lt(OperatorNode n) {
  assert(n.children.length == 2);
  return solve(n.children[0]) < solve(n.children[1]);
}

ulong solve_eq(OperatorNode n) {
  assert(n.children.length == 2);
  return solve(n.children[0]) == solve(n.children[1]);
}

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  while (!line.empty) {
    idx = 0;
    Node root = line.parse_packet();
    root.solve.writeln;
    line = input.readln.chomp;
  }
}
