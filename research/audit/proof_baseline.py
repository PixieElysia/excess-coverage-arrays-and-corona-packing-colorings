"""Verify the immutable mathematical and computational baseline against Git."""

import argparse
from hashlib import sha256
import json
from pathlib import Path
import re
import subprocess


ROOT = Path(__file__).resolve().parents[2]
BASE = "5e788f90d91cf7cd0f8a50bfad6f1db6ffc55db2"
MANIFEST = ROOT / "research/proof-baseline.json"
PAPERS = tuple(f"{folder}/paper.{ext}" for folder in
               ("excess-arrays", "packing-corona") for ext in ("tex", "md"))
ARTIFACTS = {
    "verify.sh", "research/collect_results.py",
    "excess-arrays/construct.py", "excess-arrays/verify.py",
    "excess-arrays/small.json", "excess-arrays/t18.json",
    "excess-arrays/results.csv", "excess-arrays/verification.log",
    "packing-corona/graph_search.py", "packing-corona/verify.py",
    "packing-corona/results.csv", "packing-corona/verification.log",
}
SECTIONS = {
    "excess-arrays": ("Rounding intersection counts",
                      "Maximum width under column symmetry",
                      "The strength-18 certificate"),
    "packing-corona": ("A finite transfer graph",
                       "The finite lower bounds",
                       "Coloring words for the upper bounds"),
}


def git(*args):
    return subprocess.check_output(["git", *args], cwd=ROOT)


def digest(data):
    return sha256(data).hexdigest()


def baseline_file(path):
    return git("show", f"{BASE}:{path}")


def protected_units(path, source):
    folder, name = path.split("/")
    if name.endswith(".tex"):
        for i, m in enumerate(re.finditer(
                r"\\begin\{(theorem|lemma|proof|equation)\}(.*?)\\end\{\1\}", source, re.S), 1):
            yield f"{m[1]} environment {i}", m[0]
        heading = r"(?m)^\\section\{([^}]+)\}[^\n]*\n"
        boundary = r"(?m)^\\(?:section\{|appendix\b|begin\{thebibliography\})"
    else:
        for i, m in enumerate(re.finditer(
                r"(?ms)^### Theorem \d+\n\n(.*?)(?=\n\n\S)",
                source), 1):
            content = m[0]
            if source[m.end():].startswith("\n\n$$"):
                rest = source[m.end():]
                end = rest.find("\n$$", len("\n\n$$"))
                if end >= 0:
                    content += rest[:end + 3]
            yield f"Theorem statement {i}", content
        # The numbered first equation precedes the protected proof paragraphs.
        eq = re.search(r'(?ms)^<a name="equation-1"></a>\n\n\$\$.*?\n\$\$', source)
        if eq is not None:
            yield "definition equation", eq[0]
        heading = r"(?m)^## (?:\d+|[A-Z])\. ([^\n]+)\n"
        boundary = r"(?m)^## "

    headings = {m[1]: m for m in re.finditer(heading, source)}
    for section in SECTIONS[folder]:
        start = headings[section].end()
        end = re.search(boundary, source[start:])
        stop = start + end.start() if end else len(source)
        original = source[start:stop]
        for i, paragraph in enumerate(re.split(r"\n[ \t]*\n", original), 1):
            if paragraph.strip():
                yield f"{section}, paragraph {i}", paragraph.strip("\n")


def baseline():
    paths = git("ls-tree", "-r", "--name-only", "-z", BASE).decode().strip("\0").split("\0")
    protected = [p for p in paths if p in ARTIFACTS or p.endswith(".lean")
                 or ("/lean/" in p and p.endswith(
                     ("lean-toolchain", "lakefile.toml", "lake-manifest.json")))]
    if not ARTIFACTS.issubset(protected):
        raise ValueError("Some declared immutable artifacts are absent from the baseline")
    return {
        "baseline": BASE,
        "files": {p: digest(baseline_file(p)) for p in protected},
        "manuscripts": {p: [{"unit": name, "sha256": digest(unit.encode())}
                            for name, unit in protected_units(p, baseline_file(p).decode())]
                        for p in PAPERS},
    }


def check(spec):
    errors = []
    for path, expected in spec["files"].items():
        file = ROOT / path
        if not file.is_file() or digest(file.read_bytes()) != expected:
            errors.append(f"Immutable file missing or changed: {path}")
    current_lean = {p for p in git("ls-files", "-z", "--cached", "--others",
                                     "--exclude-standard").decode().split("\0")
                    if p.endswith(".lean")}
    added = current_lean - {p for p in spec["files"] if p.endswith(".lean")}
    errors.extend(f"Unexpected new Lean source: {p}" for p in sorted(added))

    units = 0
    for path in PAPERS:
        current = (ROOT / path).read_text(encoding="utf-8")
        # Environment and theorem units overlap the proof paragraphs, so the
        # frozen paragraph stream alone is checked for chronological order.
        cursor = 0
        for label, original in protected_units(path, baseline_file(path).decode()):
            if ", paragraph " in label:
                offset = current.find(original, cursor)
                if offset >= 0:
                    cursor = offset + len(original)
            else:
                offset = current.find(original)
            if offset < 0:
                errors.append(f"Frozen text missing or reordered: {path}: {label}")
            units += 1
    if errors:
        raise ValueError("\n".join(errors))
    print(f"Baseline {BASE}")
    print(f"Verified {len(spec['files'])} immutable files and {units} frozen manuscript units.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="derive the manifest from the fixed Git commit")
    args = parser.parse_args()
    spec = baseline()
    if args.write:
        MANIFEST.write_text(json.dumps(spec, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    elif json.loads(MANIFEST.read_text(encoding="utf-8")) != spec:
        parser.exit(1, "Manifest does not match the fixed baseline commit.\n")
    try:
        check(spec)
    except ValueError as error:
        parser.exit(1, str(error) + "\n")


if __name__ == "__main__":
    main()
