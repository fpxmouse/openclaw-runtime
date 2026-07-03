#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  cat <<'EOF'
openclaw-runtime commands:
  doctor              Check runtime tools and common environment variables.
  repair              Reinstall runtime and skill dependencies.
  install-skills      Scan installed OpenClaw skills and install dependencies.
  help                Show this help.

Short alias:
  ocr doctor
EOF
}

case "${1:-help}" in
  doctor)
    shift
    exec /opt/openclaw-runtime/scripts/doctor.sh "$@"
    ;;
  repair)
    shift
    exec /opt/openclaw-runtime/scripts/repair.sh "$@"
    ;;
  install-skills)
    shift
    exec /opt/openclaw-runtime/scripts/install-skills.sh "$@"
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    echo "unknown command: $1" >&2
    usage >&2
    exit 2
    ;;
esac
