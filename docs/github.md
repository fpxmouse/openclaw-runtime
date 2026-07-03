# GitHub Publishing Guide

This guide assumes you are new to GitHub.

## Create The Repository

1. Open GitHub.
2. Click `New repository`.
3. Repository name: `openclaw-runtime`.
4. Choose `Public`.
5. Do not add a README, license, or `.gitignore` on GitHub because this project already includes them.
6. Click `Create repository`.

## Upload Files In Browser

1. Open the new repository.
2. Click `uploading an existing file`.
3. Drag all project files into the upload page.
4. Commit message: `Initial openclaw-runtime project`.
5. Click `Commit changes`.

## Enable GitHub Actions

1. Open the `Actions` tab.
2. If GitHub asks, click `I understand my workflows, go ahead and enable them`.
3. Open `Build image`.
4. Click `Run workflow`.
5. Keep the default base image unless you know the official OpenClaw image address is different.

## Make GHCR Public

After the first successful build:

1. Open your GitHub profile.
2. Open `Packages`.
3. Open `openclaw-runtime`.
4. Open `Package settings`.
5. Change visibility to `Public`.

Your image address will be:

```text
ghcr.io/YOUR_GITHUB_USERNAME/openclaw-runtime:latest
```
