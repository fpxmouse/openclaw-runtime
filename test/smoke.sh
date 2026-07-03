#!/usr/bin/env bash
set -Eeuo pipefail

image="${1:-openclaw-runtime:test}"

docker run --rm --entrypoint /opt/openclaw-runtime/scripts/doctor.sh "$image" || true
docker run --rm --entrypoint /usr/local/bin/openclaw-runtime "$image" help
