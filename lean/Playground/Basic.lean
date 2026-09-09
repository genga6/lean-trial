/-
Lean 4 + Mathlib 入門ツアー。
VS Code で開くと、カーソル位置のゴールが Lean Infoview に表示されます。

import は必要なものだけを名指ししています。`import Mathlib` や
`import Mathlib.Tactic` はメモリを数 GB 使うので、2 core / 8 GB の
Codespace では読み込みきれません（README の「メモリについて」参照）。
-/
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum.Prime
import Mathlib.Data.Nat.Prime.Infinite
import Mathlib.Algebra.Order.Ring.Int
import Mathlib.Algebra.Group.Nat.Even

namespace Playground

/-! ## 1. 定義と `rfl`

計算で閉じる等式は `rfl`（両辺が定義上同じ）で証明できます。 -/

def double (n : Nat) : Nat := 2 * n

example : double 3 = 6 := rfl

/-! ## 2. 命題論理

`⟨_, _⟩` は構造体のコンストラクタ（ここでは And）。 -/

example (p q : Prop) (hp : p) (hq : q) : p ∧ q := ⟨hp, hq⟩

theorem and_comm' (p q : Prop) : p ∧ q ↔ q ∧ p := by
  constructor <;> rintro ⟨h₁, h₂⟩ <;> exact ⟨h₂, h₁⟩

/-! ## 3. 帰納法

再帰関数には `induction` を使い、再帰の各節に対応するケースを埋めます。 -/

def sumTo : Nat → Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo n

/-- ガウスの和。分数を避けるため両辺を 2 倍した形で述べています。 -/
theorem sumTo_closed (n : Nat) : sumTo n * 2 = n * (n + 1) := by
  induction n with
  | zero => rfl
  | succ k ih =>
    rw [sumTo, add_mul, ih]
    ring

/-! ## 4. 自動化タクティク

- `omega`   : 線形の整数・自然数算術
- `simp`    : 単純化補題による書き換え
- `ring`    : 可換環の等式
- `norm_num`: 数値の計算・判定 -/

example (a b : Nat) (h : a + 2 ≤ b) : a < b := by omega

example (xs ys : List Nat) : (xs ++ ys).length = xs.length + ys.length := by
  simp

example (x y : ℤ) : (x + y) ^ 2 = x ^ 2 + 2 * x * y + y ^ 2 := by ring

example : Nat.Prime 97 := by norm_num

/-! ## 5. Mathlib を使う

証明したい補題はたいてい既にあります。`exact?` で探せます。 -/

example (x : ℤ) : 0 ≤ x ^ 2 := sq_nonneg x

example (n : ℕ) : Even (n * (n + 1)) := Nat.even_mul_succ_self n

/-- 素数は無限にある（Mathlib の定理をそのまま使う）。 -/
example (n : ℕ) : ∃ p, n ≤ p ∧ Nat.Prime p := Nat.exists_infinite_primes n

/-! ## 6. 仕様つきの関数

Dafny の `ensures` に相当するものは、Lean では戻り値の型に埋め込むか、
別の定理として述べます。 -/

def maxOf (a b : Nat) : Nat := if a ≤ b then b else a

theorem le_maxOf_left (a b : Nat) : a ≤ maxOf a b := by
  unfold maxOf; split <;> omega

theorem le_maxOf_right (a b : Nat) : b ≤ maxOf a b := by
  unfold maxOf; split <;> omega

theorem maxOf_eq (a b : Nat) : maxOf a b = a ∨ maxOf a b = b := by
  unfold maxOf; split <;> simp

end Playground
