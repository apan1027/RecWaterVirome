#!/bin/bash
# Jinlong Ru; Cunli Pan. Upload to the signed-in user's private repository.
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
repo_name="${1:-p0061-RecWaterVirome-code}"
[[ "$repo_name" =~ ^[A-Za-z0-9._-]+$ ]] || { echo 'Invalid repository name.' >&2; exit 1; }
command -v gh >/dev/null
command -v python3 >/dev/null
[[ "$(git branch --show-current)" == dev_pan ]] || { echo 'Expected branch dev_pan.' >&2; exit 1; }
[[ -z "$(git status --porcelain)" ]] || { echo 'Commit or inspect local changes before upload.' >&2; exit 1; }
python3 -B check_candidate.py
owner="$(gh api user --jq .login)"
[[ "$owner" =~ ^[A-Za-z0-9-]+$ ]] || { echo 'Cannot verify signed-in GitHub owner.' >&2; exit 1; }
target="$owner/$repo_name"
expected_remote="https://github.com/$target.git"
if git remote get-url origin >/dev/null 2>&1; then
  [[ "$(git remote get-url origin)" == "$expected_remote" ]] || { echo 'Existing origin differs from the personal repository; stopping.' >&2; exit 1; }
  [[ "$(git remote get-url --push origin)" == "$expected_remote" ]] || { echo 'Existing push URL differs; stopping.' >&2; exit 1; }
fi
error_file="$(git rev-parse --git-path upload-api-error.txt)"
if metadata="$(gh api "repos/$target" --jq '[.full_name, .private] | @tsv' 2>"$error_file")"; then
  :
elif grep -q 'HTTP 404' "$error_file"; then
  gh repo create "$target" --private --description 'RecWaterVirome workflow and saved inputs; BMC clean baseline 2026-10-26'
  metadata="$(gh api "repos/$target" --jq '[.full_name, .private] | @tsv')"
else
  cat "$error_file" >&2
  exit 1
fi
[[ "$metadata" == "$target"$'\ttrue' ]] || { echo 'Destination owner/private status does not match; stopping.' >&2; exit 1; }
if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin "$expected_remote"
fi
# gh supplies credentials only for this command; no global Git settings change.
git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push -u origin dev_pan
local_sha="$(git rev-parse HEAD)"
remote_sha="$(gh api "repos/$target/commits/dev_pan" --jq .sha)"
[[ "$local_sha" == "$remote_sha" ]] || { echo 'Remote revision verification failed.' >&2; exit 1; }
receipt="$(git rev-parse --git-path UPLOAD_RECEIPT.txt)"
printf 'repository=%s\nbranch=dev_pan\ncommit=%s\nprivate=true\nverified_utc=%s\n' "$target" "$remote_sha" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$receipt"
printf '\nVerified private upload: https://github.com/%s/tree/dev_pan\nCommit: %s\n' "$target" "$remote_sha"
