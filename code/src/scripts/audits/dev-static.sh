#!/usr/bin/env bash
#
# dev-static.sh — Verify the dev nginx hands /static/ to Django rather than to a host directory.
#
# The dev stack runs Django with DEBUG on and no collectstatic: the entrypoint skips it, so the
# finders serve every asset live through staticfiles_urlpatterns() (code/src/django/config/urls.py).
# That only works if nginx forwards /static/ to the django upstream. A dev.conf that answers
# /static/ itself — `alias` or `root` onto a mounted ../django/staticfiles — serves a gitignored
# directory nothing in dev fills, and every asset 404s. Nothing fails when it drifts back: the
# page still renders, unstyled. This script is what notices.
#
# Two files at fixed paths under code/src/docker/. Finding codes:
#
#   nginx/dev.conf
#     static-missing         no plain (or ^~) prefix `location /static/` block
#     static-no-proxy        a /static/ block has no `proxy_pass $django_upstream` as a DIRECT
#                            child — one only inside if() is conditional, so it does not count
#     static-alias           the dev nginx serves NOTHING from disk: any `alias` / `root`
#     static-root              anywhere in dev.conf — server level, any server block, any
#                              location under any modifier (a regex need never spell /static),
#                              inside if() — is a finding, reported once per directive
#     django-upstream-wrong  `set $django_upstream` is not exactly http://django:8000 — or is
#                            absent, which fails closed (nginx cannot proxy an unset variable)
#     conf-include           any `include` — its target cannot be evaluated statically
#     conf-missing / conf-unparseable
#   docker-compose.dev.yml
#     staticfiles-mount      the nginx service mounts something at /staticfiles (short or long form)
#     compose-volumes-unparseable  nginx `volumes:` is not a plain block sequence — anything inline
#                            on the key line (a flow list [...] or a *alias), a child line that is
#                            neither a `- ` item nor a long-syntax key of one (a flow list Prettier
#                            reflowed below the key), an item that is itself a flow node / alias,
#                            or a `<<:` merge key in the nginx service (it may carry volumes)
#     compose-missing / nginx-service-missing   (the key may be quoted or carry a # comment)
#
# FAILS CLOSED. A missing file, a dev.conf with no /static/ block, unbalanced braces, an include,
# an unreadable volumes value or merge key, or a compose file with no nginx service is a finding, never a clean
# run: the dev stack is not an optional surface, so its absence is not the absent-surface no-op.
# Test, staging and prod nginx configs are out of scope — they serve a collected tree on purpose.
#
# SELF-TEST. --self-test runs the detector over fixtures/dev-static/<case>/, each holding the
# same two relative paths and an expected.txt of the finding codes it must report. Fix the
# detector, never the fixtures.
#
# Usage: dev-static.sh [--output FORMAT] [--output-file PATH] [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = dev nginx proxies /static/ and mounts no staticfiles   1 = a finding
#              2 = script error (bad argument, no python3, self-test fixtures missing)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"
FIXTURES_DIR="$SCRIPT_DIR/fixtures/dev-static"
DOCKER_DIR="$PROJECT_ROOT/code/src/docker"

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
SELF_TEST=false

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'dev-static.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
dev-static.sh — Verify the dev nginx proxies /static/ to Django

Checks code/src/docker/nginx/dev.conf proxies every /static/ location to
$django_upstream with no alias or root, and that the nginx service in
code/src/docker/docker-compose.dev.yml mounts nothing at /staticfiles.

Usage:
  dev-static.sh                    Check and print the result
  dev-static.sh --output md        Write a report
  dev-static.sh --self-test        Prove the detector over fixtures/dev-static/

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
  --quiet              Suppress terminal output — requires --output
  --self-test          Run the detector over every fixtures/dev-static/<case>
  --help, -h           Show this help

There is no --path: two files at fixed paths are not a scope. Passing it exits 2.

Exit codes:
  0  clean
  1  a finding — including a missing or unparseable file (fails closed)
  2  script error

Fixing a finding: change the dev config, never the clause. Test, staging and prod
nginx configs are out of scope and serve a collected tree on purpose.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)      [[ $# -ge 2 ]] || die "--output needs a format"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file) [[ $# -ge 2 ]] || die "--output-file needs a path"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)       QUIET=true; shift ;;
    --self-test)   SELF_TEST=true; shift ;;
    --path)        die "--path is not supported: this audit reads two fixed files" ;;
    --help|-h)     usage; exit 0 ;;
    *)             die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
case "$OUTPUT_FORMAT" in
  ""|md|txt|json) ;;
  *) die "Unknown output format: $OUTPUT_FORMAT (use md, txt or json)" ;;
esac
command -v python3 >/dev/null 2>&1 || die "python3 is required"

# check_dir DOCKER_DIR — one finding per line on stdout, "CODE<TAB>message". Empty = clean.
# A crash in the parser is exit 2 from the caller, never an empty (clean) result.
check_dir() {
  python3 - "$1" <<'PY'
import os, re, sys
docker = sys.argv[1]
conf = os.path.join(docker, "nginx", "dev.conf")
compose = os.path.join(docker, "docker-compose.dev.yml")
UPSTREAM = "http://django:8000"
out = []
def f(code, msg): out.append(f"{code}\t{msg}")

# ── nginx/dev.conf ────────────────────────────────────────────────────────────
def tokenize(text):
    toks, i, n = [], 0, len(text)
    while i < n:
        c = text[i]
        if c.isspace(): i += 1
        elif c == "#":
            while i < n and text[i] != "\n": i += 1
        elif c in "{};": toks.append(c); i += 1
        elif c in "\"'":
            j = text.find(c, i + 1)
            if j < 0: raise ValueError("unterminated quote")
            toks.append(text[i + 1:j]); i = j + 1
        else:
            j = i
            while j < n and not text[j].isspace() and text[j] not in "{};#": j += 1
            toks.append(text[i:j]); i = j
    return toks

def parse(toks):
    # -> list of (args, children|None); raises on unbalanced input.
    stack, cur, words = [], [], []
    for t in toks:
        if t == ";":
            if not words: raise ValueError("empty directive")
            cur.append((words, None)); words = []
        elif t == "{":
            if not words: raise ValueError("block with no name")
            node = (words, []); cur.append(node); stack.append(cur); cur = node[1]; words = []
        elif t == "}":
            if words or not stack: raise ValueError("unbalanced '}'")
            cur = stack.pop()
        else: words.append(t)
    if stack or words: raise ValueError("unbalanced '{' or unterminated directive")
    return cur

def walk(nodes):
    for args, kids in nodes:
        yield args, kids
        if kids is not None: yield from walk(kids)

if not os.path.isfile(conf):
    f("conf-missing", "nginx/dev.conf: absent — the dev proxy cannot be checked")
else:
    try:
        tree = parse(tokenize(open(conf, encoding="utf-8").read()))
    except ValueError as e:
        tree = None
        f("conf-unparseable", f"nginx/dev.conf: does not parse ({e})")
    if tree is not None:
        nodes = list(walk(tree))

        # An include pulls in config this script never sees — it may add a /static location.
        for a, _ in nodes:
            if a[0] == "include":
                f("conf-include", f"nginx/dev.conf: `include {' '.join(a[1:])}` cannot be evaluated statically — inline it")

        # $django_upstream must point at the django service. Missing is the same finding: the
        # proxy then resolves to nothing (nginx refuses an unset variable in proxy_pass).
        sets = [a for a, k in nodes if k is None and a[0] == "set" and len(a) >= 2 and a[1] == "$django_upstream"]
        if not sets:
            f("django-upstream-wrong", f"nginx/dev.conf: no `set $django_upstream {UPSTREAM};`")
        for a in sets:
            if len(a) != 3 or a[2] != UPSTREAM:
                f("django-upstream-wrong", f"nginx/dev.conf: `set $django_upstream {' '.join(a[2:])}` is not {UPSTREAM}")

        # The /static/ block proper: a plain or ^~ prefix location on exactly /static or /static/.
        canonical = [(a, k) for a, k in nodes
                     if k is not None and a[0] == "location"
                     and (len(a) == 2 or (len(a) == 3 and a[1] == "^~")) and a[-1].rstrip("/") == "/static"]
        if not canonical:
            f("static-missing", "nginx/dev.conf: no `location /static/` block — Django's finders are never reached explicitly")
        for a, kids in canonical:
            # A direct child only: a proxy_pass inside if() is conditional, so it is no proxy.
            if not any(c[0] == "proxy_pass" and len(c) == 2 and c[1] == "$django_upstream"
                       for c, ck in kids if ck is None):
                f("static-no-proxy", f"nginx/dev.conf: `location {' '.join(a[1:])}` does not proxy_pass $django_upstream as a direct directive")

        # The dev nginx serves nothing from disk, at all. Every alias/root anywhere — server level,
        # any server block, any location under any modifier (a regex need never spell /static),
        # inside if() — is a finding, reported once per directive with the block it sits in.
        def disk(nodes, where):
            for a, k in nodes:
                if k is None:
                    if a[0] in ("alias", "root"): yield a[0], where
                else:
                    yield from disk(k, " ".join(a))
        for name, where in disk(tree, "top level"):
            f(f"static-{name}", f"nginx/dev.conf: `{name}` in `{where}` serves from disk — the dev nginx must serve nothing from disk")

# ── docker-compose.dev.yml ────────────────────────────────────────────────────
# Stdlib only (no PyYAML): an indentation walk over services -> nginx -> volumes, covering the
# short "src:target[:mode]" form and the long "target:" form.
def indent(l): return len(l) - len(l.lstrip(" "))
if not os.path.isfile(compose):
    f("compose-missing", "docker-compose.dev.yml: absent — the nginx mounts cannot be checked")
else:
    lines = [l.rstrip("\n") for l in open(compose, encoding="utf-8")]
    lines = [l for l in lines if l.strip() and not l.lstrip().startswith("#")]
    def child_block(start, parent_indent):
        blk = []
        for l in lines[start:]:
            if indent(l) <= parent_indent: break
            blk.append(l)
        return blk
    svc_i = next((i for i, l in enumerate(lines) if indent(l) == 0 and l.strip() == "services:"), None)
    nginx = None
    if svc_i is not None:
        svc = child_block(svc_i + 1, 0)
        if svc:
            key_indent = indent(svc[0])
            for i, l in enumerate(svc):
                if indent(l) == key_indent and re.fullmatch(r"""(nginx|"nginx"|'nginx'):\s*(#.*)?""", l.strip()):
                    nginx = [x for x in svc[i + 1:]]
                    nginx = nginx[:next((k for k, x in enumerate(nginx) if indent(x) <= key_indent), len(nginx))]
                    break
    if nginx is None:
        f("nginx-service-missing", "docker-compose.dev.yml: no `services: nginx:` — the dev proxy service cannot be checked")
    else:
        targets = []
        # Only the nginx service's own keys (its first child indent), never a nested `volumes:`.
        ki = indent(nginx[0]) if nginx else 0
        vol = None
        for k, l in enumerate(nginx):
            if indent(l) != ki: continue
            # A merge key pulls keys (volumes among them) from an anchor this walk cannot resolve.
            if re.match(r"""(<<|"<<"|'<<'):""", l.strip()):
                f("compose-volumes-unparseable", f"docker-compose.dev.yml: nginx `{l.strip()}` merges keys from an anchor — inline the nginx service instead")
                continue
            m = re.match(r"volumes:(.*)$", l.strip())
            if m:
                inline = re.sub(r"\s+#.*$", "", m.group(1)).strip()
                if inline:
                    # A flow list ([...]) or an alias (*vols) — not readable by this block walk.
                    f("compose-volumes-unparseable", f"docker-compose.dev.yml: nginx `volumes: {inline}` is not a block sequence — write one `- src:target` per line")
                else:
                    vol = k
                break
        if vol is not None:
            vi = indent(nginx[vol])
            item = None  # indent of the current `- ` item, so its long-syntax keys are accepted
            for l in nginx[vol + 1:]:
                if indent(l) <= vi: break
                s = l.strip()
                # Only block-sequence items and the mapping lines of a long-syntax item are
                # readable. Anything else — a flow list Prettier reflowed onto the next lines, an
                # item that is itself an alias / flow node — fails closed rather than reads clean.
                if s == "-" or s.startswith("- "):
                    item = indent(l)
                    if s[1:].strip()[:1] in ("[", "{", "*"):
                        f("compose-volumes-unparseable", f"docker-compose.dev.yml: nginx volume item `{s}` is a flow node or alias — write it out in block form")
                elif not (item is not None and indent(l) > item and re.match(r"[\w-]+:(\s|$)", s)):
                    f("compose-volumes-unparseable", f"docker-compose.dev.yml: nginx `volumes:` line `{s}` is not a block-sequence item — write one `- src:target` per line")
                    break
                if s.startswith("- ") and ":" in s and not re.match(r"-\s+\w+:\s", s):
                    parts = s[2:].strip().strip("\"'").split(":")
                    if len(parts) >= 2: targets.append(parts[1])
                m = re.match(r"(?:-\s+)?target:\s*[\"']?([^\"'\s]+)", s)
                if m: targets.append(m.group(1))
        for t in targets:
            if t.rstrip("/") == "/staticfiles" or t.startswith("/staticfiles/"):
                f("staticfiles-mount", f"docker-compose.dev.yml: nginx mounts {t} — dev nginx must not serve a host staticfiles dir")
print("\n".join(out))
PY
}

# ── Self-test ─────────────────────────────────────────────────────────────────
run_self_test() {
  local dir name raw actual expected failed=0 cases=0
  [[ -d "$FIXTURES_DIR" ]] || die "self-test fixtures missing: fixtures/dev-static/"
  for name in broken fixed; do
    [[ -f "$FIXTURES_DIR/$name/expected.txt" ]] || die "self-test fixture missing: fixtures/dev-static/$name"
  done
  bold "▸ dev-static.sh --self-test"
  for dir in "$FIXTURES_DIR"/*/; do
    name="$(basename "$dir")"
    [[ -f "$dir/expected.txt" ]] || die "self-test fixture missing: fixtures/dev-static/$name/expected.txt"
    cases=$((cases + 1))
    # Capture first: a crashed detector prints nothing, which must never read as clean.
    raw="$(check_dir "$dir")" || die "the detector failed to run on fixtures/dev-static/$name"
    actual="$(printf '%s\n' "$raw" | cut -f1 | grep . | sort || true)"
    expected="$(grep -v '^#' "$dir/expected.txt" | grep . | sort || true)"
    if [[ "$actual" == "$expected" ]]; then
      log "  ✓ $name: $(printf '%s' "${expected:-clean}" | tr '\n' ' ')"
    else
      failed=1
      log "  ✗ $name reported something other than expected.txt:"
      diff <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") | sed 's/^/      /' || true
    fi
  done
  log "  $cases case(s)"
  if [[ $failed -eq 0 ]]; then
    bold "✓ Self-test passed — the detector separates the broken dev proxy from the fixed one."
    exit 0
  fi
  bold "✗ Self-test FAILED — fix the detector, never the fixtures."
  exit 1
}

$SELF_TEST && run_self_test

bold "▸ dev-static.sh"
log "  checking code/src/docker/nginx/dev.conf and code/src/docker/docker-compose.dev.yml…"
log ""

RESULT="$(check_dir "$DOCKER_DIR")" || die "the config check failed to run"

declare -a FINDINGS=()
while IFS= read -r line; do
  [[ -n "$line" ]] && FINDINGS+=("${line#*$'\t'}")
done <<<"$RESULT"

if (( ${#FINDINGS[@]} == 0 )); then
  log "  dev nginx proxies /static/ to \$django_upstream and mounts no staticfiles"
else
  for f in "${FINDINGS[@]}"; do log "  ✗ $f"; done
fi
log ""

if [[ -n "$OUTPUT_FORMAT" ]]; then
  mkdir -p "$REPORTS_DIR"
  [[ -n "$OUTPUT_FILE" ]] || OUTPUT_FILE="$REPORTS_DIR/dev-static-report.$OUTPUT_FORMAT"
  {
    case "$OUTPUT_FORMAT" in
      json)
        printf '{"findings": %s}\n' \
          "$(printf '%s\n' "${FINDINGS[@]+"${FINDINGS[@]}"}" | python3 -c 'import json,sys;print(json.dumps([l for l in sys.stdin.read().splitlines() if l]))')"
        ;;
      md)
        printf '# dev-static\n\n'
        (( ${#FINDINGS[@]} == 0 )) && printf 'Dev nginx proxies /static/ to %s and mounts no staticfiles.\n' "\$django_upstream"
        for f in "${FINDINGS[@]+"${FINDINGS[@]}"}"; do printf -- '- %s\n' "$f"; done
        ;;
      txt)
        for f in "${FINDINGS[@]+"${FINDINGS[@]}"}"; do printf '%s\n' "$f"; done
        ;;
    esac
  } >"$OUTPUT_FILE"
  log "  report: ${OUTPUT_FILE#"$PROJECT_ROOT"/}"
fi

if (( ${#FINDINGS[@]} > 0 )); then
  printf '\033[31m✗ %s finding(s) — dev /static/ is not served by Django\033[0m\n' "${#FINDINGS[@]}"
  exit 1
fi
bold "✓ dev-static clean"
