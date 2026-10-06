#!/bin/bash
set -euo pipefail

# Only run in Claude Code cloud sessions
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Install the graphify CLI (idempotent; --upgrade is a no-op when current)
if ! command -v graphify >/dev/null 2>&1; then
  uv tool install graphifyy
fi

# Make uv-installed tools available for the whole session
UV_BIN="$(uv tool dir --bin 2>/dev/null || echo "$HOME/.local/bin")"
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$UV_BIN:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi

# Register the /graphify skill with Claude Code
graphify install --platform claude
