#!/usr/bin/env python3
"""Query compiled Lean declarations from a temporary directory; builds run separately."""
import argparse
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

BASE = frozenset(("propext", "Classical.choice", "Quot.sound"))
GRAPH = BASE | {"Lean.ofReduceBool"}
PROJECTS = {
    "excess-arrays": ("MainResult", {
        "Excess.equation_three_18": frozenset(),
        "Excess.exists_binary_excess_array_18": frozenset(("propext", "Quot.sound")),
        "Excess.exists_symmetric_binary_excess_array": BASE,
    }),
    "packing-corona": ("EdgeColors", {
        "CoronaUpper.path_exact_on_edges": GRAPH,
        "CoronaUpper.cycle_exact_on_edges": GRAPH,
    }),
}
# This is a literal source review signal; hits in comments also require review.
SOURCE_FLAGS = re.compile(
    r"\b(sorry|admit|sorryAx|unsafe|axiom|constant|native_decide|"
    r"ofReduceBool|implemented_by|extern)\b"
)


def command(args, **kwargs):
    result = subprocess.run(args, capture_output=True, text=True, **kwargs)
    output = result.stdout + result.stderr
    print(output, end="" if output.endswith("\n") else "\n")
    if result.returncode:
        raise RuntimeError(f"{args[0]} exited {result.returncode}")
    return output


def audit(root, name, lean):
    folder = root / name / "lean"
    module, expected = PROJECTS[name]
    build = folder / ".lake/build/lib/lean"
    if not (build / f"{module}.olean").is_file():
        raise FileNotFoundError(f"{name}: missing {module}.olean; build the project first")
    source_flags = []
    files = sorted(p for p in folder.rglob("*.lean")
                   if all(not s.startswith(".") for s in p.relative_to(folder).parts))
    if not files:
        raise FileNotFoundError(f"no Lean source files in {folder}")
    for path in files:
        for number, line in enumerate(path.read_text().splitlines(), 1):
            for match in SOURCE_FLAGS.finditer(line):
                source_flags.append(f"{path.relative_to(root)}:{number}: {match.group()}")
    print(f"{name}: searched {len(files)} project Lean source files for {SOURCE_FLAGS.pattern}")
    if source_flags:
        raise RuntimeError("source entries require review:\n" + "\n".join(source_flags))
    with tempfile.TemporaryDirectory(prefix="lean-axioms-") as tmp:
        query = Path(tmp) / "Audit.lean"
        query.write_text(f"import {module}\n" + "".join(
            f"#check {theorem}\n#print axioms {theorem}\n" for theorem in expected))
        env = dict(os.environ, LEAN_PATH=str(build))
        print(f"{name}: importing {module} from {build}")
        output = command([lean, str(query)], cwd=tmp, env=env)
    for theorem, axioms in expected.items():
        expression = (rf"^'{re.escape(theorem)}' "
                      r"(does not depend on any axioms|depends on axioms:\s*\[([^\]]*)\])$")
        matches = list(re.finditer(expression, output, re.MULTILINE))
        if len(matches) != 1:
            raise RuntimeError(f"{theorem}: missing or ambiguous #print axioms result")
        items = matches[0].group(2) or ""
        actual = frozenset(x.strip() for x in items.split(",") if x.strip())
        if actual != axioms:
            raise RuntimeError(f"{theorem}: expected {sorted(axioms)}, found {sorted(actual)}")
    print(f"{name}: matched all {len(expected)} axiom sets; no flagged source tokens")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument("--project", choices=tuple(PROJECTS))
    parser.add_argument("--lean", default="lean", help="Lean 4.19.0 executable (or name on PATH)")
    args = parser.parse_args()
    lean = shutil.which(args.lean)
    if not lean:
        raise FileNotFoundError(f"Lean executable unavailable: {args.lean}")
    lean = os.path.abspath(lean)
    if not re.search(r"\bversion 4\.19\.0\b", command([lean, "--version"])):
        raise RuntimeError("expected Lean 4.19.0")
    for name in ([args.project] if args.project else PROJECTS):
        audit(args.root.resolve(), name, lean)


if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError) as exc:
        sys.exit(f"AUDIT FAILED: {exc}")
