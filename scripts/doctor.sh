#!/usr/bin/env bash
set -Eeuo pipefail

quiet=0
if [[ "${1:-}" == "--quiet" ]]; then
  quiet=1
fi

ok=0
warn=0

check_cmd() {
  local label="$1"
  local cmd="$2"

  if command -v "$cmd" >/dev/null 2>&1; then
    [[ "$quiet" == "1" ]] || printf '%-18s OK   %s\n' "$label" "$(command -v "$cmd")"
  else
    [[ "$quiet" == "1" ]] || printf '%-18s MISS %s\n' "$label" "$cmd"
    warn=1
  fi
}

check_env() {
  local label="$1"
  local name="$2"

  if [[ -n "${!name:-}" ]]; then
    [[ "$quiet" == "1" ]] || printf '%-18s OK   set\n' "$label"
  else
    [[ "$quiet" == "1" ]] || printf '%-18s MISS %s\n' "$label" "$name"
    warn=1
  fi
}

check_cmd "Python" python3
check_cmd "pip" pip3
check_cmd "uv" uv
check_cmd "Node" node
check_cmd "npm" npm
check_cmd "Git" git
check_cmd "Docker CLI" docker
check_cmd "curl" curl
check_cmd "jq" jq

if [[ -d "${OPENCLAW_RUNTIME_SKILLS_DIR:-/root/.openclaw/workspace/skills}" ]]; then
  [[ "$quiet" == "1" ]] || printf '%-18s OK   %s\n' "Skills dir" "${OPENCLAW_RUNTIME_SKILLS_DIR:-/root/.openclaw/workspace/skills}"
else
  [[ "$quiet" == "1" ]] || printf '%-18s MISS %s\n' "Skills dir" "${OPENCLAW_RUNTIME_SKILLS_DIR:-/root/.openclaw/workspace/skills}"
fi

check_env "OpenRouter key" OPENROUTER_API_KEY

exit "$ok"
