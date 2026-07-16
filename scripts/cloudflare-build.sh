#!/usr/bin/env bash

set -euo pipefail

MDBOOK_VERSION="${MDBOOK_VERSION:-0.4.52}"
ARCHIVE="mdbook-v${MDBOOK_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
URL="https://github.com/rust-lang/mdBook/releases/download/v${MDBOOK_VERSION}/${ARCHIVE}"

echo "==> Downloading mdBook v${MDBOOK_VERSION}"
curl -fsSL "${URL}" -o "${ARCHIVE}"
tar -xzf "${ARCHIVE}"

echo "==> Building book"
./mdbook build

