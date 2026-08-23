#!/usr/bin/env bash
# sync-clickup.sh — Push the generated ClickUp client exports to ClickUp (idempotent upsert).
#
# The repo is the source of truth. Statuses are edited in 02-STORIES/, rendered to
# export/clickup/US###-CLIENT.md by export-clickup-stories.sh, and this script upserts
# each one as a ClickUp task. A durable story->task-id map
# (export/clickup-task-map.json) keeps re-runs idempotent — updates never create duplicates.
#
# Each task: name = story title, status = (mapped) ClickUp status, description = the
# rendered client body (Status/MoSCoW/SP table + Client Summary + User Story).
#
# DRY RUN unless CLICKUP_SYNC_APPLY=1 AND CLICKUP_API_TOKEN + a target list are set.
#
# Target list: CLICKUP_LIST_ID is tried first; if that id is unreachable, the script
# falls back to the 'List' list (or the first list) under CLICKUP_FOLDER_ID.
#
# Env:
#   CLICKUP_API_TOKEN        personal/OAuth token             (required to apply)
#   CLICKUP_LIST_ID  target ClickUp List id (List) (preferred target)
#   CLICKUP_FOLDER_ID        folder to resolve the list from  (fallback if the list id fails)
#   CLICKUP_STATUS_MAP       JSON {repo status -> CU status}  (optional; default identity —
#                            the source stories already use ClickUp's status vocabulary)
#   CLICKUP_SYNC_APPLY       "1" to write to ClickUp; anything else = dry run
#   CLICKUP_TEAM_ID / CLICKUP_SPACE_ID                       (optional context; unused by upsert)
#
# Usage: bash sync-clickup.sh [US###] [--dry-run] [--help]
#   US###       sync only this story (default: all)
#   --dry-run   force a dry run regardless of CLICKUP_SYNC_APPLY
#
# Requires: python3 (stdlib only). Exit: 0 ok/dry-run · 1 sync error · 2 preflight error.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
EXPORT_DIR="$PROJECT_ROOT/project-management/export/clickup"
MAP_FILE="$PROJECT_ROOT/project-management/export/clickup-task-map.json"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '  %s\n' "$*"; }
die()  { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 2; }

ONLY=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      bold "sync-clickup.sh"
      echo ""
      echo "  Upsert the generated ClickUp client exports into ClickUp (idempotent)."
      echo "  DRY RUN unless CLICKUP_SYNC_APPLY=1 and CLICKUP_API_TOKEN + CLICKUP_LIST_ID are set."
      echo ""
      echo "  Usage: bash sync-clickup.sh [US###] [--dry-run]"
      echo "    US###       sync only this story (default: all)"
      echo "    --dry-run   force a dry run regardless of CLICKUP_SYNC_APPLY"
      exit 0
      ;;
    --dry-run) export CLICKUP_SYNC_APPLY=""; shift ;;
    US[0-9]*)  ONLY="$1"; shift ;;
    -*) die "Unknown flag: '$1'. Use --help for usage." ;;
    *)  die "Unexpected argument: '$1'. Pass a story id like US014, or --help." ;;
  esac
done

[[ -d "$EXPORT_DIR" ]] || die "Export dir not found: $EXPORT_DIR — run export-clickup-stories.sh first."
command -v python3 >/dev/null 2>&1 || die "python3 not found on PATH."

python3 - "$EXPORT_DIR" "$MAP_FILE" "$ONLY" << 'PYEOF'
import json, os, re, sys, urllib.request, urllib.error
from pathlib import Path

API        = "https://api.clickup.com/api/v2"
export_dir = Path(sys.argv[1])
map_file   = Path(sys.argv[2])
only       = sys.argv[3].strip()

token           = os.environ.get("CLICKUP_API_TOKEN", "").strip()
env_list_id     = os.environ.get("CLICKUP_LIST_ID", "").strip()
folder_id       = os.environ.get("CLICKUP_FOLDER_ID", "").strip()
apply           = os.environ.get("CLICKUP_SYNC_APPLY", "").strip() == "1"

try:
    status_map = json.loads(os.environ.get("CLICKUP_STATUS_MAP") or "{}")
except json.JSONDecodeError:
    print("ERROR: CLICKUP_STATUS_MAP is not valid JSON.", file=sys.stderr)
    sys.exit(2)

def fail(msg, code=1):
    print(f"ERROR: {msg}", file=sys.stderr)
    sys.exit(code)

def parse(text):
    """Return (title, body, status) from a US###-CLIENT.md file."""
    tm = re.search(r"^#\s+(.+)$", text, re.M)
    title = tm.group(1).strip() if tm else "(untitled)"
    body = re.sub(r"^#\s+.+\r?\n", "", text, count=1, flags=re.M).strip()
    status = ""
    lines = text.splitlines()
    for i, ln in enumerate(lines):
        if re.match(r"^\|\s*-{3,}", ln) and i + 1 < len(lines):
            cells = [c.strip() for c in lines[i + 1].strip().strip("|").split("|")]
            if cells:
                status = cells[0]
            break
    return title, body, status

class ApiError(Exception):
    def __init__(self, code, body):
        self.code, self.body = code, body

def request(method, path, payload=None):
    data = json.dumps(payload).encode() if payload is not None else None
    req = urllib.request.Request(f"{API}{path}", data=data, method=method)
    req.add_header("Authorization", token)
    req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        raise ApiError(e.code, e.read().decode()[:300])
    except urllib.error.URLError as e:
        raise ApiError(0, f"network error: {e.reason}")

def api(method, path, payload=None):
    """Hard-fail wrapper used by the upsert loop."""
    try:
        return request(method, path, payload)
    except ApiError as e:
        fail(f"ClickUp {method} {path} -> {e.code}: {e.body}")

def resolve_list_id():
    """Target List id: CLICKUP_LIST_ID if reachable, else the 'List' list (or the
    first list) under CLICKUP_FOLDER_ID. Returns (list_id, human-readable target description)."""
    if env_list_id:
        try:
            request("GET", f"/list/{env_list_id}")
            return env_list_id, f"list {env_list_id}"
        except ApiError as e:
            print(f"  list {env_list_id} unusable ({e.code}) — falling back to folder {folder_id or '(unset)'}")
    if folder_id:
        try:
            lists = request("GET", f"/folder/{folder_id}/list").get("lists", [])
        except ApiError as e:
            fail(f"folder {folder_id} list lookup -> {e.code}: {e.body}")
        chosen = next((l for l in lists if str(l.get("name", "")).strip().lower() == "list"), None)
        if chosen is None and lists:
            chosen = lists[0]
        if chosen:
            return chosen["id"], f"folder {folder_id} -> list '{chosen.get('name')}' ({chosen['id']})"
        fail(f"folder {folder_id} contains no lists")
    fail("no target list — set CLICKUP_LIST_ID or CLICKUP_FOLDER_ID")

# Applying needs a token and at least one way to target a list; else announce a dry run.
if apply and not token:
    print("WARNING: CLICKUP_SYNC_APPLY=1 but CLICKUP_API_TOKEN missing — running DRY RUN.")
    apply = False
if apply and not (env_list_id or folder_id):
    print("WARNING: CLICKUP_SYNC_APPLY=1 but neither CLICKUP_LIST_ID nor CLICKUP_FOLDER_ID set — running DRY RUN.")
    apply = False

def us_num(p):
    m = re.search(r"US(\d+)", p.name)
    return int(m.group(1)) if m else -1

files = sorted(export_dir.glob("US[0-9]*-CLIENT.md"), key=us_num)
if only:
    files = [p for p in files if p.name.startswith(only + "-")]
    if not files:
        fail(f"story '{only}' has no export file in {export_dir}", 2)
if not files:
    fail(f"no export files in {export_dir} — run export-clickup-stories.sh first", 2)

task_map = {}
if map_file.exists():
    try:
        task_map = json.loads(map_file.read_text() or "{}")
    except json.JSONDecodeError:
        fail(f"{map_file} is not valid JSON", 2)

# Resolve the target list (list id first, folder fallback) only when actually applying.
target_desc = env_list_id or (f"folder {folder_id}" if folder_id else "(unset)")
list_id = ""
if apply:
    list_id, target_desc = resolve_list_id()

print(f"ClickUp sync — {'APPLY' if apply else 'DRY RUN'} — {len(files)} story file(s) -> {target_desc}")

created = updated = 0
for f in files:
    sid = re.search(r"(US\d+)", f.name).group(1)
    title, body, status = parse(f.read_text(encoding="utf-8"))
    cu_status = status_map.get(status, status)
    payload = {"name": title, "markdown_content": body}
    if cu_status:
        payload["status"] = cu_status
    existing = task_map.get(sid)
    action = "update" if existing else "create"
    if not apply:
        print(f"  [dry-run] {action:6} {sid} — {title}  (status={cu_status or '—'})")
        continue
    if existing:
        api("PUT", f"/task/{existing}", payload)
        updated += 1
    else:
        res = api("POST", f"/list/{list_id}/task", payload)
        tid = res.get("id")
        if not tid:
            fail(f"create {sid}: ClickUp returned no task id")
        task_map[sid] = tid
        created += 1
    print(f"  {action:6} {sid} — {title}")

if apply:
    map_file.write_text(json.dumps(task_map, indent=2, sort_keys=True) + "\n")
    print(f"Done: {created} created, {updated} updated. Map -> {map_file}")
else:
    print(f"Dry run complete — nothing sent. {len(files)} stories would sync.")
PYEOF
