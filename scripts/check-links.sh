#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
mode="${1:-internal}"

cd "$repo_root"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

cp "$repo_root/book.toml" "$tmpdir/book.toml"
ln -s "$repo_root/manuscript" "$tmpdir/manuscript"

cat <<'EOF' >> "$tmpdir/book.toml"

[output.linkcheck]
follow-web-links = false
traverse-parent-directories = false
warning-policy = "error"
EOF

case "$mode" in
  internal)
    exec mdbook-linkcheck --standalone "$tmpdir"
    ;;
  web)
    perl -0pi -e 's/follow-web-links = false/follow-web-links = true/' "$tmpdir/book.toml"
    perl -0pi -e 's/warning-policy = "error"/warning-policy = "warn"/' "$tmpdir/book.toml"

    exec mdbook-linkcheck --standalone "$tmpdir"
    ;;
  *)
    echo "Usage: scripts/check-links.sh [internal|web]" >&2
    exit 1
    ;;
esac

