// Dafny 入門ツアー。
// 検証:  dafny verify dafny/Intro.dfy
// 実行:  dafny run  dafny/Intro.dfy
//
// Dafny は「仕様つきの命令型言語」。事前条件 requires / 事後条件 ensures /
// ループ不変条件 invariant を書くと、SMT ソルバ (Z3) が自動で証明します。

// ---------------------------------------------------------------------------
// 1. 関数と事後条件
// ---------------------------------------------------------------------------

// `function` は純粋（副作用なし）で、仕様の中からも呼べます。
function Abs(x: int): int
{
  if x < 0 then -x else x
}

// `method` は命令型。ensures が事後条件。
method AbsMethod(x: int) returns (y: int)
  ensures y >= 0
  ensures y == x || y == -x
{
  if x < 0 { y := -x; } else { y := x; }
}

// ---------------------------------------------------------------------------
// 2. 事前条件とループ不変条件
// ---------------------------------------------------------------------------

// requires を外すと n < 0 のとき停止しないので、Dafny に怒られます。
method SumTo(n: int) returns (s: int)
  requires n >= 0
  ensures 2 * s == n * (n + 1)
{
  s := 0;
  var i := 0;
  while i < n
    invariant 0 <= i <= n
    invariant 2 * s == i * (i + 1)
  {
    i := i + 1;
    s := s + i;
  }
}

// ---------------------------------------------------------------------------
// 3. 配列と読み取りフレーム
// ---------------------------------------------------------------------------

method Max(a: array<int>) returns (m: int)
  requires a.Length > 0
  ensures forall i :: 0 <= i < a.Length ==> a[i] <= m
  ensures exists i :: 0 <= i < a.Length && a[i] == m
{
  m := a[0];
  var k := 1;
  while k < a.Length
    invariant 1 <= k <= a.Length
    invariant forall i :: 0 <= i < k ==> a[i] <= m
    invariant exists i :: 0 <= i < k && a[i] == m
  {
    if a[k] > m { m := a[k]; }
    k := k + 1;
  }
}

// ---------------------------------------------------------------------------
// 4. 再帰・停止性・補題
// ---------------------------------------------------------------------------

// `decreases` は停止性の指標。ここは自明なので Dafny が推論してくれます。
function Fib(n: nat): nat
{
  if n < 2 then n else Fib(n - 1) + Fib(n - 2)
}

// 定義だけからは自明でない事実は `lemma` で示します。
lemma FibMonotonic(n: nat)
  ensures Fib(n) <= Fib(n + 1)
{
  // 帰納法。Dafny は再帰呼び出しを帰納法の仮定として扱います。
  if n >= 2 {
    FibMonotonic(n - 1);
  }
}

// ---------------------------------------------------------------------------
// 5. 状態を持つクラスと表現不変条件
// ---------------------------------------------------------------------------

class Counter
{
  var value: int

  // オブジェクト不変条件は述語として書き、requires/ensures で持ち回します。
  ghost predicate Valid()
    reads this
  {
    value >= 0
  }

  constructor()
    ensures Valid() && value == 0
  {
    value := 0;
  }

  method Inc()
    requires Valid()
    modifies this
    ensures Valid() && value == old(value) + 1
  {
    value := value + 1;
  }
}

// ---------------------------------------------------------------------------
// 6. 動かしてみる
// ---------------------------------------------------------------------------

method Main()
{
  var s := SumTo(10);
  print "SumTo(10) = ", s, "\n";

  var a := new int[5];
  a[0], a[1], a[2], a[3], a[4] := 3, 1, 4, 1, 5;
  var m := Max(a);
  print "Max([3,1,4,1,5]) = ", m, "\n";

  var c := new Counter();
  c.Inc();
  c.Inc();
  print "Counter = ", c.value, "\n";
}
