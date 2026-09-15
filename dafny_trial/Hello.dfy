// Dafny smoke test: verify a small spec and run it.
//   dafny verify Hello.dfy
//   dafny run Hello.dfy

function Fib(n: nat): nat {
  if n < 2 then n else Fib(n - 1) + Fib(n - 2)
}

method FibIter(n: nat) returns (r: nat)
  ensures r == Fib(n)
{
  var a, b := 0, 1;
  var i := 0;
  while i < n
    invariant 0 <= i <= n
    invariant a == Fib(i) && b == Fib(i + 1)
  {
    a, b := b, a + b;
    i := i + 1;
  }
  return a;
}

method Max(a: int, b: int) returns (m: int)
  ensures m >= a && m >= b
  ensures m == a || m == b
{
  if a >= b { m := a; } else { m := b; }
}

method Main() {
  var f := FibIter(10);
  var m := Max(3, 7);
  print "Fib(10) = ", f, ", Max(3,7) = ", m, "\n";
}
