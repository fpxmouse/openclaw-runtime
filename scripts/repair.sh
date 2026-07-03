#!/usr/bin/env bash
set -Eeuo pipefail

echo "[openclaw-runtime:repair] reinstalling base Python packages"
python3 -m pip install --break-system-packages --upgrade pip setuptools wheel
python3 -m pip install --break-system-packages -r /opt/openclaw-runtime/requirements.txt

echo "[openclaw-runtime:repair] reinstalling skill dependencies"
/opt/openclaw-runtime/scripts/install-skills.sh

echo "[openclaw-runtime:repair] done"
