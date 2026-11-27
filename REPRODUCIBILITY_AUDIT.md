# Reproducibility audit for the v0.3 revision draft

## Evidence and scope

The proof baseline is commit `5e788f90d91cf7cd0f8a50bfad6f1db6ffc55db2`. The [baseline verifier](research/audit/proof_baseline.py) derives SHA-256 digests and the protected manuscript excerpts directly from that Git object, then compares the current files. The source, certificates, and historical logs from v0.2 have their original bytes. See the [revision audit](REVISION_AUDIT.md) for final statuses and the [run record](research/audit/logs/v03-local/run.json) for the detached source commit, environment, executed commands, statuses and individual exit codes.

| Reproduction area | Verification route |
| --- | --- |
| Array arithmetic | Original verifier plus a separate exact-integer strength-18 calculation with all 19 residuals and stored small witnesses |
| Packing colorings | Original transfer and vertex searches, two explicit-edge BFS checks, and a separate verification of the weighted path certificate and cycle equality case |
| Negative controls | Temporary modifications in each data type, with rejection required. A graph positive control replaces the SAT assignment and node-count metadata. |
| Lean | Two clean Lake builds on the official 4.19.0 distribution and a separate temporary importing file for the five transitive axiom sets |
| Manuscripts | GFM data and link checks, original LaTeX build, Chinese XeLaTeX build, extraction comparison with the archived PDFs, and recorded visual inspection |
| Release integrity | SHA-256 manifest excluding itself and temporary files. The protected-baseline JSON records different hashes tied to the original Git object. |

Expected transitive axioms and the compiler-backed LRAT verification are documented in the [trust model](research/TRUST_MODEL.md). The written proofs can be followed using the formulas and numerical tables printed in the articles. The graph lower bounds in the manuscripts use a distinct integer argument; the original transfer checks and Lean proofs remain independently reproducible. There is no archived standalone LRAT/CNF file.

The old [array verification log](excess-arrays/verification.log) and [graph verification log](packing-corona/verification.log) record the v0.2 verification. The v0.3 local results and the hosted workflow runs can be inspected separately. [Local verification logs](research/audit/logs/v03-local) · [GitHub Actions](https://github.com/PixieElysia/excess-coverage-arrays-and-corona-packing-colorings/actions/workflows/verification.yml?query=branch%3Aresearch%2Fbilingual-v0.3)

## Clean run

Use a Git checkout containing the baseline commit, Python 3.10 or later, Lean and Lake 4.19.0, latexmk, pdfLaTeX, XeLaTeX, Pandoc, Poppler and the Noto Serif CJK SC and Noto Sans Mono CJK SC fonts. On Linux x86-64, the [Lean installer](research/audit/install_lean.sh) downloads the official release archive and verifies the pinned digest. Pass a path to the pinned executables if they are outside PATH.

```sh
python3 -B research/audit/run_revision.py --revision HEAD \
  --lean-bin /path/to/lean-4.19.0/bin --logs /tmp/revision-audit
```

The log directory must be empty. The runner creates a fresh detached worktree and persists results after each check. It records exit codes and stops on a failed command. The worktree and partial logs remain available for diagnosis. Direct `lake build` commands run before either original driver, so any later reuse by `verify.sh` follows a documented clean build.

Use `git clone --branch research/bilingual-v0.3 https://github.com/PixieElysia/excess-coverage-arrays-and-corona-packing-colorings.git` to obtain the published files and the baseline history needed by the verifier.

To rebuild the four PDFs locally, use the two commands below for each project. Supply a destination outside the tracked source.

```sh
bash research/audit/build_paper.sh excess-arrays /tmp/arrays-en
bash research/audit/build_chinese_paper.sh excess-arrays /tmp/arrays-zh
bash research/audit/build_paper.sh packing-corona /tmp/graphs-en
bash research/audit/build_chinese_paper.sh packing-corona /tmp/graphs-zh
```

Current binaries are fingerprinted in [SHA256SUMS](SHA256SUMS). The revision checks extracted PDF text against a local recompilation. Time metadata, PDF engine and fonts can change PDF bytes in other environments. The Chinese source for rebuilding is the corresponding Markdown file and the small Pandoc layout filter.
