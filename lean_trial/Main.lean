import LeanTrial

/-! 超簡単な証明の例。`lake build` の時点で証明がチェックされ、
    間違っていればコンパイルエラーになる。 -/

-- 1. 計算で確かめる: `rfl` は「両辺を計算したら同じ」
theorem two_plus_two : 2 + 2 = 4 := rfl

-- 2. 既存の定理を使う: 足し算の交換法則
theorem my_add_comm (a b : Nat) : a + b = b + a := Nat.add_comm a b

-- 3. タクティクで証明する: `by` の後に証明の手順を書く
theorem and_swap (p q : Prop) (h : p ∧ q) : q ∧ p := by
  constructor        -- ゴール `q ∧ p` を `q` と `p` の2つに分ける
  · exact h.right    -- `q` は h の右側
  · exact h.left     -- `p` は h の左側

-- 4. 関数を定義して、その性質を証明する
def double (n : Nat) : Nat := n + n

theorem double_eq (n : Nat) : double n = 2 * n := by
  unfold double      -- double を定義に展開: n + n = 2 * n
  omega              -- 整数の線形算術を自動で解く

def main : IO Unit := do
  IO.println s!"Hello, {hello}!"
  IO.println s!"double 21 = {double 21}"
  IO.println "上の定理はすべてコンパイル時に証明済みです ✔"
