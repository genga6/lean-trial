"""Lean に転記した層の一覧が、論文の LaTeX ソース（付録 D.3）の一覧と一致するかを確かめる。"""
import re, sys
tex, lean = open(sys.argv[1]).read(), open(sys.argv[2]).read()
listing = re.search(r"caption=Layer names whose CKA is above a threshold\]\n(.*?)\\end\{lstlisting\}", tex, re.S).group(1)
from_paper = [n.rstrip(".") for n in re.split(r"[,\s]+", listing.strip()) if n.rstrip(".")]  # "11.ln_1." の末尾の . は誤記として落とす
body = re.search(r"def aboveThreshold : List Layer := \[(.*?)\]", lean, re.S).group(1)
from_lean = [f"{b}.{m.replace('attn_c', 'attn.c').replace('mlp_', 'mlp.')}" for b, m in re.findall(r"⟨(\d+), (\w+)⟩", body)]
print("paper:", len(from_paper), "lean:", len(from_lean), "identical:", from_paper == from_lean)
sys.exit(0 if from_paper == from_lean else 1)
