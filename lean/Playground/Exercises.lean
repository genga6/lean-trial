/-
練習問題。`sorry` を消して証明を埋めてください。
`sorry` が残っている間は警告が出ますが、ビルドは通ります。
-/
import Mathlib.Tactic.Ring
import Mathlib.Algebra.Ring.Parity

namespace Playground.Exercises

/-- 1. 自然数の足し算の結合則。ヒント: `omega` -/
theorem add_assoc' (a b c : Nat) : a + b + c = a + (b + c) := by
  sorry

/-- 2. リストの長さは reverse で変わらない。ヒント: `simp` -/
theorem length_reverse' (xs : List Nat) : xs.reverse.length = xs.length := by
  sorry

/-- 3. 偶数の和は偶数。
    ヒント: `obtain ⟨a, rfl⟩ := hm` で `Even` の定義 `∃ r, m = r + r` をほどき、
    最後は `exact ⟨a + b, by ring⟩`。 -/
theorem even_add' (m n : Nat) (hm : Even m) (hn : Even n) : Even (m + n) := by
  sorry

/-- 4. 独自の再帰関数と、その性質。
    ヒント: `induction xs with | nil => .. | cons x xs ih => ..` -/
def sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs

theorem sum_append (xs ys : List Nat) : sum (xs ++ ys) = sum xs + sum ys := by
  sorry

/-- 5. 4 を使う問題。合計は reverse で変わらない。
    ヒント: `simp [sum, sum_append]` と `omega` の組み合わせ。 -/
theorem sum_reverse (xs : List Nat) : sum xs.reverse = sum xs := by
  sorry

end Playground.Exercises
