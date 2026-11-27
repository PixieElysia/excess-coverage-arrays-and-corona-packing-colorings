"""Run submission-readiness checks against a fresh, detached Git worktree."""

import argparse
from datetime import datetime
import json
import os
from pathlib import Path
import platform
import shlex
import subprocess
import sys
import tempfile
from zoneinfo import ZoneInfo


ROOT = Path(__file__).resolve().parents[2]
PROJECTS = ("excess-arrays", "packing-corona")
PYTHON = ("python3", "-B")
AUDIT = "research/audit"


def spec(output):
    checks = [
        ("environment", "", ("bash", "-ec", "uname -sm; cat /etc/os-release; python3 --version; "
                              "lean --version; lake --version; cadical --version; latexmk --version; "
                              "xelatex --version; pandoc --version; pdftotext -v")),
        ("proof-baseline", "", (*PYTHON, f"{AUDIT}/proof_baseline.py")),
        ("distribution-hashes", "", ("sha256sum", "-c", "SHA256SUMS")),
        ("array-certificate", "", (*PYTHON, f"{AUDIT}/verify_t18.py", "--check")),
        ("graph-certificates", "", (*PYTHON, f"{AUDIT}/verify_graph_semantics.py", "--check")),
        ("written-obstruction-arithmetic", "", (*PYTHON, f"{AUDIT}/verify_written_obstructions.py")),
        ("negative-controls", "", (*PYTHON, f"{AUDIT}/test_negative_controls.py")),
        ("result-tables", "", (*PYTHON, "research/collect_results.py", "--check")),
    ]
    checks.extend((f"lean-{project}", f"{project}/lean", ("lake", "build"))
                  for project in PROJECTS)
    checks.extend([
        ("original-arrays", "", ("bash", "verify.sh", "arrays")),
        ("original-graphs", "", ("bash", "verify.sh", "graphs")),
        ("axiom-audit", "", (*PYTHON, f"{AUDIT}/audit_lean.py", "--root", ".")),
    ])
    checks.extend((f"latex-{project}", "",
                   ("bash", f"{AUDIT}/build_paper.sh", project, str(output/"pdf"/project/"en")))
                  for project in PROJECTS)
    checks.extend((f"latex-zh-{project}", "",
                   ("bash", f"{AUDIT}/build_chinese_paper.sh", project, str(output/"pdf"/project/"zh")))
                  for project in PROJECTS)
    checks.append(("manuscript-data-and-renders", "",
                   (*PYTHON, f"{AUDIT}/check_manuscripts.py", "--rebuilt", str(output/"pdf"))))
    return checks


def execute(cmd, cwd, env, log_path):
    with log_path.open("wb") as log:
        log.write(f"cwd: {cwd}\n$ {shlex.join(cmd)}\n".encode())
        log.flush()
        try:
            result = subprocess.run(cmd, cwd=cwd, env=env, stdout=log, stderr=subprocess.STDOUT)
            code = result.returncode
        except OSError as error:
            log.write(f"{error}\n".encode())
            code = 127
        log.write(f"\nexit code: {code}\n".encode())
        return code


def save_report(path, report):
    tmp = path.with_suffix(".tmp")
    tmp.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    tmp.replace(path)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--revision", default="HEAD")
    parser.add_argument("--logs", type=Path, required=True)
    parser.add_argument("--lean-bin", type=Path, help="directory containing pinned lean/lake executables")
    args = parser.parse_args()
    output = args.logs.resolve()
    output.mkdir(parents=True, exist_ok=True)
    if any(output.iterdir()):
        parser.error("--logs must name an empty directory")
    revision = subprocess.check_output(
        ["git", "rev-parse", "--verify", f"{args.revision}^{{commit}}"], cwd=ROOT, text=True
    ).strip()
    tmpdir = Path(tempfile.mkdtemp(prefix="research-verification-"))
    checkout = tmpdir / "checkout"
    env = dict(os.environ)
    env.pop("LEAN_PATH", None)
    env.pop("LAKE_HOME", None)
    if args.lean_bin:
        env["PATH"] = os.pathsep.join((str(args.lean_bin.resolve()), env["PATH"]))
    checks = spec(output)
    report = {
        "revision": revision,
        "started_at": datetime.now(ZoneInfo("Asia/Shanghai")).isoformat(timespec="seconds"),
        "platform": platform.platform(),
        "python": platform.python_version(),
        "checkout": str(checkout),
        "checks": [
            {"name": name, "directory": cwd or ".", "command": list(cmd),
             "status": "NOT RUN", "log": f"{name}.log"}
            for name, cwd, cmd in checks
        ],
    }
    report_path = output / "run.json"
    save_report(report_path, report)

    init = ("git", "worktree", "add", "--detach", str(checkout), revision)
    if execute(init, ROOT, env, output / "checkout.log"):
        return 1
    if any((checkout / project / "lean/.lake").exists() for project in PROJECTS):
        print("Clean build precondition failed: a .lake directory exists.", file=sys.stderr)
        return 1
    for (name, cwd, cmd), record in zip(checks, report["checks"]):
        code = execute(cmd, checkout / cwd, env, output / record["log"])
        record.update({"exit_code": code, "status": "PASS" if code == 0 else "FAIL"})
        save_report(report_path, report)
        print(f"{record['status']} {name} · {record['log']}", flush=True)
        if code:
            print(f"Failure preserved in {output}. Worktree retained at {checkout}.", file=sys.stderr)
            return 1
    report["completed_at"] = datetime.now(ZoneInfo("Asia/Shanghai")).isoformat(timespec="seconds")
    save_report(report_path, report)
    print(f"Logs and rebuilt PDFs: {output}")
    print(f"Verified worktree: {checkout}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
