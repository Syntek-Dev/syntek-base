#!/usr/bin/env bash
#
# sync-trees.sh — Keep the `## Directory Tree` block in every CONTEXT.md honest.
#
#                 A tree goes stale the moment a file is added beside it, and nothing
#                 fails when it does. This reconciles the block's **membership** against
#                 what is actually on disk.
#
#                 IT RECONCILES MEMBERSHIP; IT DOES NOT REGENERATE THE TREE.
#                 There are 1,132 hand-written `←` annotations across this repository and
#                 they are the whole value of these files — a regenerator would produce a
#                 correct, useless `tree` dump. So:
#
#                   ADDED     an entry on disk that the block omits, inserted in place
#                             carrying a `← TODO:` annotation for a human to replace.
#                             Adding one FAILS the run, so the pre-commit hook stops and
#                             asks: a row that is accurate and says nothing is not
#                             orientation, and nobody ever goes back for it afterwards.
#                   REPORTED  an entry in the block that is not on disk. Never deleted
#                             automatically — see the two exemptions below, either of
#                             which makes a "missing" entry correct.
#                   PRESERVED everything else, byte for byte: annotations, column
#                             alignment, ordering, section divider lines, and depth.
#
#                 ONLY THE TOP LEVEL of each block is reconciled. Deeper levels are
#                 curated summaries that deliberately show some directories' contents and
#                 not others; reconciling them turns a judgement into a false positive.
#
#                 Two exemptions, both load-bearing:
#                   * PLACEHOLDER rows — `<TOPIC>.md`, `US###.md`, `MAP-<FEATURE>.md`,
#                     `*.yml`. They describe a naming pattern, not a file.
#                   * GATED rows — anything annotated MOBILE-ONLY / RUST-ONLY /
#                     DESKTOP-ONLY, or "absent unless"/"optional"/"opted in". These
#                     dangle by design so the index carries no conditional contents.
#
#                 NOT HANDLED HERE: `.copier/README.md`'s Project Tree. That is a
#                 template-integrity concern and `.github/scripts/shipped-readme.sh`
#                 already owns it — two tools writing one block would fight.
#
# Requirements: git, python3. No network.
#
# Usage: sync-trees.sh [--check|--write] [--staged] [--path PATH] [--quiet] [--help]
#
#   --check    Report drift, change nothing (default)
#   --write    Apply the additions, print the removals to resolve by hand
#   --staged   Only CONTEXT.md files whose directory has a staged change (for the hook)
#   --path P   Only this CONTEXT.md, or every one under this directory
#
# Exit codes:  0 = trees match   1 = drift, or rows were added and still need describing
#              2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

MODE="check"
STAGED=false
TARGET_PATH=""
QUIET=false

die() { printf 'sync-trees.sh error: %s\n' "$*" >&2; exit 2; }

usage() {
  sed -n '2,45p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check)  MODE="check";  shift ;;
    --write)  MODE="write";  shift ;;
    --staged) STAGED=true;   shift ;;
    --path)   TARGET_PATH="${2:-}"; [[ -n "$TARGET_PATH" ]] || die "--path needs a value"; shift 2 ;;
    --quiet)  QUIET=true;    shift ;;
    --help|-h) usage; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done

cd "$PROJECT_ROOT"
command -v python3 >/dev/null 2>&1 || die "python3 is required"

MODE="$MODE" STAGED="$STAGED" TARGET_PATH="$TARGET_PATH" QUIET="$QUIET" python3 - <<'PYEOF'
import os, re, subprocess, sys
from pathlib import Path

MODE   = os.environ["MODE"]
STAGED = os.environ["STAGED"] == "true"
TARGET = os.environ["TARGET_PATH"]
QUIET  = os.environ["QUIET"] == "true"

def sh(*a):
    return subprocess.run(a, capture_output=True, text=True).stdout.splitlines()

def log(*a):
    if not QUIET: print(*a)

# ── Which CONTEXT.md files ────────────────────────────────────────────────────
contexts = [Path(p) for p in sh("git", "ls-files", "*CONTEXT.md")]
contexts += [Path(p) for p in sh("git", "ls-files", "--others", "--exclude-standard", "*CONTEXT.md")]
contexts = sorted({c for c in contexts if c.exists()})

if TARGET:
    t = Path(TARGET)
    contexts = [c for c in contexts if c == t or t in c.parents]
if STAGED:
    touched = {Path(p).parent for p in sh("git", "diff", "--cached", "--name-only") if p}
    contexts = [c for c in contexts if c.parent in touched]

# ── What counts as "on disk" ──────────────────────────────────────────────────
IGNORED_DIRS = {".git", "node_modules", ".venv", "__pycache__", ".code-review-graph"}

def entries_on_disk(d: Path):
    """Direct children of d, split into (exists, should_be_listed).

    Existence and listing-duty are different questions. A gitignored file that is
    present still EXISTS — so a tree row naming it is correct, not stale — but it is
    not something a tree must be made to list."""
    exists, required = set(), set()
    for child in sorted(d.iterdir()):
        if child.name in IGNORED_DIRS:
            continue
        nm = child.name + ("/" if child.is_dir() else "")
        exists.add(nm)
        if subprocess.run(["git", "check-ignore", "-q", str(child)]).returncode != 0:
            required.add(nm)
    return exists, required

# ── Tree-line grammar ─────────────────────────────────────────────────────────
# A top-level row is "├── name" or "└── name" with no leading box-drawing.
# A row for insertion purposes. Annotations use either arrow, and some rows carry
# trailing prose with neither — so everything after the name is opaque.
ROW = re.compile(r'^(?P<branch>[├└]── )(?P<name>[^\s]+)(?P<rest>\s.*)?$')
# Parentheses mark prose, not a filename — `└── (add your logo files here)`.
PLACEHOLDER = re.compile(r'[<>*()]|#{2,}|\{|\}')

# Paths `_tasks` removes at generation time. Present here, never in a generated project,
# so a shipped tree correctly omits them.
TEMPLATE_ONLY = {".copier"}

def placeholder_to_regex(nm):
    """`MAP-<FEATURE>.md` covers MAP-DISCOVERABILITY.md; `SPRINT-##.md` covers
    SPRINT-01.md. A row describing a naming pattern already accounts for every file
    matching it — listing the instances as well is what the pattern exists to avoid."""
    # Date and index tokens are as much a placeholder as an angle-bracket one:
    # HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md must cover HANDOFF-AUTH-09-08-2026.md.
    for tok, pat in (("YYYY", r'\d{4}'), ("DD", r'\d{2}'), ("MM", r'\d{2}'),
                     ("NN", r'\d+'), ("XXX", r'[A-Za-z0-9]+')):
        nm = nm.replace(tok, "\x00" + pat + "\x00")
    out, i = "", 0
    while i < len(nm):
        c = nm[i]
        if c == "\x00":
            j = nm.index("\x00", i + 1)
            out += nm[i + 1:j]; i = j + 1; continue
        if c == "<":
            j = nm.find(">", i)
            if j == -1:
                out += re.escape(c); i += 1; continue
            out += r'[A-Za-z0-9._-]+'; i = j + 1
        elif c == "#":
            j = i
            while j < len(nm) and nm[j] == "#":
                j += 1
            out += r'\d+'; i = j
        elif c == "*":
            out += r'[A-Za-z0-9._-]*'; i += 1
        else:
            out += re.escape(c); i += 1
    return re.compile("^" + out + "$")
GATED = re.compile(
    r'MOBILE-ONLY|RUST-ONLY|DESKTOP-ONLY|absent unless|opted in|optional'
    r'|gitignored|local override|no content|planned', re.I)

# Template-only paths never appear in a shipped tree, and must not be demanded of one.
def copier_excluded():
    out = set()
    try:
        txt = Path("copier.yml").read_text()
    except OSError:
        return out
    body = txt.split("_exclude:", 1)[-1]
    # Copier's block-opening delimiter, assembled from its two characters rather than
    # written out. THIS FILE IS RENDERED: spelling the pair literally makes Jinja parse
    # it as a tag while generating every project, and the whole generation dies with
    # TemplateSyntaxError. It did, from v2.4.0 until 13/08/2026.
    block_open = "<" + ":"
    for line in body.split("\n"):
        if re.match(r'^[a-zA-Z_]+:', line):
            break
        m = re.match(r'^\s*-\s*"?(.+?)"?\s*$', line)
        if not m:
            continue
        v = m.group(1)
        if block_open in v:
            g = re.search(r'>(/[^<]+)<', v)
            v = g.group(1) if g else ""
        out.add(v.lstrip("/").rstrip("/"))
    return {v for v in out if v}

EXCLUDED = copier_excluded()

drift, wrote = [], []

for ctx in contexts:
    text = ctx.read_text()
    lines = text.split("\n")

    # locate the fenced text block that opens with a directory header
    start = end = None
    for i, L in enumerate(lines):
        if L.startswith("```text"):
            for j in range(i + 1, len(lines)):
                if lines[j].startswith("```"):
                    end = j
                    break
            if end is None:
                break
            header = lines[i + 1].strip() if i + 1 < len(lines) else ""
            if header.endswith("/"):
                start = i + 1
            break
    if start is None or end is None:
        continue

    body = lines[start + 1:end]
    dirpath = ctx.parent

    # Parse top-level rows; anything else (nested, dividers, blanks) is untouched.
    parsed = []           # (index_in_body, name_with_slash, annotation, matchobj)
    for k, L in enumerate(body):
        m = ROW.match(L)
        if not m:
            continue
        nm = m.group("name")
        parsed.append((k, nm, m.group("rest") or "", m))

    if not parsed:
        continue

    # Membership is "the name appears anywhere in the block", not "there is a row for
    # it". Several trees name a sub-directory inline instead — `ACCESSIBILITY.md
    # (sub-docs: accessibility/)` — which is a curated choice, not an omission.
    block_text = "\n".join(body)
    exists, required = entries_on_disk(dirpath)
    actual_bare = {a.rstrip("/") for a in exists}
    patterns = [placeholder_to_regex(nm) for _, nm, _, _ in parsed if PLACEHOLDER.search(nm)]

    def named_in_block(bare):
        return re.search(r'(?<![\w./-])' + re.escape(bare) + r'(?![\w-])', block_text) is not None

    def covered_by_pattern(bare):
        return any(p.match(bare) for p in patterns)

    missing_from_tree = sorted(
        a for a in required
        if not named_in_block(a.rstrip("/"))
        and not covered_by_pattern(a.rstrip("/"))
        and str((dirpath / a.rstrip("/"))).lstrip("./") not in EXCLUDED
        and a.rstrip("/") not in TEMPLATE_ONLY
    )
    not_on_disk = []
    for _, nm, ann, m in parsed:
        bare = nm.rstrip("/")
        if bare in actual_bare:
            continue
        if PLACEHOLDER.search(nm) or GATED.search(m.group("rest") or ""):
            continue
        if str((dirpath / bare)).lstrip("./") in EXCLUDED:
            continue
        not_on_disk.append(nm)

    if not missing_from_tree and not not_on_disk:
        continue

    flat = not any(
        L.strip() and not ROW.match(L) and re.match(r'^[\s│]', L)
        for L in body
    )
    for nm in missing_from_tree:
        drift.append(f"{ctx}: tree omits {nm}" if flat
                     else f"{ctx}: tree omits {nm} — nested tree, place it by hand")
    for nm in not_on_disk:
        drift.append(f"{ctx}: tree lists {nm}, which is not on disk (resolve by hand)")

    # Only a FLAT block is safe to write into. In a nested tree the box-drawing
    # encodes parentage — inserting a top-level row after the last one lands it
    # between a parent and its children, and re-drawing the connectors correctly
    # means re-deriving a structure this tool deliberately does not own. Those are
    # reported for a human to place.
    if not flat or MODE != "write" or not missing_from_tree:
        continue

    # ── Insert the missing rows, matching the block's own column alignment ────
    # Align on where the block puts its ARROW, not where its whitespace starts — those
    # differ by however many spaces the widest row was padded with, and a row inserted on
    # the second measurement lands visibly short of the column it is meant to join.
    ann_col = max((L.index("←") if "←" in L else L.index("→")
                   for L in (body[p[0]] for p in parsed)
                   if "←" in L or "→" in L), default=0)
    if not ann_col:
        ann_col = max((p[3].start("rest") + 1 for p in parsed if p[3].group("rest")), default=0)
    last_idx = parsed[-1][0]
    branch_of_last = parsed[-1][3].group("branch")

    # The row carries a TODO annotation rather than nothing. A bare row reads as a
    # finished tree and gets committed; a TODO is a question the audit and the hook both
    # refuse to let past, which is the only reliable moment to ask for the why.
    new_rows = []
    for nm in missing_from_tree:
        row = f"├── {nm}"
        row = row.ljust(ann_col) if ann_col else row + " "
        new_rows.append(row + "← TODO: what this is and why it is here")

    # Keep "└──" on whatever ends up last.
    if branch_of_last.startswith("└"):
        body[last_idx] = body[last_idx].replace("└── ", "├── ", 1)
    body = body[:last_idx + 1] + new_rows + body[last_idx + 1:]
    for i in range(len(body) - 1, -1, -1):
        if ROW.match(body[i]):
            body[i] = body[i].replace("├── ", "└── ", 1)
            break

    lines[start + 1:end] = body
    ctx.write_text("\n".join(lines))
    wrote.append(f"{ctx}: added {', '.join(missing_from_tree)}")

# ── Report ────────────────────────────────────────────────────────────────────
if wrote:
    log("\033[1m▸ sync-trees.sh — updated\033[0m")
    for w in wrote:
        log(f"  · {w}")
    log("")
    log("  Each row was added carrying `← TODO: what this is and why it is here`.")
    log("  Replace every TODO before committing — a row that is accurate and says")
    log("  nothing is not orientation. `CONTEXT.md` answers what is here AND why.")

unresolved = [d for d in drift if "not on disk" in d] if MODE == "write" else drift
if unresolved:
    if not wrote:
        log("\033[1m▸ sync-trees.sh\033[0m")
    log("")
    log(f"\033[1m✗ {len(unresolved)} tree drift finding(s):\033[0m")
    for d in unresolved:
        log(f"  · {d}")
    sys.exit(1)

# Writing a TODO is not resolving it. Failing here is what makes the pre-commit hook ask
# for the description while the author still knows the answer.
if wrote:
    sys.exit(1)

log("\033[1m✓ Every CONTEXT.md tree matches its directory.\033[0m")
sys.exit(0)
PYEOF
