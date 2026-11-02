#!/usr/bin/env bash
#
# mcp-parity.sh — Verify Claude's and Codex's MCP server declarations agree.
#
# MCP configuration is the one place in this repository a symlink cannot resolve a
# duplication. `.mcp.json` is Claude Code's, `.codex/config.toml` is Codex's, the
# formats differ, and neither host reads the other's file. So the contract is parity
# rather than a single source, and the rule it derives from is
# `.ai/INSTRUCTIONS.md` -> Maintain one source -> MCP servers are declared twice.
#
# Both files are hand-maintained and NEITHER FAILS WHEN THEY DIVERGE. A server added
# to one host only does not degrade gracefully: it makes the same task answer two
# different ways depending on which tool opened the repository, and nothing says so.
# That silence is the whole reason this script exists.
#
# WHAT PARITY BINDS — the keys that decide WHAT RUNS:
#   * the set of server names
#   * each server's `command`
#   * each server's `args`, in order
#
# WHAT IT DELIBERATELY IGNORES — the keys that tune HOW A HOST SUPERVISES it, which
# have no counterpart across the two formats and are not drift:
#   * Codex's `startup_timeout_sec`, `tool_timeout_sec`, `enabled`
#   * environment blocks — Claude interpolates `${VAR}`, TOML cannot, so the two
#     express the same intent with different text. Comparing them reports a
#     difference on every correctly-configured secret.
#
# Usage: mcp-parity.sh [--output FORMAT] [--output-file PATH] [--quiet] [--help]
#
# Exit codes:  0 = in step   1 = divergence found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

CLAUDE_CONFIG="$PROJECT_ROOT/.mcp.json"
CODEX_CONFIG="$PROJECT_ROOT/.codex/config.toml"

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
FINDING_COUNT=0
SURFACE_NOTE=""
declare -a FINDINGS=()

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'mcp-parity.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
mcp-parity.sh — Verify Claude's and Codex's MCP server declarations agree

.mcp.json (Claude Code) and .codex/config.toml (Codex) declare the same servers in
two formats. Neither host reads the other's file and neither fails when they drift,
so a server added to one is silently absent from the other.

Usage:
  mcp-parity.sh                      Compare the two configs
  mcp-parity.sh --output md          Write a report

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                       (default: code/src/scripts/audits/reports/mcp-parity-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --help               Show this help

There is no --path. This audit compares two files at fixed, repository-root paths;
there is no surface to scope it to, so accepting a scope would either be ignored or
produce a clean run over nothing. Passing it exits 2.

Compared:    the server set, each command, each args list (in order)
Not compared: startup_timeout_sec, tool_timeout_sec, enabled, and env blocks — these
             are per-host supervision keys with no counterpart in the other format.

Exit codes:
  0  the two are in step
  1  divergence found
  2  script error

Fixing a divergence:
  Add the missing server, or align the command/args, so both files declare the same
  thing. The rule is .ai/INSTRUCTIONS.md -> Maintain one source.
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)      [[ $# -ge 2 ]] || die "--output needs a format"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file) [[ $# -ge 2 ]] || die "--output-file needs a path"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)       QUIET=true; shift ;;
    --path)        die "--path is not accepted: this audit compares two fixed files, so a scope would be ignored. Drop it." ;;
    --help|-h)     usage; exit 0 ;;
    *)             die "Unknown option: $1. Use --help for usage." ;;
  esac
done

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"

case "$OUTPUT_FORMAT" in
  ""|md|txt|json) ;;
  *) die "Unknown output format: $OUTPUT_FORMAT (use md, txt or json)" ;;
esac

command -v python3 >/dev/null 2>&1 || die "python3 is required (reads both JSON and TOML via tomllib)"

# ── Collect ───────────────────────────────────────────────────────────────────
bold "▸ mcp-parity.sh"
log "  comparing .mcp.json against .codex/config.toml…"
log ""

# Neither file present is an absent surface, not a pass with nothing looked at — a
# project may legitimately configure no MCP server at all. ONE file present is the
# strongest possible finding rather than an absent surface: it is precisely the
# one-host-only drift this audit exists to catch.
if [[ ! -f "$CLAUDE_CONFIG" && ! -f "$CODEX_CONFIG" ]]; then
  SURFACE_NOTE="Neither .mcp.json nor .codex/config.toml exists — this project configures no MCP server. Nothing to compare."
  log "  $SURFACE_NOTE"
elif [[ ! -f "$CLAUDE_CONFIG" ]]; then
  FINDINGS+=("MISSING_FILE|.mcp.json|.codex/config.toml exists but Claude Code has no config at all")
  FINDING_COUNT=1
elif [[ ! -f "$CODEX_CONFIG" ]]; then
  FINDINGS+=("MISSING_FILE|.codex/config.toml|.mcp.json exists but Codex has no config at all")
  FINDING_COUNT=1
else
  # Normalise both to `TYPE|subject|detail` lines. Parsing failure exits 2 through the
  # trailing guard rather than reporting a clean run over a file that would not load.
  PARSED=$(python3 - "$CLAUDE_CONFIG" "$CODEX_CONFIG" <<'PY'
import json, sys, tomllib

claude_path, codex_path = sys.argv[1], sys.argv[2]

try:
    with open(claude_path, "rb") as fh:
        claude = json.load(fh).get("mcpServers", {}) or {}
except Exception as exc:                                    # noqa: BLE001
    print(f"PARSE_ERROR|{claude_path}|{exc}")
    raise SystemExit(0)

try:
    with open(codex_path, "rb") as fh:
        codex = tomllib.load(fh).get("mcp_servers", {}) or {}
except Exception as exc:                                    # noqa: BLE001
    print(f"PARSE_ERROR|{codex_path}|{exc}")
    raise SystemExit(0)


def shape(entry):
    """The keys that decide what runs. Everything else is host supervision."""
    return (
        (entry.get("command") or ""),
        list(entry.get("args") or []),
    )


for name in sorted(set(claude) | set(codex)):
    if name not in codex:
        print(f"MISSING_CODEX|{name}|declared in .mcp.json, absent from .codex/config.toml")
        continue
    if name not in claude:
        print(f"MISSING_CLAUDE|{name}|declared in .codex/config.toml, absent from .mcp.json")
        continue

    c_cmd, c_args = shape(claude[name])
    x_cmd, x_args = shape(codex[name])

    if c_cmd != x_cmd:
        print(f"COMMAND|{name}|claude={c_cmd!r} codex={x_cmd!r}")
    if c_args != x_args:
        print(f"ARGS|{name}|claude={c_args!r} codex={x_args!r}")
PY
  ) || die "failed to read the MCP configs"

  if [[ -n "$PARSED" ]]; then
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      [[ "$line" == PARSE_ERROR\|* ]] && die "${line#PARSE_ERROR|}"
      FINDINGS+=("$line")
      FINDING_COUNT=$((FINDING_COUNT + 1))
      kind="${line%%|*}"; rest="${line#*|}"; subject="${rest%%|*}"; detail="${rest#*|}"
      log "  ✗ [$kind] $subject"
      log "      $detail"
    done <<< "$PARSED"
  fi
fi

# ── Report ────────────────────────────────────────────────────────────────────
# Written on EVERY path, including the clean one and the absent-surface one: a CI job
# told to collect this artefact must always find it, and under --quiet --output json a
# missing file is no signal at all.
if [[ -n "$OUTPUT_FORMAT" ]]; then
  mkdir -p "$REPORTS_DIR"
  target="${OUTPUT_FILE:-$REPORTS_DIR/mcp-parity-report.$OUTPUT_FORMAT}"
  case "$OUTPUT_FORMAT" in
    json)
      {
        printf '{\n  "findings": %d,\n  "surface_note": "%s",\n  "divergences": [\n' \
          "$FINDING_COUNT" "$SURFACE_NOTE"
        for i in "${!FINDINGS[@]}"; do
          k="${FINDINGS[$i]%%|*}"; r="${FINDINGS[$i]#*|}"; s="${r%%|*}"; d="${r#*|}"
          sep=","; [[ $i -eq $((${#FINDINGS[@]} - 1)) ]] && sep=""
          printf '    {"kind": "%s", "server": "%s", "detail": %s}%s\n' \
            "$k" "$s" "$(printf '%s' "$d" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')" "$sep"
        done
        printf '  ]\n}\n'
      } > "$target"
      ;;
    md)
      {
        printf '# MCP parity audit\n\n'
        printf 'Does `.mcp.json` (Claude Code) declare the same MCP servers as\n'
        printf '`.codex/config.toml` (Codex)? Rule: `.ai/INSTRUCTIONS.md` — _Maintain one source_.\n\n'
        if [[ -n "$SURFACE_NOTE" ]]; then
          printf '%s\n' "$SURFACE_NOTE"
        elif [[ $FINDING_COUNT -eq 0 ]]; then
          printf 'The two configs are in step.\n'
        else
          printf '| Kind | Server | Detail |\n| ---- | ------ | ------ |\n'
          for f in "${FINDINGS[@]}"; do
            k="${f%%|*}"; r="${f#*|}"; s="${r%%|*}"; d="${r#*|}"
            printf '| `%s` | `%s` | %s |\n' "$k" "$s" "$d"
          done
        fi
      } > "$target"
      ;;
    txt)
      {
        printf 'MCP parity audit\n\n'
        if [[ -n "$SURFACE_NOTE" ]]; then
          printf '%s\n' "$SURFACE_NOTE"
        elif [[ $FINDING_COUNT -eq 0 ]]; then
          printf 'The two configs are in step.\n'
        else
          for f in "${FINDINGS[@]}"; do
            k="${f%%|*}"; r="${f#*|}"; s="${r%%|*}"; d="${r#*|}"
            printf '%s  %s  %s\n' "$k" "$s" "$d"
          done
        fi
      } > "$target"
      ;;
  esac
  log ""
  log "  report: ${target#"$PROJECT_ROOT"/}"
fi

log ""
if [[ $FINDING_COUNT -eq 0 ]]; then
  if [[ -n "$SURFACE_NOTE" ]]; then
    bold "✓ No MCP configuration present — nothing compared."
  else
    bold "✓ Claude and Codex declare the same MCP servers."
  fi
  exit 0
fi

bold "✗ $FINDING_COUNT divergence(s) between .mcp.json and .codex/config.toml."
log ""
log "  Neither host reads the other's file, so this drift is invisible at runtime:"
log "  the same task answers differently depending on which tool opened the repo."
log ""
log "  Align both files, then re-run. Rule: .ai/INSTRUCTIONS.md - Maintain one source."
exit 1
