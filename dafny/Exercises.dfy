// 練習問題。仕様 (requires / ensures) は与えてあります。
// 本体とループ不変条件を埋めて、`dafny verify dafny/Exercises.dfy` を通してください。
// 埋めるまでは検証は失敗します（それが正常な状態です）。

// ---------------------------------------------------------------------------
// 1. 2 つの値の入れ替え
// ---------------------------------------------------------------------------
method Swap(x: int, y: int) returns (a: int, b: int)
  ensures a == y && b == x
{
  a, b := 0, 0; // TODO
}

// ---------------------------------------------------------------------------
// 2. 線形探索。見つからなければ -1 を返す
// ---------------------------------------------------------------------------
method Find(a: array<int>, key: int) returns (index: int)
  ensures -1 <= index < a.Length
  ensures index >= 0 ==> a[index] == key
  ensures index == -1 ==> forall i :: 0 <= i < a.Length ==> a[i] != key
{
  index := -1; // TODO: ループと invariant を書く
}

// ---------------------------------------------------------------------------
// 3. 二分探索。ソート済み配列が前提
// ---------------------------------------------------------------------------
predicate Sorted(a: array<int>)
  reads a
{
  forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
}

method BinarySearch(a: array<int>, key: int) returns (index: int)
  requires Sorted(a)
  ensures 0 <= index < a.Length ==> a[index] == key
  ensures index == -1 ==> forall i :: 0 <= i < a.Length ==> a[i] != key
{
  index := -1; // TODO
}

// ---------------------------------------------------------------------------
// 4. 再帰関数と補題: リストの合計
// ---------------------------------------------------------------------------
function Sum(s: seq<int>): int
{
  if |s| == 0 then 0 else s[0] + Sum(s[1..])
}

lemma SumAppend(s: seq<int>, t: seq<int>)
  ensures Sum(s + t) == Sum(s) + Sum(t)
{
  // TODO: |s| についての帰納法。
  // ヒント: |s| == 0 のときは `assert s + t == t;` が要る。
  //         そうでなければ `SumAppend(s[1..], t);` を呼び、
  //         `assert (s + t)[1..] == s[1..] + t;` で橋渡しする。
}
