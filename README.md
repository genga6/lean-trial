# lean-dafny-trial

Lean 4 (+ Mathlib) と Dafny を触って比べるための練習用リポジトリ。
両方とも「証明で正しさを保証する」道具ですが、方向が違います。

|  | Lean 4 | Dafny |
|---|---|---|
| 主な用途 | 数学の定理証明 / 依存型プログラミング | 命令型プログラムの自動検証 |
| 証明の書き方 | 人がタクティクで組み立てる | SMT ソルバ (Z3) が自動で埋める |
| 仕様の置き場所 | 型と定理 | `requires` / `ensures` / `invariant` |
| 失敗の見え方 | ゴールが残る | 「この post-condition が示せない」 |

## セットアップ

VS Code / GitHub Codespaces で **Reopen in Container** するだけです。
`.devcontainer/post-create.sh` が elan・Lean ツールチェーン・Mathlib のビルド済み
olean・Dafny を入れます（初回は Mathlib のダウンロードで数分かかります）。

手元でやり直したいときは:

```bash
make setup
```

`INSTALL_MATHLIB=false` を `.devcontainer/devcontainer.json` の `containerEnv` に
設定すると Mathlib（約 6 GB）をスキップして軽いコンテナになります。

## 使い方

```bash
make lean             # Lean プロジェクトをビルド
make dafny            # dafny/Intro.dfy を検証
make dafny-run        # dafny/Intro.dfy を実行
make dafny-exercises  # 練習問題を検証（埋めるまで失敗します）
make help             # 全ターゲット
```

VS Code では拡張機能（`leanprover.lean4`, `dafny-lang.ide-vscode`）が自動で入るので、
ふつうはファイルを開いてカーソルを動かすだけです。

- Lean: 右側の **Lean Infoview** に現在のゴールが出ます。
- Dafny: 保存時に検証が走り、通らない `ensures` に赤線が引かれます。

## 中身

```
lean/
  lean-toolchain          Lean のバージョン固定 (v4.33.1)
  lakefile.toml           Mathlib への依存
  Playground/Basic.lean       入門ツアー（rfl・帰納法・omega・ring・Mathlib）
  Playground/Exercises.lean   練習問題（`sorry` を埋める）
dafny/
  Intro.dfy               入門ツアー（ensures・invariant・lemma・class）
  Exercises.dfy           練習問題（本体と invariant を埋める）
```

## メモリについて

Mathlib は巨大なので、`import Mathlib` や `import Mathlib.Tactic` を書くと
読み込みだけで数 GB のメモリを使います。2 core / 8 GB の Codespace（既定サイズ）
では読み込みきれずにプロセスが落ちるため、このリポジトリのサンプルは
**必要なモジュールだけを名指しで import** しています。

```lean
import Mathlib.Tactic.Ring          -- ring タクティクだけ
import Mathlib.Data.Nat.Prime.Basic -- 素数まわりだけ
```

使いたい補題がどのモジュールにあるかは `exact?` の出力か、
[Mathlib のドキュメント](https://leanprover-community.github.io/mathlib4_docs/)で
調べられます。`import Mathlib` をそのまま使いたい場合は、Codespace を
4 core / 16 GB 以上に上げてください。

## 詰まったら

- Lean: `exact?` で補題を検索、`apply?` で候補を出す、`#check` で型を見る。
  [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/) /
  [Theorem Proving in Lean 4](https://leanprover.github.io/theorem_proving_in_lean4/)
- Dafny: 失敗したら `assert` を刻んでどこで示せなくなるか二分探索する。
  [Dafny Reference Manual](https://dafny.org/latest/DafnyRef/DafnyRef) /
  [Dafny Tutorial](https://dafny.org/latest/OnlineTutorial/guide)
