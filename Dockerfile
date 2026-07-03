ARG OPENCLAW_BASE_IMAGE=ghcr.io/openclaw/openclaw:latest
FROM ${OPENCLAW_BASE_IMAGE}

ARG TARGETARCH
ARG NODE_MAJOR=22

ENV DEBIAN_FRONTEND=noninteractive \
    OPENCLAW_RUNTIME=1 \
    OPENCLAW_RUNTIME_SKILLS_DIR=/root/.openclaw/workspace/skills \
    OPENCLAW_RUNTIME_CACHE_DIR=/opt/openclaw-runtime/cache \
    OPENCLAW_RUNTIME_ORIGINAL_ENTRYPOINT=/entrypoint \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    UV_SYSTEM_PYTHON=1

USER root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      gnupg \
      git \
      jq \
      less \
      nano \
      vim-tiny \
      wget \
      unzip \
      zip \
      tree \
      build-essential \
      python3 \
      python3-pip \
      python3-venv \
      python3-dev \
      nodejs \
      npm \
      docker.io; \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /opt/openclaw-runtime/requirements.txt
RUN set -eux; \
    python3 -m pip install --break-system-packages --upgrade pip setuptools wheel; \
    python3 -m pip install --break-system-packages -r /opt/openclaw-runtime/requirements.txt

COPY scripts/ /opt/openclaw-runtime/scripts/
COPY docker-entrypoint.sh /usr/local/bin/openclaw-runtime-entrypoint
RUN set -eux; \
    chmod +x /usr/local/bin/openclaw-runtime-entrypoint /opt/openclaw-runtime/scripts/*.sh; \
    ln -sf /opt/openclaw-runtime/scripts/openclaw-runtime.sh /usr/local/bin/openclaw-runtime; \
    ln -sf /opt/openclaw-runtime/scripts/openclaw-runtime.sh /usr/local/bin/ocr

HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=3 \
  CMD /opt/openclaw-runtime/scripts/doctor.sh --quiet || exit 1

ENTRYPOINT ["/usr/local/bin/openclaw-runtime-entrypoint"]
