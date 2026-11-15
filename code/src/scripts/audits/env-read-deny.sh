#!/usr/bin/env bash
#
# env-read-deny.sh — Verify every AI host's config denies reading the live env files.
#
# The rule (`.claude/CLAUDE.md` Section 6): no AI tool ever reads a live env file —
# `.env.dev`, `.env.test`, `.env.testing`, `.env.staging`, `.env.prod`, `.env.production` —
# while the `.env.*.example` files stay readable. Three hosts enforce it, each in its own
# format, and none reads another's file:
#
#   * Claude Code  `.claude/settings.json`  permissions.deny holds Read(**/.env.<n>) AND
#                                           Edit(**/.env.<n>) for every name
#   * Codex        `.codex/config.toml`     default_permissions names a profile whose
#                                           filesystem.":workspace_roots" maps
#                                           "**/.env.<n>" to "deny" for every name, and the
#                                           legacy sandbox_mode is not set beside it
#   * Zed          `.zed/settings.json`     private_files covers every name
#
# Like mcp-parity.sh, the three files are hand-maintained and NONE FAILS WHEN ONE DRIFTS: a
# name dropped from one host leaves that host free to read the file, and nothing says so.
# This script is the only thing holding them in step. The six names below are the list; a new
# live env file joins it here and in all three configs in the same change.
#
# What it cannot see: a per-run override (Codex `-s`, `-c sandbox_mode=…`, the bypass flag) or
# a user-level setting that widens access. Those are outside the repository.
#
# Usage: env-read-deny.sh [--output FORMAT] [--output-file PATH] [--quiet] [--help]
#
# Exit codes:  0 = every host denies every name   1 = a gap found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

CLAUDE_CONFIG="$PROJECT_ROOT/.claude/settings.json"
CODEX_CONFIG="$PROJECT_ROOT/.codex/config.toml"
ZED_CONFIG="$PROJECT_ROOT/.zed/settings.json"
LIVE_NAMES="dev test testing staging prod production"

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'env-read-deny.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
env-read-deny.sh — Verify every AI host's config denies reading the live env files

Checks .claude/settings.json, .codex/config.toml and .zed/settings.json each deny
.env.dev, .env.test, .env.testing, .env.staging, .env.prod and .env.production.

Usage:
  env-read-deny.sh                    Check and print the result
  env-read-deny.sh --output md        Write a report

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
  --quiet              Suppress terminal output — requires --output
  --help, -h           Show this help

There is no --path: three files at fixed, repository-root paths are not a scope.
Passing it exits 2.

Exit codes:
  0  every host present denies every name (or no host config is present, said so)
  1  a host config is missing a name, or one host's config is absent beside the others
  2  script error

Fixing a gap: add the missing entry to the host config the finding names. Never remove
a name from the list here to make the run pass.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)      [[ $# -ge 2 ]] || die "--output needs a format"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file) [[ $# -ge 2 ]] || die "--output-file needs a path"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)       QUIET=true; shift ;;
    --path)        die "--path is not supported: this audit reads three fixed files" ;;
    --help|-h)     usage; exit 0 ;;
    *)             die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
case "$OUTPUT_FORMAT" in
  ""|md|txt|json) ;;
  *) die "Unknown output format: $OUTPUT_FORMAT (use md, txt or json)" ;;
esac
command -v python3 >/dev/null 2>&1 || die "python3 is required (reads JSON and TOML via tomllib)"

bold "▸ env-read-deny.sh"
log "  checking .claude/settings.json, .codex/config.toml and .zed/settings.json…"
log ""

# One finding per line on stdout; a line starting "NOTE " is the absent-surface note.
# Zed's settings allow // comments, so they are stripped before parsing.
RESULT="$(python3 - "$CLAUDE_CONFIG" "$CODEX_CONFIG" "$ZED_CONFIG" "$LIVE_NAMES" <<'PY'
import fnmatch, json, os, re, sys, tomllib
claude, codex, zed, names = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4].split()
present = {p: os.path.isfile(p) for p in (claude, codex, zed)}
if not any(present.values()):
    print("NOTE no AI host config is present — nothing to check"); sys.exit(0)
out = []
for p, label in ((claude, ".claude/settings.json"), (codex, ".codex/config.toml"), (zed, ".zed/settings.json")):
    if not present[p]:
        out.append(f"{label}: absent while another host's config is present — that host is unguarded")
if present[claude]:
    deny = set(json.load(open(claude)).get("permissions", {}).get("deny", []))
    for n in names:
        for tool in ("Read", "Edit"):
            if f"{tool}(**/.env.{n})" not in deny:
                out.append(f".claude/settings.json: permissions.deny lacks {tool}(**/.env.{n})")
if present[codex]:
    cfg = tomllib.load(open(codex, "rb"))
    prof = cfg.get("default_permissions")
    if "sandbox_mode" in cfg:
        out.append(".codex/config.toml: legacy sandbox_mode is set — remove it; the deny profile is default_permissions")
    if not prof or prof.startswith(":"):
        out.append(".codex/config.toml: default_permissions does not name a project profile carrying the denies")
    else:
        roots = cfg.get("permissions", {}).get(prof, {}).get("filesystem", {}).get(":workspace_roots", {})
        for n in names:
            if roots.get(f"**/.env.{n}") != "deny":
                out.append(f'.codex/config.toml: profile {prof} lacks "**/.env.{n}" = "deny"')
if present[zed]:
    text = re.sub(r"^\s*//.*$", "", open(zed).read(), flags=re.M)
    globs = json.loads(text).get("private_files", [])
    for n in names:
        if not any(fnmatch.fnmatch(f"x/.env.{n}", g.replace("**/", "*/")) for g in globs):
            out.append(f".zed/settings.json: private_files does not cover .env.{n}")
print("\n".join(out))
PY
)" || die "the config check failed to run (a config may not parse)"

NOTE=""
declare -a FINDINGS=()
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  if [[ "$line" == NOTE\ * ]]; then NOTE="${line#NOTE }"; else FINDINGS+=("$line"); fi
done <<<"$RESULT"

if [[ -n "$NOTE" ]]; then
  log "  $NOTE"
elif (( ${#FINDINGS[@]} == 0 )); then
  log "  every host denies all six live env files"
else
  for f in "${FINDINGS[@]}"; do log "  ✗ $f"; done
fi
log ""

if [[ -n "$OUTPUT_FORMAT" ]]; then
  mkdir -p "$REPORTS_DIR"
  [[ -n "$OUTPUT_FILE" ]] || OUTPUT_FILE="$REPORTS_DIR/env-read-deny-report.$OUTPUT_FORMAT"
  {
    case "$OUTPUT_FORMAT" in
      json)
        printf '{"findings": %s, "note": %s}\n' \
          "$(printf '%s\n' "${FINDINGS[@]+"${FINDINGS[@]}"}" | python3 -c 'import json,sys;print(json.dumps([l for l in sys.stdin.read().splitlines() if l]))')" \
          "$(python3 -c 'import json,sys;print(json.dumps(sys.argv[1] or None))' "$NOTE")"
        ;;
      md)
        printf '# env-read-deny\n\n'
        [[ -n "$NOTE" ]] && printf '%s\n' "$NOTE"
        (( ${#FINDINGS[@]} == 0 )) && [[ -z "$NOTE" ]] && printf 'Every host denies all six live env files.\n'
        for f in "${FINDINGS[@]+"${FINDINGS[@]}"}"; do printf -- '- %s\n' "$f"; done
        ;;
      txt)
        [[ -n "$NOTE" ]] && printf '%s\n' "$NOTE"
        for f in "${FINDINGS[@]+"${FINDINGS[@]}"}"; do printf '%s\n' "$f"; done
        ;;
    esac
  } >"$OUTPUT_FILE"
  log "  report: ${OUTPUT_FILE#"$PROJECT_ROOT"/}"
fi

if (( ${#FINDINGS[@]} > 0 )); then
  printf '\033[31m✗ %s gap(s) — a host can read a live env file\033[0m\n' "${#FINDINGS[@]}"
  exit 1
fi
bold "✓ env-read-deny clean"
