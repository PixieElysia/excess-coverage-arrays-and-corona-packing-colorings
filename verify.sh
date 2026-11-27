#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

check_arrays() (
  printf '%s\n' 'Checking binary excess coverage arrays'
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

check_graph_search() {
  local shape="$1" order="$2" colors="$3" expected="$4" output
  output=$(python3 -B graph_search.py "$shape" "$order" "$colors")
  printf '%s\n' "$shape $order $colors: $output"
  [[ "${output%%$'\n'*}" == "$expected" ]]
}

check_graphs() (
  printf '%s\n' 'Checking packing colorings of corona graphs'
  cd packing-corona
  python3 -B verify.py
  check_graph_search path 11 6 'SAT search nodes 34'
  check_graph_search path 12 6 'UNSAT search nodes 10221'
  check_graph_search cycle 13 7 'UNSAT search nodes 162103'
  check_graph_search cycle 13 8 'SAT search nodes 201'
  cd lean
  lake build
)

case "${1:-all}" in
  all) check_arrays; check_graphs ;;
  arrays) check_arrays ;;
  graphs) check_graphs ;;
  *) printf '%s\n' 'Usage: ./verify.sh [all|arrays|graphs]' >&2; exit 2 ;;
esac
