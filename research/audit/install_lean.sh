#!/usr/bin/env bash
# Install the pinned official Linux x86-64 distribution into an empty directory.
set -euo pipefail

if [[ $# != 1 || $(uname -s) != Linux || $(uname -m) != x86_64 ]]; then
  printf '%s\n' 'Usage on Linux x86-64: install_lean.sh DIRECTORY' >&2
  exit 2
fi

destination=$1
if [[ -e "$destination" ]]; then
  printf 'Destination already exists: %s\n' "$destination" >&2
  exit 2
fi

archive=$(mktemp)
trap 'rm -f -- "$archive"' EXIT
url=https://github.com/leanprover/lean4/releases/download/v4.19.0/lean-4.19.0-linux.tar.zst
digest=6fe3ce97a58f44e2b3567d455b994eacec5bfe9ae7774f2a573444480ba813fe
curl --fail --silent --show-error --location --retry 3 --output "$archive" "$url"
printf '%s  %s\n' "$digest" "$archive" | sha256sum --check
mkdir -p -- "$destination"
tar --zstd --strip-components=1 -xf "$archive" -C "$destination"
"$destination/bin/lean" --version
"$destination/bin/lake" --version
"$destination/bin/cadical" --version
