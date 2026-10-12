#!/usr/bin/env bash
#
# Claude Code topic: register MCP servers every session should have.
#
# web-search: keyless DuckDuckGo search (uvx duckduckgo-mcp-server). Sessions
# pointed at local vLLM gateways can't use Anthropic's server-side web_search
# built-in (the gateway strips it / has no search backend), so this provides a
# client-side search tool the harness executes itself.
#
# Registered at user scope in ~/.claude.json. That file is machine-local
# state (project history etc.), so this is an installer, not a symlink.
#
# Idempotent: only rewrites the entry when it's missing or differs.

set -euo pipefail

have() { command -v "$1" >/dev/null 2>&1; }

if ! have claude; then
  echo "claude: not installed, skipping MCP registration"
  exit 0
fi
if ! have uvx; then
  echo "claude: uvx not found, skipping MCP registration (script/setup installs uv)"
  exit 0
fi

SERVER="web-search"

# `env -u UV_ENV_FILE`: a global UV_ENV_FILE makes uv refuse to run without a
# .env file ("No environment file found at: .env"); the wrapper is a no-op on
# machines that don't set it.
is_registered() {
  python3 - "$SERVER" <<'PY'
import json, os, sys
server = sys.argv[1]
try:
    with open(os.path.expanduser("~/.claude.json")) as f:
        cfg = json.load(f)
except Exception:
    print("no")
    raise SystemExit
entry = (cfg.get("mcpServers") or {}).get(server) or {}
cmd = [entry.get("command")] + list(entry.get("args") or [])
want = ["env", "-u", "UV_ENV_FILE", "uvx", "duckduckgo-mcp-server"]
print("yes" if cmd == want else "no")
PY
}

if [[ "$(is_registered)" == "yes" ]]; then
  echo "claude: MCP server '$SERVER' already registered"
  exit 0
fi

claude mcp remove -s user "$SERVER" >/dev/null 2>&1 || true
claude mcp add -s user "$SERVER" -- env -u UV_ENV_FILE uvx duckduckgo-mcp-server
echo "claude: registered MCP server '$SERVER' (user scope)"
