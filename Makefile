# elan and Dafny are installed under $HOME by .devcontainer/post-create.sh;
# make does not read ~/.bashrc, so put them on PATH here too.
export PATH := $(HOME)/.elan/bin:$(HOME)/.local/bin:$(PATH)

LEAN_DIR := lean
DAFNY    := dafny

.PHONY: help setup lean lean-cache lean-clean dafny dafny-run dafny-exercises clean

help:
	@echo "make setup            - ツールチェーンを入れ直す (.devcontainer/post-create.sh)"
	@echo "make lean             - Lean プロジェクトをビルド"
	@echo "make lean-cache       - Mathlib のビルド済み olean を取得"
	@echo "make dafny            - dafny/Intro.dfy を検証"
	@echo "make dafny-run        - dafny/Intro.dfy を実行"
	@echo "make dafny-exercises  - dafny/Exercises.dfy を検証 (埋めるまで失敗します)"
	@echo "make clean            - ビルド成果物を削除"

setup:
	bash .devcontainer/post-create.sh

lean:
	cd $(LEAN_DIR) && lake build

lean-cache:
	cd $(LEAN_DIR) && lake exe cache get

# `lake clean` with no argument would also wipe Mathlib's oleans (~7.5 GB).
lean-clean:
	cd $(LEAN_DIR) && lake clean playground

dafny:
	$(DAFNY) verify dafny/Intro.dfy

dafny-run:
	$(DAFNY) run dafny/Intro.dfy

dafny-exercises:
	$(DAFNY) verify dafny/Exercises.dfy

clean:
	rm -rf dafny/obj dafny/Intro dafny/Intro.cs dafny/Intro.csproj \
	       dafny/Intro.dll dafny/Intro.pdb dafny/Intro.deps.json \
	       dafny/Intro.runtimeconfig.json
	cd $(LEAN_DIR) && lake clean playground
