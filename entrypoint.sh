#!/bin/sh

set -e

WINCHECKSEC=/app/winchecksec

debug() {
  echo "::debug::${1}"
}

error() {
  echo "::error::${1}"
}

begingroup() {
  echo "::group::${1}"
}

endgroup() {
  echo "::endgroup"
}

do_check() {
  query=".[0].mitigations.${1}.presence"
  result="${2}"

  [ "$(jq --raw-output "${query}" < "${result}")" = "Present" ]
}

checks="${1}"
paths="${2}"

for path in ${paths}; do
  debug "checking ${path}"
  begingroup "Winchecksec: ${path}"

  path="${GITHUB_WORKSPACE}/${path}"
  if [ ! -f "${path}" ]; then
    error "no such file: ${path}"
    exit 1
  fi

  # N.B.: we could run all paths at once with a single winchecksec invocation,
  # but running each independently makes the subsequent operations simpler.
  result=$(mktemp -u)
  "${WINCHECKSEC}" -j "${path}" > "${result}"

  for check in ${checks}; do
    debug "running ${check} on ${path}"

    if ! do_check "${check}" "${result}"; then
      error "${path} failed the ${check} check"
      exit 1
    else
      echo "${check} succeeded!"
    fi
  done

  endgroup
done
