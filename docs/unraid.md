# Unraid Guide

## Image

Use:

```text
ghcr.io/YOUR_GITHUB_USERNAME/openclaw-runtime:latest
```

Replace `YOUR_GITHUB_USERNAME` with your GitHub username.

## Recommended Paths

Map a persistent appdata directory:

```text
Host:      /mnt/user/appdata/openclaw
Container: /root/.openclaw
```

Optional Docker socket mapping:

```text
Host:      /var/run/docker.sock
Container: /var/run/docker.sock
```

Only mount the Docker socket if you want OpenClaw or skills to manage local Docker containers.

## Environment Variables

Common variables:

```text
OPENROUTER_API_KEY=your_openrouter_key
OPENCLAW_RUNTIME_AUTO_INSTALL_SKILLS=1
OPENCLAW_RUNTIME_SKILLS_DIR=/root/.openclaw/workspace/skills
```

## Auto Update

Install the Unraid CA Auto Update Applications plugin. Once your GitHub workflow publishes a new GHCR image, Unraid can pull it automatically.

## First Check

Open the container console and run:

```bash
ocr doctor
```

Expected result:

```text
Python             OK
pip                OK
uv                 OK
Node               OK
npm                OK
Git                OK
Docker CLI         OK
```

If a skill was installed before the runtime image was used, run:

```bash
ocr install-skills
```
