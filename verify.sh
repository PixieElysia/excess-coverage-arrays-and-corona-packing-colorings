#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

printf '%s\n' 'Checking binary excess coverage arrays'
(
  cd excess-arrays
  python3 -B verify.py small.json t18.json
  python3 -B - <<'PY'
from construct import multiplicities
from verify import verify

for t in range(17, 23):
    k = 2 * t
    print(verify({"strength": t, "columns": k, "multiplicities": multiplicities(t, k)}))
PY
  cd lean
  lake build
)

printf '%s\n' 'Checking packing colorings of corona graphs'
(
  cd packing-corona
  python3 -B verify.py
  path_result=$(python3 -B graph_search.py path 12 6)
  cycle_result=$(python3 -B graph_search.py cycle 13 7)
  printf '%s\n' "$path_result" "$cycle_result"
  [[ "$path_result" == 'UNSAT search nodes 10221' ]]
  [[ "$cycle_result" == 'UNSAT search nodes 162103' ]]
  cd lean
  lake build
)
