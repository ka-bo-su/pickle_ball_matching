#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/codex/push-via-github-api.sh [--owner OWNER] [--repo REPO] [--branch BRANCH] [--sha SHA] [--dry-run]

Purpose:
  Fast-forward a GitHub branch ref via GitHub API when normal git transport is unavailable.

Safety:
  - Refuses main.
  - Refuses non-codex/* branches by default.
  - Uses force=false so GitHub rejects non-fast-forward updates.
  - Verifies the requested SHA matches the local branch HEAD.
USAGE
}

owner=""
repo=""
branch=""
target_sha=""
dry_run=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  --owner)
    owner="${2:-}"
    shift 2
    ;;
  --repo)
    repo="${2:-}"
    shift 2
    ;;
  --branch)
    branch="${2:-}"
    shift 2
    ;;
  --sha)
    target_sha="${2:-}"
    shift 2
    ;;
  --dry-run)
    dry_run=true
    shift
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "[fail] Unknown argument: $1" >&2
    usage >&2
    exit 2
    ;;
  esac
done

if ! command -v gh >/dev/null 2>&1; then
  echo "[fail] gh is required" >&2
  exit 1
fi

if [[ -z "${owner}" ]]; then
  owner="$(gh repo view --json owner --jq '.owner.login')"
fi

if [[ -z "${repo}" ]]; then
  repo="$(gh repo view --json name --jq '.name')"
fi

if [[ -z "${branch}" ]]; then
  branch="$(git branch --show-current)"
fi

if [[ -z "${target_sha}" ]]; then
  target_sha="$(git rev-parse HEAD)"
fi

if [[ -z "${owner}" || -z "${repo}" || -z "${branch}" || -z "${target_sha}" ]]; then
  echo "[fail] owner, repo, branch, and sha are required" >&2
  exit 1
fi

if [[ "${branch}" == "main" ]]; then
  echo "[fail] Refusing to update main" >&2
  exit 1
fi

if [[ "${branch}" != codex/* ]]; then
  echo "[fail] Refusing to update non-codex branch: ${branch}" >&2
  exit 1
fi

local_branch_sha="$(git rev-parse "${branch}")"
if [[ "${local_branch_sha}" != "${target_sha}" ]]; then
  echo "[fail] Requested SHA does not match local branch HEAD" >&2
  echo "branch: ${branch}" >&2
  echo "local:  ${local_branch_sha}" >&2
  echo "target: ${target_sha}" >&2
  exit 1
fi

echo "GitHub REST push fallback"
echo "- owner: ${owner}"
echo "- repo: ${repo}"
echo "- branch: ${branch}"
echo "- sha: ${target_sha}"
echo "- force: false"

if [[ "${dry_run}" == true ]]; then
  echo "[dry-run] No GitHub ref update performed."
  exit 0
fi

gh api \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/${owner}/${repo}/git/refs/heads/${branch}" \
  -f "sha=${target_sha}" \
  -F "force=false" \
  --jq '{ref: .ref, sha: .object.sha, url: .url}'

remote_sha="$(gh api "/repos/${owner}/${repo}/git/ref/heads/${branch}" --jq '.object.sha')"
if [[ "${remote_sha}" != "${target_sha}" ]]; then
  echo "[fail] Remote ref verification failed" >&2
  echo "remote: ${remote_sha}" >&2
  echo "target: ${target_sha}" >&2
  exit 1
fi

echo "[ok] Remote branch ${branch} now points to ${target_sha}"
