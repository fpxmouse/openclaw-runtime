#!/usr/bin/env bash
set -Eeuo pipefail

SKILLS_DIR="${OPENCLAW_RUNTIME_SKILLS_DIR:-/root/.openclaw/workspace/skills}"
CACHE_DIR="${OPENCLAW_RUNTIME_CACHE_DIR:-/opt/openclaw-runtime/cache}"
INSTALL_NODE="${OPENCLAW_RUNTIME_INSTALL_NODE:-1}"
INSTALL_PYTHON="${OPENCLAW_RUNTIME_INSTALL_PYTHON:-1}"
MAX_DEPTH="${OPENCLAW_RUNTIME_SKILL_MAX_DEPTH:-4}"

log() {
  printf '[openclaw-runtime:skills] %s\n' "$*"
}

run_pip_install() {
  local skill_dir="$1"
  shift

  if command -v uv >/dev/null 2>&1; then
    uv pip install --system "$@" || python3 -m pip install --break-system-packages "$@"
  else
    python3 -m pip install --break-system-packages "$@"
  fi
}

install_python_skill() {
  local skill_dir="$1"

  if [[ "$INSTALL_PYTHON" != "1" ]]; then
    return 0
  fi

  if [[ -f "$skill_dir/pyproject.toml" || -f "$skill_dir/setup.py" ]]; then
    log "installing editable Python skill: $skill_dir"
    (cd "$skill_dir" && run_pip_install "$skill_dir" -e .) || log "warning: failed editable install in $skill_dir"
  fi

  if [[ -f "$skill_dir/requirements.txt" ]]; then
    log "installing Python requirements: $skill_dir/requirements.txt"
    run_pip_install "$skill_dir" -r "$skill_dir/requirements.txt" || log "warning: failed requirements install in $skill_dir"
  fi
}

install_node_skill() {
  local skill_dir="$1"

  if [[ "$INSTALL_NODE" != "1" || ! -f "$skill_dir/package.json" ]]; then
    return 0
  fi

  if ! command -v npm >/dev/null 2>&1; then
    log "warning: package.json found but npm is unavailable: $skill_dir"
    return 0
  fi

  log "installing Node dependencies: $skill_dir"
  if [[ -f "$skill_dir/package-lock.json" ]]; then
    (cd "$skill_dir" && npm ci --cache "$CACHE_DIR/npm") || log "warning: npm ci failed in $skill_dir"
  else
    (cd "$skill_dir" && npm install --cache "$CACHE_DIR/npm") || log "warning: npm install failed in $skill_dir"
  fi
}

main() {
  if [[ ! -d "$SKILLS_DIR" ]]; then
    log "skills directory does not exist yet: $SKILLS_DIR"
    return 0
  fi

  mkdir -p "$CACHE_DIR/pip" "$CACHE_DIR/npm"

  declare -A seen=()
  while IFS= read -r -d '' marker; do
    local skill_dir
    skill_dir="$(dirname "$marker")"
    if [[ -n "${seen[$skill_dir]:-}" ]]; then
      continue
    fi
    seen[$skill_dir]=1
    install_python_skill "$skill_dir"
    install_node_skill "$skill_dir"
  done < <(find "$SKILLS_DIR" -maxdepth "$MAX_DEPTH" -type f \( -name setup.py -o -name pyproject.toml -o -name requirements.txt -o -name package.json \) -print0 | sort -z)
}

main "$@"
