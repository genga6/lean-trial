/-! Lean 4 smoke test: a definition plus a few theorems checked by the kernel.
    Uses only core Lean tactics (no Mathlib). -/

def hello := "world"

/-- Sum of the first `n` natural numbers. -/
def sumTo : Nat → Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo n

/-- Gauss: `2 * (1 + 2 + ... + n) = n * (n + 1)`. -/
theorem sumTo_formula (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  induction n with
  | zero => rfl
  | succ k ih =>
    simp only [sumTo]
    rw [Nat.mul_add, ih]
    simp only [Nat.succ_mul, Nat.mul_succ]
    omega

theorem add_comm_example (a b : Nat) : a + b = b + a := Nat.add_comm a b

example : sumTo 10 = 55 := by decide
