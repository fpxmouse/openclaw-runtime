#!/usr/bin/env bash
set -Eeuo pipefail

log() {
  printf '[openclaw-runtime] %s\n' "$*"
}

if [[ "${OPENCLAW_RUNTIME_AUTO_INSTALL_SKILLS:-1}" == "1" ]]; then
  log "checking skill dependencies"
  /opt/openclaw-runtime/scripts/install-skills.sh || log "skill dependency installation finished with warnings"
fi

original_entrypoint="${OPENCLAW_RUNTIME_ORIGINAL_ENTRYPOINT:-/entrypoint}"

if [[ -x "$original_entrypoint" ]]; then
  exec "$original_entrypoint" "$@"
fi

if command -v openclaw >/dev/null 2>&1; then
  exec openclaw "$@"
fi

log "original entrypoint not found; running command directly"
exec "$@"
