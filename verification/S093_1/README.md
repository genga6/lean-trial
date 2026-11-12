# S093-1 の検証

arXiv:2211.09817 §5.1 の文「Then, we find that most of them are layer normalization layers
(the list of the layer names are put in Appendix D.3).」の主張を、Lean で確かめる。

- 命題と証明: [`lean_trial/LeanTrial/S093_1.lean`](../../lean_trial/LeanTrial/S093_1.lean)
- 転記の照合: [`check_transcription.py`](check_transcription.py)。Lean に書いた層の一覧が、論文の LaTeX ソースの付録 D.3 の一覧と一致するかを確かめる
- CI: [`.github/workflows/s093_1.yml`](../../.github/workflows/s093_1.yml)。ビルド、依存する公理の出力、転記の照合を行い、出力を artifact に残す

## 手元で動かす

```bash
cd lean_trial
lake build
lake env lean LeanTrial/S093_1.lean   # 各定理が依存する公理を出力する
cd ..
curl -sSfL https://raw.githubusercontent.com/t46/paper-pre-training-different-modality-offline-rl/7ee06ab8aeb307829ca01cdb952bd355d5917ad6/main.tex -o main.tex
python3 verification/S093_1/check_transcription.py main.tex lean_trial/LeanTrial/S093_1.lean
```
