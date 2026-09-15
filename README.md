# lean-dafny-trial

Lean 4 と Dafny を試すための Codespace です。

## 入っているもの

| ツール | バージョン | 場所 |
|---|---|---|
| elan (Lean toolchain manager) | 4.2.4 | `~/.elan/bin/elan` |
| Lean 4 / Lake | 4.34.0 (stable) / 5.0.0 | `~/.elan/bin/{lean,lake}` |
| Dafny (Z3, .NET 8 ランタイム同梱) | 4.11.0 | `~/.local/opt/dafny/dafny` → `~/.local/bin/dafny` |
| VS Code 拡張 | `leanprover.lean4`, `dafny-lang.ide-vscode` | devcontainer.json で自動インストール |

セットアップは `.devcontainer/post-create.sh` で再現できます（Codespace の Rebuild 時に自動実行、手動実行も可）。

## 使い方

### Lean 4

```bash
cd lean_trial
lake build            # ライブラリと実行ファイルをビルド（定理も検証される）
lake exe lean_trial   # Hello, world!
```

`lean_trial/LeanTrial/Basic.lean` に定理のサンプルがあります。
VS Code で `.lean` ファイルを開くと Lean Infoview にゴールが表示されます。

新しいプロジェクトを作る場合:

```bash
lake new MyProject                                            # 素の Lean
lake +leanprover-community/mathlib4:lean-toolchain new MyMath math   # Mathlib 付き
```

### Dafny

```bash
cd dafny_trial
dafny verify Hello.dfy   # 検証のみ
dafny run Hello.dfy      # 検証してから実行
```

VS Code で `.dfy` ファイルを開くと自動で検証され、エラーがインラインに出ます。

## 参考

- Lean install: https://lean-lang.org/install/manual/
- Dafny install: https://dafny.org/latest/Installation
- Dafny releases: https://github.com/dafny-lang/dafny/releases
