# Revision audit

**v0.3 revision draft · 27 November 2026 · Asia/Shanghai**

## Baseline

- Commit: `5e788f90d91cf7cd0f8a50bfad6f1db6ffc55db2`. The GitHub branch `research/bilingual-v0.3` descends directly from this public baseline.
- Proof files unchanged: **PASS**. The baseline check compared 35 protected files byte for byte, including both Lean projects' existing source and configuration, the original algorithms, verification drivers and historical computation records. It also checked 105 original manuscript units against the base commit, including the original English theorem statements and proof text. [Baseline protection](research/PROOF_BASELINE.md) · [Baseline log](research/audit/logs/v03-local/proof-baseline.log)
- Certificate files unchanged: **PASS**. The witness JSON files and the original graph certificate representations are covered by the baseline. The generated residuals, graph assignments and weights are separate data. [Protected hashes](research/proof-baseline.json) · [Certificate data dictionary](research/audit/CERTIFICATE_DATA.md)
- The clean run used the source commit identified in the run record. A following commit archives the outputs. The source commit contains the same manuscripts, computational inputs, Lean sources and workflow as the published snapshot. [Run record](research/audit/logs/v03-local/run.json)
- The original revision plan was followed and archived with the working revision. Its SHA-256 is `361c0b69d02aa3863d440e68ee76f2e95146034e8e8070f4fdd1af27fb8c18f0`.

## Manuscript revisions

| File | Change | Mathematical claim unchanged? | Evidence |
| --- | --- | --- | --- |
| `excess-arrays/paper.md`, `paper.tex`, `paper.pdf` | Clarified the three contributions, the sequence-covering parameter shift, the published computational report, notation and scope. Added the complete small-strength witness table, finite rounding arithmetic, the exact strength-18 check and a guide to the written width proof. Rebuilt the PDF. | Yes | [English array paper](excess-arrays/paper.md) · [PDF](excess-arrays/paper.pdf) |
| `excess-arrays/paper.zh-CN.md`, `paper.zh-CN.pdf` | Added a complete Chinese edition. It includes the row lower bound, the construction and finite cases, the kernel and width arguments, and all witness data used in the proof. | Yes | [中文阵列论文](excess-arrays/paper.zh-CN.md) · [PDF](excess-arrays/paper.zh-CN.pdf) |
| `packing-corona/paper.md`, `paper.tex`, `paper.pdf` | Distinguished earlier bounds from the exact classification, clarified the graph model, `b_j` and the two finite verification routes. Added complete written lower-bound arguments using weights and parity, with the existing transfer proof and five construction words preserved. Rebuilt the PDF. | Yes | [English graph paper](packing-corona/paper.md) · [PDF](packing-corona/paper.pdf) |
| `packing-corona/paper.zh-CN.md`, `paper.zh-CN.pdf` | Added a complete Chinese edition with the weighted path bound, the cycle parity contradiction, the transfer lemmas, all five return words, the residue construction and the attributed eight-color witness. | Yes | [中文图论论文](packing-corona/paper.zh-CN.md) · [PDF](packing-corona/paper.zh-CN.pdf) |
| Both projects' `README.md` and `PRIOR_ART.md` | Mapped each mathematical claim to its original question, precise parameters, mathematical evidence and verified limits. | Yes | [Array project](excess-arrays/README.md) · [Graph project](packing-corona/README.md) · [Claims matrix](research/CLAIMS_MATRIX.md) |
| Both projects' `FORMALIZATION.md`, `THEOREM_COVERAGE.md` and `lean/README.md` | Recorded model semantics, import paths, the exact five declaration types, verification commands and the boundary of each formalization. | Yes | [Array model](excess-arrays/FORMALIZATION.md) · [Array coverage](excess-arrays/THEOREM_COVERAGE.md) · [Graph model](packing-corona/FORMALIZATION.md) · [Graph coverage](packing-corona/THEOREM_COVERAGE.md) |

The graph proof of the path lower bound uses four printed weight vectors and a two-row recurrence for each color. The six strict sums are sufficient to refute all choices for the fixed center color. At cycle order 13, the class weights must all meet their upper bounds. Color 4 would then require three consecutive gaps of incompatible parity all crossing one edge. These deductions and the explicit upper-bound words give the complete classification from the manuscript. For the arrays, finite integer tables and the two general arguments supply all the data and deductions. Lean and the separate computations provide additional verification. [Written-proof review notes](research/MATHEMATICAL_REVIEW.md)

### Repository changes and rationale

The [path-by-path inventory](research/audit/changed-files.txt) lists changes relative to the protected commit. The working revision archive retains the plan, internal checkpoint notes, editorial drafts and superseded diagnostics. The published files include the complete manuscripts and the evidence needed to review the conclusions.

| Scope | Files and reason |
| --- | --- |
| Entry points and version | `README.md` presents both results and their coverage boundaries. `REPRODUCIBILITY_AUDIT.md` records repeatable commands and the logged run. `CHANGELOG.md` records the v0.3 draft changes. |
| Scholarship | `research/ARRAY_LITERATURE.md`, `GRAPH_LITERATURE.md`, `LITERATURE_MATRIX.md` and `SOURCES.md` record priority checks, exact source versions and gaps in access. `research/CLAIMS_MATRIX.md` maps claims to evidence. `research/MATHEMATICAL_REVIEW.md` records the written proof checks. |
| Accountability | `CONTRIBUTIONS.md` records actual contributions, the meaning of the display byline and open author-confirmation items. |
| Reader documentation | `research/OVERVIEW.zh-CN.md` links the full Chinese editions and verification records. `research/VERIFICATION.md` clarifies the transfer-state count. `research/TRUST_MODEL.md` separates the five axiom sets and the SAT/LRAT checking stages. |
| Proof protection | `research/PROOF_BASELINE.md`, `research/proof-baseline.json` and `research/audit/proof_baseline.py` tie file bytes and preserved manuscript units to the exact baseline Git object. |
| Reproduction | `research/audit/verify_t18.py`, `verify_graph_semantics.py`, `verify_written_obstructions.py`, `test_negative_controls.py` and `audit_lean.py` add verification alongside the original tools. `CERTIFICATE_DATA.md`, `array-witness.schema.json` and the three files under `research/audit/outputs/` specify new data and how to reproduce it. |
| Builds and CI | `.github/workflows/verification.yml` configures independent checks, clean builds and log uploads. `research/audit/install_lean.sh` pins the official Lean distribution. `run_revision.py` records commands in a detached checkout. `build_paper.sh`, `build_chinese_paper.sh`, `cjk_tables.lua` and `check_manuscripts.py` build and check the four editions. |
| Evidence and persistence | `research/audit/logs/` preserves the current run and supporting diagnostics. `SHA256SUMS` fingerprints the distribution. `REVISION_AUDIT.md` and its inventory record delivery status. |

## Formalization and reproduction

The clean local run used Linux x86-64, Debian 13.7, Python 3.12.14, Lean 4.19.0 commit `6caaee842e94`, Lake `5.0.0-6caaee8`, CaDiCaL 2.1.3, Latexmk 4.86, XeTeX from TeX Live 2025/dev, Pandoc 3.1.11.1 and Poppler 25.03.0. The actual commands, working directories, exit codes and Shanghai timestamps are in the [machine-readable run record](research/audit/logs/v03-local/run.json). Both Lake builds started before the original verification drivers could reuse any artifacts. [Detached checkout](research/audit/logs/v03-local/checkout.log) · [Environment](research/audit/logs/v03-local/environment.log)

| Check | Environment / command | Status | Log / evidence |
| --- | --- | --- | --- |
| Environment | `uname -sm` and installed tool versions | PASS | [Environment](research/audit/logs/v03-local/environment.log) |
| Original proof and certificate protection | `python3 -B research/audit/proof_baseline.py` | PASS | [Proof baseline](research/audit/logs/v03-local/proof-baseline.log) |
| Source snapshot distribution hashes | `sha256sum -c SHA256SUMS` | PASS | [Distribution hashes](research/audit/logs/v03-local/distribution-hashes.log) |
| Strength-18 independent arithmetic | `python3 -B research/audit/verify_t18.py --check` | PASS | [Certificate](research/audit/logs/v03-local/array-certificate.log) · [19 zero residuals](research/audit/outputs/t18-residuals.csv) |
| Graph instances and distances | `python3 -B research/audit/verify_graph_semantics.py --check` | PASS | [Graph results](research/audit/logs/v03-local/graph-certificates.log) |
| Written graph lower-bound arithmetic | `python3 -B research/audit/verify_written_obstructions.py` | PASS | [Six path inequalities and cycle equality case](research/audit/logs/v03-local/written-obstruction-arithmetic.log) |
| Temporary certificate distortions and graph positive control | `python3 -B research/audit/test_negative_controls.py` | PASS | [Control outcomes](research/audit/logs/v03-local/negative-controls.log) |
| Archived result reproduction | `python3 -B research/collect_results.py --check` | PASS | [Result tables](research/audit/logs/v03-local/result-tables.log) |
| Clean array Lean project | `lake build` in `excess-arrays/lean` | PASS | [Array build](research/audit/logs/v03-local/lean-excess-arrays.log) |
| Clean graph Lean project | `lake build` in `packing-corona/lean` | PASS | [Graph build](research/audit/logs/v03-local/lean-packing-corona.log) |
| Original array driver | `bash verify.sh arrays` | PASS | [Original array driver](research/audit/logs/v03-local/original-arrays.log) |
| Original graph driver | `bash verify.sh graphs` | PASS | [Original graph driver](research/audit/logs/v03-local/original-graphs.log) |
| Transitive Lean axioms for five conclusions | `python3 -B research/audit/audit_lean.py --root .` | PASS | [Types and dependencies](research/audit/logs/v03-local/axiom-audit.log) |
| English PDF builds | `bash research/audit/build_paper.sh PROJECT OUTPUT`, both projects | PASS | [Array LaTeX](research/audit/logs/v03-local/latex-excess-arrays.log) · [Graph LaTeX](research/audit/logs/v03-local/latex-packing-corona.log) |
| Chinese PDF builds | `bash research/audit/build_chinese_paper.sh PROJECT OUTPUT`, both projects | PASS | [Array XeLaTeX](research/audit/logs/v03-local/latex-zh-excess-arrays.log) · [Graph XeLaTeX](research/audit/logs/v03-local/latex-zh-packing-corona.log) |
| Markdown mathematics, links, certificate data, PDF metadata and rebuilt text | `python3 -B research/audit/check_manuscripts.py --rebuilt OUTPUT` | PASS | [Manuscript checks](research/audit/logs/v03-local/manuscript-data-and-renders.log) |
| Final PDF page layout | Rasterized and inspected the 32 pages in contact sheets. Verified the page bounds of each extracted word box with `pdftotext -bbox-layout`. | PASS | [Layout log](research/audit/logs/diagnostics/pdf-layout.log) |
| Workflow syntax and pinned installer | `actionlint 1.7.7` and a fresh invocation of `install_lean.sh` | PASS | [Workflow lint](research/audit/logs/diagnostics/actionlint.log) · [Installer run](research/audit/logs/diagnostics/lean-installer.log) |
| GitHub Actions hosted execution | GitHub-hosted Ubuntu 24.04 runners | See run status | [GitHub Actions](https://github.com/PixieElysia/excess-coverage-arrays-and-corona-packing-colorings/actions/workflows/verification.yml?query=branch%3Aresearch%2Fbilingual-v0.3) |

The strength-18 calculation confirms all 37 multiplicities are positive, with minimum 350,847 and layer-weighted total 121,645,100,408,832,000. The finite graph search gives UNSAT at $(P_{12},6)$ and $(C_{13},7)$, and SAT at $(P_{11},6)$ and $(C_{13},8)$. Explicit-edge BFS verifies the SAT assignments, the published witness and all 25 ordered pairs of return words. The exact graph formalisations depend transitively on `Lean.ofReduceBool`. This includes the compiled evaluation supporting LRAT checking in Lean 4.19.0. The repository records no exported standalone LRAT or CNF file. [Trust model](research/TRUST_MODEL.md)

The initial Chinese preamble and wrapping failures were fixed before the fresh builds and page inspection. The coordinate check filters control characters in Poppler's extracted XML. Supporting diagnostic outputs are available with the verified PDFs. [Diagnostic logs](research/audit/logs/diagnostics)

## Literature and attribution

| Source | Full text checked? | Relevant statement | Novelty impact |
| --- | --- | --- | --- |
| Gentle–Horsley–Wanless journal and arXiv v1 | Yes, both versions | Journal Construction 4, Lemmas 5 and 14, Section 5 equation (3). Preprint Construction 3, Lemmas 4 and 12, Section 5 equation (3). | Corrects the precise reported strength-18 computation. The paper's strength-seven SCA main result retains its original scope. |
| Chee–Colbourn–Horsley–Zhou | Yes, published copy hosted by an author | Theorems 2.1 and 2.3, pp. 1847–1849 | Attributes the excess-array projection and the antecedent order bound. |
| Longyear (1984), Shirakura (1977), Kuriki (1993) | No. Publisher abstracts for Longyear and Kuriki and bibliographic metadata for Shirakura | Balanced-array existence or construction criteria and the simple-array model | **UNKNOWN** whether the general conditions imply any of the exact factorial specializations or the width result. |
| Mathon–Tran van Trung | No. Publisher abstract and corroborating 2025 introduction | Existence of a directed Steiner system $T(4,6,6)$ | Attributes the strength-four counterexample to the original version of Levenshtein's conjecture. |
| Sampathkumar–Sivakaran–Unnikrishnan | Yes, publisher PDF | Theorems 2.1 and 3.1, and Section 4 on printed p. 107 | Retains attribution of previous bounds, small values and the eight-color construction. The added lower bounds and common-state constructions give the larger-order exact values. |
| Laïche–Bouchemakh–Sopena | Yes, published PDF | Definition and bounds for independent leaves in the $p$-corona | Distinct attachment graph and related background. |
| Furmańczyk–Gözüpek–Özkan | Yes, arXiv v1 | Section 3.2 and Question 2 of Section 3.2.1 | The one-backbone-vertex question concerns a broader family. The results here give exact values for the specified three-vertex columns with path and cycle backbones. |

Exact source links and parameters are in the [literature matrix](research/LITERATURE_MATRIX.md). The [access log](research/audit/logs/diagnostics/literature-access.log) records the attempted publisher retrievals. The priority statements are limited to the sources examined.

The four manuscript title blocks and PDF metadata use the user-requested **CHATGPT ASTRA 6.2** display byline. The disclosures record AI assistance and the pending confirmation of human authorship and responsibility. [Contribution and disclosure record](CONTRIBUTIONS.md)

## Pending issues

- Human authorship, contribution confirmation and journal accountability. Journal-specific policy and disclosure placement are pending the choice of venue and the responsible human authors.
- Independent human mathematical and priority review is **NOT RUN**. The local checks and written review are available to support that review.
- The array-width asymptotic has a written proof. Its Lean formalization, an independently exportable LRAT package and possible removal of `Lean.ofReduceBool` are outside the present verification scope.
- Full-text access to the three classical balanced-array articles and comparison of their general criteria remain **UNKNOWN**. The report and papers make no unconditional priority claim.
- Journal submission and correspondence are **NOT RUN**.

## Conclusion

The v0.3 draft contains bilingual manuscripts, complete written mathematical arguments, the original Lean and certificate artifacts, explicit formalization boundaries and executable checks. All 17 technical checks and environment collection from the detached source commit completed successfully. Human review, the unresolved literature comparison and journal authorship remain open.
