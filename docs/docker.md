# Docker Guide

## Build

```bash
docker build \
  --build-arg OPENCLAW_BASE_IMAGE=ghcr.io/openclaw/openclaw:latest \
  -t openclaw-runtime:latest .
```

## Run

```bash
docker run -d \
  --name openclaw \
  -e OPENROUTER_API_KEY=your_key_here \
  -v openclaw-data:/root/.openclaw \
  --restart unless-stopped \
  openclaw-runtime:latest
```

## Docker CLI Access

If you want skills to control host Docker:

```bash
docker run -d \
  --name openclaw \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v openclaw-data:/root/.openclaw \
  openclaw-runtime:latest
```

Mounting the Docker socket gives the container high privileges over the host. Use it only when needed.
