#!/bin/sh

set -e

WINCHECKSEC=./winchecksec

debug() {
  echo "::debug::${1}"
}

checks="${1}"
paths="${2}"

for path in ${paths}; do
  debug "checking ${path}"

  # N.B.: we could run all paths at once with a single winchecksec invocation,
  # but running each independently makes the subsequent operations simpler.
  result=$(mktemp -u)
  "${WINCHECKSEC}" --json "${GITHUB_WORKSPACE}/${path}" > "${result}"
done
