# Launch Claude Code against a local gateway.
#
# Sets the env vars needed to talk to a local Anthropic-compatible endpoint
# (e.g. a localhost proxy for glm) and starts claude with permissions skipped.
#
#   lclaude                               use defaults
#   lclaude --window 200000               override CLAUDE_CODE_AUTO_COMPACT_WINDOW
#   lclaude --base-url http://host:9000   override ANTHROPIC_BASE_URL
#   lclaude --model qwen3                 override ANTHROPIC_MODEL
function lclaude() {
  local window=1048576
  local base_url="http://10.1.0.116:11434"
  local model="qwen3-coder-next:q8_0"

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
      --model)
        if [[ -z "$2" ]]; then
          print -r -- "lclaude: --model requires a value" >&2
          return 2
        fi
        model="$2"; shift 2 ;;
      --help|-h)
        print -r -- "Usage: lclaude [--window N] [--base-url URL] [--model MODEL]"
        print -r -- "  --window N     CLAUDE_CODE_AUTO_COMPACT_WINDOW (default 1048576)"
        print -r -- "  --base-url URL ANTHROPIC_BASE_URL (default http://10.1.0.116:11434)"
        print -r -- "  --model MODEL  ANTHROPIC_MODEL (default qwen3-coder-next:q8_0)"
        return 0 ;;
      *)
        print -r -- "lclaude: unknown option: $1" >&2
        return 2 ;;
    esac
  done

  export ANTHROPIC_BASE_URL="$base_url"
  export ANTHROPIC_API_KEY="any-value"
  export CLAUDE_CODE_AUTO_COMPACT_WINDOW="$window"
  export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE="90"
  export ANTHROPIC_MODEL="$model"
  export ANTHROPIC_DEFAULT_MODEL="$model"
  export ANTHROPIC_FAST_MODEL="$model"
  export ANTHROPIC_THINKING_MODEL="$model"
  export CLAUDE_NO_TELEMETRY="1"

  claude --dangerously-skip-permissions
}
