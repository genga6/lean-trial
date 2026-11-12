/-!
S093-1 の c1（arXiv:2211.09817 §5.1）
原文: "Then, we find that most of them are layer normalization layers
       (the list of the layer names are put in Appendix D.3)."
補完後の文: 閾値を上回った層のうち、layer normalization 層の割合が p 以上である。

データ: 論文の付録 D.3 の一覧を転記した。
出典: github.com/t46/paper-pre-training-different-modality-offline-rl
      main.tex、commit 7ee06ab8aeb307829ca01cdb952bd355d5917ad6
Mathlib は使わない（Lean 4 の core だけ）。
-/
namespace S093_1

/-- Transformer block の中の module の種類。付録 D.3 に出てくる 6 種類。 -/
inductive Module where
  | ln_1 | attn_c_attn | ln_2 | mlp_c_fc | mlp_c_proj | mlp_dropout
  deriving DecidableEq, Repr

/-- 層 = (block の番号, module)。"3.ln_2" は ⟨3, .ln_2⟩。 -/
structure Layer where
  block : Nat
  module : Module
  deriving DecidableEq, Repr

open Module in
/-- 「その」= 閾値を上回った層の集合。付録 D.3 の一覧（34 件）を、行の順のまま転記。 -/
def aboveThreshold : List Layer := [
  ⟨0, ln_1⟩, ⟨0, attn_c_attn⟩, ⟨0, ln_2⟩, ⟨0, mlp_c_fc⟩, ⟨0, mlp_c_proj⟩, ⟨0, mlp_dropout⟩,
  ⟨1, ln_1⟩, ⟨1, attn_c_attn⟩, ⟨1, ln_2⟩,
  ⟨2, ln_1⟩, ⟨2, ln_2⟩,
  ⟨3, ln_1⟩, ⟨3, ln_2⟩, ⟨3, mlp_c_fc⟩,
  ⟨4, ln_1⟩, ⟨4, attn_c_attn⟩, ⟨4, ln_2⟩,
  ⟨5, ln_1⟩, ⟨5, attn_c_attn⟩, ⟨5, ln_2⟩,
  ⟨6, ln_1⟩, ⟨6, attn_c_attn⟩, ⟨6, ln_2⟩,
  ⟨7, ln_1⟩, ⟨7, ln_2⟩,
  ⟨8, ln_1⟩, ⟨8, ln_2⟩,
  ⟨9, ln_1⟩, ⟨9, ln_2⟩,
  ⟨10, ln_1⟩, ⟨10, attn_c_attn⟩, ⟨10, ln_2⟩,
  ⟨11, ln_1⟩, ⟨11, ln_2⟩]

/-- 「layer normalization 層」= module が ln_1 か ln_2。 -/
def isLayerNorm (l : Layer) : Bool :=
  l.module == .ln_1 || l.module == .ln_2

/-- layer normalization 層の数。 -/
def layerNormCount : Nat := (aboveThreshold.filter isLayerNorm).length

/-- c1: 「大部分」= 割合が p = num / den 以上。割り算を避けて掛け算で書く。 -/
def c1 (num den : Nat) : Prop :=
  num * aboveThreshold.length ≤ den * layerNormCount

/-- 一覧は 34 件。 -/
theorem total_eq : aboveThreshold.length = 34 := by decide

/-- そのうち layer normalization 層は 24 件（付録 D.3 の "24 of 34" と一致）。 -/
theorem layerNorm_eq : layerNormCount = 24 := by decide

/-- c1 は、p ≤ 24/34 のとき、そのときに限り成り立つ。 -/
theorem c1_iff (num den : Nat) : c1 num den ↔ num * 34 ≤ den * 24 := by
  unfold c1
  rw [total_eq, layerNorm_eq]

/-- p = 1/2（過半数）なら成り立つ。 -/
theorem c1_half : c1 1 2 := (c1_iff 1 2).mpr (by decide)

/-- p = 2/3 でも成り立つ。 -/
theorem c1_two_thirds : c1 2 3 := (c1_iff 2 3).mpr (by decide)

/-- p = 3/4 では成り立たない。 -/
theorem not_c1_three_quarters : ¬ c1 3 4 :=
  fun h => absurd ((c1_iff 3 4).mp h) (by decide)

/-- p = 4/5（80%）でも成り立たない。 -/
theorem not_c1_four_fifths : ¬ c1 4 5 :=
  fun h => absurd ((c1_iff 4 5).mp h) (by decide)

end S093_1

#print axioms S093_1.total_eq
#print axioms S093_1.layerNorm_eq
#print axioms S093_1.c1_iff
#print axioms S093_1.c1_half
#print axioms S093_1.c1_two_thirds
#print axioms S093_1.not_c1_three_quarters
#print axioms S093_1.not_c1_four_fifths
