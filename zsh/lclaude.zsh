# Launch Claude Code against a local gateway.
#
# Sets the env vars needed to talk to a local Anthropic-compatible endpoint
# (e.g. a localhost proxy for glm) and starts claude with permissions skipped.
#
#   lclaude                          use defaults
#   lclaude --window 200000          override CLAUDE_CODE_AUTO_COMPACT_WINDOW
#   lclaude --base-url http://host:9000   override ANTHROPIC_BASE_URL
#   lclaude --window 200000 --base-url http://host:9000
function lclaude() {
  local window=128000
  local base_url="http://localhost:9000"

  while (( $# )); do
    case "$1" in
      --window)
        if [[ -z "$2" ]]; then
          print -r -- "lclaude: --window requires a value" >&2
          return 2
        fi
        window="$2"; shift 2 ;;
      --base-url)
        if [[ -z "$2" ]]; then
          print -r -- "lclaude: --base-url requires a value" >&2
          return 2
        fi
        base_url="$2"; shift 2 ;;
      --help|-h)
        print -r -- "Usage: lclaude [--window N] [--base-url URL]"
        print -r -- "  --window N     CLAUDE_CODE_AUTO_COMPACT_WINDOW (default 128000)"
        print -r -- "  --base-url URL ANTHROPIC_BASE_URL (default http://localhost:9000)"
        return 0 ;;
      *)
        print -r -- "lclaude: unknown option: $1" >&2
        return 2 ;;
    esac
  done

  export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=95
  export CLAUDE_CODE_AUTO_COMPACT_WINDOW="$window"
  export ANTHROPIC_BASE_URL="$base_url"
  export ANTHROPIC_AUTH_TOKEN=any-value
  export DISABLE_TELEMETRY=1

  claude --model glm-5.2 --dangerously-skip-permissions
}
