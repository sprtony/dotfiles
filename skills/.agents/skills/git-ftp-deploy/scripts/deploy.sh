#!/usr/bin/env bash
set -euo pipefail

COMMIT_MSG="${1:-deploy: build and push via git-ftp}"

if [ -f "pnpm-lock.yaml" ] || command -v pnpm &>/dev/null; then
    BUILD_CMD="pnpm run build"
elif [ -f "yarn.lock" ]; then
    BUILD_CMD="yarn build"
elif [ -f "package-lock.json" ]; then
    BUILD_CMD="npm run build"
else
    BUILD_CMD="npm run build"
fi

echo "[1/3] Running build (${BUILD_CMD})..."
${BUILD_CMD}

echo ""
echo "[2/3] Committing changes..."
git add -A
git commit -m "$COMMIT_MSG"

echo ""
echo "[3/3] Pushing via git-ftp..."
git ftp push

echo ""
echo "Deploy complete."
