# Protected proof baseline

The fixed reference is [5e788f90d91cf7cd0f8a50bfad6f1db6ffc55db2](https://github.com/PixieElysia/excess-coverage-arrays-and-corona-packing-colorings/tree/5e788f90d91cf7cd0f8a50bfad6f1db6ffc55db2). The [machine-readable baseline](proof-baseline.json) contains SHA-256 digests derived directly from this Git object.

The protected file set includes all original Lean sources and build configuration, integer certificates, Python constructors and search programs, computed CSV output, historical verification logs, the original reproduction driver, and the original CSV regeneration program. No Lean declaration is added in this revision. The project documentation beside the Lean sources is editable.

The manuscript register covers theorem and lemma statements, TeX proof and equation environments, and the original paragraphs in the array proof sections and strength-18 appendix and in the graph transfer, obstruction, and construction sections. It protects the ordering of the original paragraphs while permitting explanatory material between them. The original code blocks and coloring words inside these sections are included. Manuscript introductions, bibliography, and surrounding interpretation can be revised.

From a Git checkout that contains the baseline object, run

```sh
python3 -B research/audit/proof_baseline.py
```

The verifier recalculates the expected manifest from the pinned object before comparing the current files. The [distribution manifest](../SHA256SUMS) covers the current revision and serves a different purpose. Both checks retain the actual status independently.
