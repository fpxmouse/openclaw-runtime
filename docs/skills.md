# Skill Dependency Handling

OpenClaw Runtime scans installed skills and installs dependencies automatically.

Default skill directory:

```text
/root/.openclaw/workspace/skills
```

Detected files:

- `setup.py`
- `pyproject.toml`
- `requirements.txt`
- `package.json`

## Manual Install

```bash
ocr install-skills
```

## Disable Startup Scan

```bash
OPENCLAW_RUNTIME_AUTO_INSTALL_SKILLS=0
```

## Python

Editable packages are installed with:

```bash
uv pip install --system -e .
```

If `uv` fails, the runtime falls back to:

```bash
python3 -m pip install --break-system-packages -e .
```

## Node

For Node skills:

- `npm ci` is used when `package-lock.json` exists.
- `npm install` is used otherwise.

## Cache

Default cache directory:

```text
/opt/openclaw-runtime/cache
```

Override:

```bash
OPENCLAW_RUNTIME_CACHE_DIR=/path/to/cache
```
