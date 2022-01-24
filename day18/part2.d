import std.stdio;
import std.string;
import std.ascii : isDigit;

abstract class Num {
  PairNum parent;

  string repr();

  PairNum find_explosion(int depth);

  bool reduce_by_explosion();
  bool reduce_by_split();
  void reduce();

  int magnitude();

  Num dup();
}

class PairNum : Num {
  Num left, right;

  this(Num left, Num right, PairNum parent = null) {
    left.parent = this;
    right.parent = this;
    this.left = left;
    this.right = right;
    this.parent = parent;
  }

  Num* get_child_by_idx(int idx) {
    if (idx == 0)
      return &left;
    if (idx == 1)
      return &right;
    assert(0);
  }

  override string repr() {
    return "[%s, %s]".format(this.left.repr, this.right.repr);
  }

  override PairNum find_explosion(int depth = 0) {
    if (cast(RegNum) this.left && cast(RegNum) this.right && depth >= 4)
      return this;
    PairNum e = this.left.find_explosion(depth + 1);
    if (e)
      return e;
    return this.right.find_explosion(depth + 1);
  }

  override bool reduce_by_explosion() {
    PairNum e = this.find_explosion();
    if (!e)
      return false;

    int side;
    if (e == e.parent.left)
      side = 0;
    else if (e == e.parent.right)
      side = 1;
    else
      assert(0);

    *e.parent.get_child_by_idx(side) = new RegNum(0, e.parent);

    Num x = *e.parent.get_child_by_idx(!side);
    while (auto px = cast(PairNum) x)
      x = *px.get_child_by_idx(side);
    (cast(RegNum) x).value += (cast(RegNum)*e.get_child_by_idx(!side)).value;

    x = e.parent;
    bool flag = true;
    while (x == *x.parent.get_child_by_idx(side)) {
      x = x.parent;
      if (!x.parent) {
        flag = false;
        break;
      }
    }

    if (flag) {
      x = *x.parent.get_child_by_idx(side);
      while (auto px = cast(PairNum) x)
        x = *px.get_child_by_idx(!side);
      (cast(RegNum) x).value += (cast(RegNum)*e.get_child_by_idx(side)).value;
    }
    return true;
  }

  override bool reduce_by_split() {
    return this.left.reduce_by_split() || this.right.reduce_by_split();
  }

  override void reduce() {
    if (this.reduce_by_explosion())
      this.reduce();
    else if (this.reduce_by_split())
      this.reduce();
    else
      return;
  }

  override int magnitude() {
    return 3 * this.left.magnitude + 2 * this.right.magnitude;
  }

  override Num dup() {
    return new PairNum(this.left.dup, this.right.dup);
  }
}

class RegNum : Num {
  int value;

  this(int value, PairNum parent = null) {
    this.value = value;
    this.parent = parent;
  }

  override string repr() {
    return "%s".format(this.value);
  }

  override PairNum find_explosion(int depth) {
    return null;
  }

  override bool reduce_by_explosion() {
    assert(0);
  }

  override bool reduce_by_split() {
    if (this.value < 10)
      return false;
    PairNum new_num = new PairNum(new RegNum(this.value / 2),
        new RegNum((this.value + 1) / 2), this.parent);
    if (this == this.parent.left)
      this.parent.left = new_num;
    else
      this.parent.right = new_num;
    return true;
  }

  override void reduce() {
  }

  override int magnitude() {
    return this.value;
  }

  override Num dup() {
    return new RegNum(this.value);
  }
}

int idx = 0;

Num parse_num(const ref string line) {
  if (line[idx] == '[')
    return parse_pairnum(line);
  else
    return parse_regnum(line);
}

PairNum parse_pairnum(const ref string line) {
  ++idx; // skip [
  Num left = parse_num(line);
  ++idx; // skip ,
  Num right = parse_num(line);
  ++idx; // skip ]
  return new PairNum(left, right);
}

RegNum parse_regnum(const ref string line) {
  int value = 0;
  while (line[idx].isDigit) {
    value *= 10;
    value += line[idx++] - '0';
  }
  return new RegNum(value);
}

Num parse(const ref string line) {
  idx = 0;
  return parse_num(line);
}

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  Num[] nums;
  while (!line.empty()) {
    nums ~= line.parse();
    line = input.readln.chomp;
  }
  int ans = 0;
  foreach (num1; nums)
    foreach (num2; nums) {
      Num n = new PairNum(num1.dup, num2.dup);
      n.reduce();
      int magn = n.magnitude;
      if (magn > ans)
        ans = magn;
    }
  ans.writeln;
}
