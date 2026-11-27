"""Exercise certificate readers on temporary corruptions and discriminate the cycle seam."""

import json
import subprocess
import sys
from pathlib import Path
from runpy import run_path
from tempfile import TemporaryDirectory

from verify_graph_semantics import DEFAULT_OUTPUT as WITNESSES
from verify_graph_semantics import verify_assignment
from verify_t18 import DEFAULT_INPUT as ARRAY

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def require_rejection(argv, diagnostic):
    result = subprocess.run([sys.executable, "-B", *map(str, argv)],
                            capture_output=True, text=True, check=False)
    if result.returncode == 0 or diagnostic not in result.stderr:
        raise RuntimeError(f"expected rejection containing {diagnostic!r}: "
                           f"exit {result.returncode}, stderr {result.stderr}")
    print(f"Rejected by {Path(argv[0]).name}: {diagnostic}")


def main():
    with TemporaryDirectory() as directory:
        tmp = Path(directory)
        for kind, audit_error, original_error in (
            ("increment", "equation 0: residual 1", "weight 0"),
            ("negative", "positive integer", "nonnegative integer"),
            ("truncated", "37 multiplicities", "nonnegative integer")
        ):
            record = json.loads(ARRAY.read_bytes())
            values = record["multiplicities"]
            if kind == "increment":
                values[0] += 1
            elif kind == "negative":
                values[0] = -1
            else:
                values.pop()
            path = tmp / f"{kind}.json"
            path.write_text(json.dumps(record), encoding="utf-8")
            require_rejection([HERE / "verify_t18.py", "--check", "--certificate", path], audit_error)
            require_rejection([ROOT / "excess-arrays/verify.py", path], original_error)

        # Changing the final center from 8 to 4 leaves all path distances
        # legal. On the cycle it meets the center of column zero across the seam.
        record = json.loads(WITNESSES.read_bytes())
        colors = [c.copy() for c in record["published_cycle_13"]["colors_by_column"]]
        colors[-1][0] = 4
        verify_assignment("path", 13, 8, colors)
        cycle = next(r for r in record["search"] if r["base_graph"] == "cycle" and r["k"] == 8)
        cycle["colors_by_column"] = colors
        bad_graph = tmp / "edge-conflict.json"
        bad_graph.write_text(json.dumps(record), encoding="utf-8")
        require_rejection([HERE / "verify_graph_semantics.py", "--check", "--output", bad_graph],
                          "color 4, distance 1")
        original_check = run_path(str(ROOT / "packing-corona/verify.py"))["check_cycle"]
        try:
            original_check(colors, 8)
        except ValueError as exc:
            if "color 4 at distance 1" not in str(exc):
                raise
            print(f"Rejected by original check_cycle: {exc}")
        else:
            raise RuntimeError("original check_cycle accepted a conflict on the closing edge")

        # Different valid SAT witness and node-count metadata must both pass.
        cycle["colors_by_column"] = record["published_cycle_13"]["colors_by_column"]
        for row in record["search"]:
            row["search_nodes"] += 1
        alt = tmp / "alternative.json"
        alt.write_text(json.dumps(record), encoding="utf-8")
        subprocess.run([sys.executable, "-B", str(HERE / "verify_graph_semantics.py"),
                        "--check", "--output", str(alt)], check=True, capture_output=True)
        print("Accepted alternative valid coloring and different node counts.")


if __name__ == "__main__":
    main()
