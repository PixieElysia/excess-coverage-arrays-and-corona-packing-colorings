"""Check both manuscript languages against the archived mathematical data and PDFs."""

import argparse
import json
from pathlib import Path
import re
from runpy import run_path
import subprocess
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[2]
PROJECTS = ("excess-arrays", "packing-corona")
DISPLAY = "CHATGPT ASTRA 6.2"


def output(*args):
    return subprocess.check_output(args, cwd=ROOT, text=True)


def nodes(node):
    if isinstance(node, dict):
        if "t" in node:
            yield node
        for value in node.values():
            yield from nodes(value)
    elif isinstance(node, list):
        for value in node:
            yield from nodes(value)


def check_gfm(path):
    text = path.read_text(encoding="utf-8")
    ast = list(nodes(json.loads(output("pandoc", "-f", "gfm+tex_math_dollars", "-t", "json", str(path)))))
    if not any(x["t"] == "Table" for x in ast) or not any(
            x["t"] == "Math" and x["c"][0]["t"] == "DisplayMath" for x in ast):
        raise ValueError(f"{path}: missing rendered mathematical content")
    anchors = {x["c"][1][0] for x in ast if x["t"] == "Header"}
    anchors.update(re.findall(r'<a\s+(?:name|id)="([^"]+)"', text))
    for x in ast:
        if x["t"] != "Link":
            continue
        link = urlsplit(x["c"][-1][0])
        if not link.scheme and not link.netloc:
            if link.path:
                if not (path.parent / unquote(link.path)).exists():
                    raise ValueError(f"{path}: missing linked file {link.path}")
            elif link.fragment and unquote(link.fragment) not in anchors:
                raise ValueError(f"{path}: missing local anchor {link.fragment}")
    if DISPLAY not in text:
        raise ValueError(f"{path}: missing manuscript byline")
    return text


def check_array_tables(text):
    vectors = json.loads((ROOT / "excess-arrays/small.json").read_text())
    witnesses = json.loads((ROOT / "excess-arrays/t18.json").read_text())["multiplicities"]
    # The weighted-word table has six cells per row, holding three (i, x_i) pairs.
    entries = {}
    for line in text.splitlines():
        if not re.match(r"^\|\s*\d+\s*\|", line):
            continue
        cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
        if len(cells) == 6 and all(not cell or cell.isdecimal() for cell in cells):
            for i, xi in zip(cells[::2], cells[1::2]):
                if i and xi:
                    entries[int(i)] = int(xi)
    if entries != dict(enumerate(witnesses)):
        raise ValueError("Printed strength-18 entries differ from the original certificate")
    normalized = " ".join(text.split())
    for row in vectors:
        key = f"t={row['strength']:2}: " + ", ".join(map(str, row["multiplicities"]))
        if " ".join(key.split()) not in normalized:
            raise ValueError(f"Missing printed small certificate at strength {row['strength']}")


def check_graph_tables(text):
    original = run_path(str(ROOT / "packing-corona/verify.py"))
    normalized = " ".join(text.split())
    for word in (*original["BLOCKS"].values(), original["THIRTEEN"]):
        if word not in normalized:
            raise ValueError(f"Missing printed coloring word: {word}")
    certificate = json.loads((ROOT / "research/audit/outputs/path-weight-certificate.json").read_text())
    for i in range(12):
        pairs = [f"$({w[i][0]},{w[i][1]})$" for w in certificate["weights"].values()]
        if "| " + " | ".join((str(i), *pairs)) + " |" not in text:
            raise ValueError(f"Missing printed path weights in column {i}")
    for case in certificate["cases"]:
        numbers = [case["fixed_color"], case["weights"], *case["bounds"],
                   sum(case["bounds"]), case["total"]]
        if "| " + " | ".join(map(str, numbers)) + " |" not in text:
            raise ValueError(f"Missing printed path bound for color {case['fixed_color']}")


def check_pdf(path, rebuilt):
    meta = output("pdfinfo", str(path))
    if DISPLAY not in meta or not re.search(r"^Page size:.*\(A4\)", meta, re.M):
        raise ValueError(f"{path}: inconsistent authorship display or page size")
    original = output("pdftotext", "-layout", str(path), "-").split()
    if not original:
        raise ValueError(f"{path}: PDF text extraction was empty")
    if rebuilt is not None:
        new = output("pdftotext", "-layout", str(rebuilt), "-").split()
        if original != new:
            raise ValueError(f"{path}: rebuilt PDF's extracted text differs from archive")
    print(f"{path.relative_to(ROOT)}: PDF title block, page size and extractable text checked")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rebuilt", type=Path,
                        help="directory containing both rebuilt language editions (run_revision.py pdf output)")
    args = parser.parse_args()
    for project, check_tables in zip(PROJECTS, (check_array_tables, check_graph_tables)):
        for stem in ("paper", "paper.zh-CN"):
            base = ROOT / project
            md = base / (stem + ".md")
            check_tables(check_gfm(md))
            print(f"{md.relative_to(ROOT)}: GFM, links, math and paper certificate rows checked")
            language = "zh" if stem.endswith("zh-CN") else "en"
            pdf = base / (stem + ".pdf")
            candidate = args.rebuilt / project / language / pdf.name if args.rebuilt else None
            check_pdf(pdf, candidate)


if __name__ == "__main__":
    main()
