#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
  git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

TEMP_FILE="$(mktemp)"

# shellcheck disable=SC2086
gitleaks detect -r "$TEMP_FILE" -f json ${INPUT_GITLEAKS_FLAGS} || true

# shellcheck disable=SC2086
jq -f /gitleaks-to-rdjson.jq -c "$TEMP_FILE" \
  | reviewdog -f="rdjson" \
    -name="gitleaks" \
    -reporter="${INPUT_REPORTER:-github-pr-check}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS}
