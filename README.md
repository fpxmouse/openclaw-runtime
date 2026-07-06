# OpenClaw Runtime

A production-ready runtime image layer for OpenClaw.

OpenClaw Runtime keeps the official OpenClaw image as the base and adds the tools many skills expect in a real Docker environment:

- Python `pip`, `venv`, headers, build tools, and `uv`
- Node.js and npm
- Git, curl, jq, tree, zip/unzip, editors, and Docker CLI
- automatic dependency installation for OpenClaw skills
- `ocr doctor`, `ocr repair`, and `ocr install-skills`
- GitHub Actions builds for GHCR

## Why

Some OpenClaw container images are intentionally minimal. That is good for size, but skills often assume a fuller runtime with pip, Node, npm, compilers, and common CLI tools.

This project does not modify OpenClaw itself. It adds a thin runtime layer on top of the official image so Unraid, Docker, and homelab users can install skills without repeatedly fixing missing dependencies inside the container.

## Quick Start

Build locally:

```bash
docker build \
  --build-arg OPENCLAW_BASE_IMAGE=ghcr.io/openclaw/openclaw:latest \
  -t openclaw-runtime:latest .
```

Run:

```bash
docker run --rm -it \
  -e OPENROUTER_API_KEY=your_key_here \
  -v openclaw-data:/root/.openclaw \
  openclaw-runtime:latest
```

Check the runtime:

```bash
ocr doctor
```

Install skill dependencies manually:

```bash
ocr install-skills
```

Repair runtime dependencies:

```bash
ocr repair
```

## GitHub + GHCR

1. Create a new GitHub repository named `openclaw-runtime`.
2. Upload all files from this project to that repository.
3. Open the repository `Actions` tab and enable workflows.
4. Go to `Actions` -> `Build image` -> `Run workflow`.
5. After the workflow finishes, your image will be published to:

```text
ghcr.io/YOUR_GITHUB_USERNAME/openclaw-runtime:latest
```

If GHCR says the package is private, open the package settings and change visibility to public.

## Configure The Base Image

The Dockerfile uses:

```dockerfile
ARG OPENCLAW_BASE_IMAGE=ghcr.io/openclaw/openclaw:latest
```

If the official OpenClaw image uses another address, edit the default in:

- `Dockerfile`
- `.github/workflows/build.yml`

You can also override it when running the GitHub workflow.

## Skill Dependency Detection

On container startup, OpenClaw Runtime scans:

```text
/root/.openclaw/workspace/skills
```

It automatically handles skill directories containing:

- `setup.py`
- `pyproject.toml`
- `requirements.txt`
- `package.json`

Disable automatic install:

```bash
OPENCLAW_RUNTIME_AUTO_INSTALL_SKILLS=0
```

Use a custom skills directory:

```bash
OPENCLAW_RUNTIME_SKILLS_DIR=/path/to/skills
```

## Unraid

Use this image in the Unraid Docker template:

```text
ghcr.io/fpxmouse/openclaw-runtime:latest
```

Recommended mappings:

- `/root/.openclaw` -> persistent appdata path
- `/var/run/docker.sock` -> `/var/run/docker.sock`, optional, only if you need Docker CLI access

See [docs/unraid.md](docs/unraid.md).

## Project Status

This is a runtime companion image. It aims to stay compatible with upstream OpenClaw by keeping changes small and transparent.

## License

MIT
