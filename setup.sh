#!/usr/bin/env bash
#
# setup.sh — instantiate this base template into a concrete project.
#
# Reads the token contract in how-to/src/TEMPLATE-TOKENS.md, prompts for each
# token, substitutes every {{TOKEN}} across all docs and configuration, rewrites
# residual bare literals in application source, stamps the {{DATE}}, and verifies
# that no token survives. Idempotent-ish: re-running after a successful pass finds
# nothing to replace.
#
# Usage:
#   bash setup.sh            # interactive
#   bash setup.sh --yes      # accept all defaults (non-interactive; CI/testing)
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

MANIFEST="how-to/src/TEMPLATE-TOKENS.md"
ASSUME_YES=0
[[ "${1:-}" == "--yes" || "${1:-}" == "-y" ]] && ASSUME_YES=1

# Paths never touched by substitution.
PRUNE=(.git node_modules .venv venv staticfiles .next dist build)

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
warn() { printf '\033[33m! %s\033[0m\n' "$*" >&2; }
die()  { printf '\033[31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

# prompt VAR "Question" "default" "validation-regex (optional)"
prompt() {
  local __var="$1" __q="$2" __default="${3:-}" __re="${4:-}" __val=""
  while true; do
    if [[ "$ASSUME_YES" == "1" ]]; then
      __val="$__default"
    else
      if [[ -n "$__default" ]]; then
        read -r -p "$__q [$__default]: " __val || true
        __val="${__val:-$__default}"
      else
        read -r -p "$__q: " __val || true
      fi
    fi
    if [[ -z "$__val" ]]; then
      warn "A value is required."
      [[ "$ASSUME_YES" == "1" ]] && die "no value or default for a required token — cannot run --yes"
      continue
    fi
    if [[ -n "$__re" && ! "$__val" =~ $__re ]]; then
      warn "'$__val' does not match expected format ($__re)."; [[ "$ASSUME_YES" == "1" ]] && die "bad default"; continue
    fi
    printf -v "$__var" '%s' "$__val"
    break
  done
}

upper_snake() { printf '%s' "$1" | tr '[:lower:]-' '[:upper:]_'; }

[[ -f "$MANIFEST" ]] || die "Token manifest not found: $MANIFEST"

bold "Base-template setup — see $MANIFEST for the full token contract."
echo

# ── Identity ────────────────────────────────────────────────────────────────
prompt PROJECT_NAME  "Project / product display name"       ""              ''
prompt PROJECT_SLUG  "Project slug (kebab-case)"            ""              '^[a-z0-9]([a-z0-9-]*[a-z0-9])?$'
prompt ORG_NAME      "Organisation / maintainer name"       ""              ''
prompt ORG_SLUG      "Organisation slug (kebab-case)"       ""              '^[a-z0-9]([a-z0-9-]*[a-z0-9])?$'

# ── Infrastructure ───────────────────────────────────────────────────────────
prompt PRIMARY_DOMAIN "Primary apex domain"                 "${PROJECT_SLUG}.com" '^[a-z0-9.-]+\.[a-z]{2,}$'
prompt DEPLOY_REPO    "NixOS deploy repo name"              "${PROJECT_SLUG}-nixos-client-deployment" ''
prompt SERVER_TIER    "Server tier (host + spec)"           "TBD — set on provisioning" ''
prompt ENV_PREFIX     "Env-var / namespace prefix (UPPER)"  "$(upper_snake "$ORG_SLUG")" '^[A-Z][A-Z0-9_]*$'

# ── Locale, licence, people ──────────────────────────────────────────────────
prompt LOCALE         "Default locale"                      "en_GB"         '^[a-z]{2}_[A-Z]{2}$'
prompt TIMEZONE       "Default timezone (IANA)"             "Europe/London" '^[A-Za-z]+/[A-Za-z_]+$'
prompt CURRENCY       "Default currency (ISO 4217)"         "GBP"           '^[A-Z]{3}$'
prompt LICENCE        "Source licence"                      "Proprietary — all rights reserved" ''
prompt DEVELOPER_NAME "Lead developer name"                 ""              ''
prompt DEVELOPER_EMAIL "Lead developer email"               ""              '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$'

# ── Django apps ──────────────────────────────────────────────────────────────
# Only the app NAMES are tokenised; the layout (code/src/django/apps/<app>/) is
# fixed. Defaults are the conventional names — accept them unless this project
# calls the app something else. apps.marketing / apps.seo / apps.design_tokens
# are house constants and are never tokenised.
APP_RE='^[a-z][a-z0-9_]*$'
prompt IDENTITY_APP      "App owning users / credentials / sessions" "users"         "$APP_RE"
prompt AUDIT_APP         "App owning the audit / event log"          "audit"         "$APP_RE"
prompt CONTENT_APP       "App owning user-authored content"          "content"       "$APP_RE"
prompt NOTIFICATIONS_APP "App owning notifications"                  "notifications" "$APP_RE"
prompt LEGAL_APP         "App owning cookie consent / legal pages"   "legal"         "$APP_RE"
prompt CORE_APP          "App owning shared primitives (encryption)" "core"          "$APP_RE"

# ── Meta ─────────────────────────────────────────────────────────────────────
DATE="$(date +%d/%m/%Y)"

echo
bold "Summary"
cat <<EOF
  {{PROJECT_NAME}}    = $PROJECT_NAME
  {{PROJECT_SLUG}}    = $PROJECT_SLUG
  {{ORG_NAME}}        = $ORG_NAME
  {{ORG_SLUG}}        = $ORG_SLUG
  {{PRIMARY_DOMAIN}}  = $PRIMARY_DOMAIN
  {{DEPLOY_REPO}}     = $DEPLOY_REPO
  {{SERVER_TIER}}     = $SERVER_TIER
  {{ENV_PREFIX}}      = $ENV_PREFIX
  {{LOCALE}}          = $LOCALE
  {{TIMEZONE}}        = $TIMEZONE
  {{CURRENCY}}        = $CURRENCY
  {{LICENCE}}         = $LICENCE
  {{DEVELOPER_NAME}}  = $DEVELOPER_NAME
  {{DEVELOPER_EMAIL}} = $DEVELOPER_EMAIL
  {{DATE}}            = $DATE

  Django apps (apps.marketing / apps.seo / apps.design_tokens stay literal)
  {{IDENTITY_APP}}      = $IDENTITY_APP
  {{AUDIT_APP}}         = $AUDIT_APP
  {{CONTENT_APP}}       = $CONTENT_APP
  {{NOTIFICATIONS_APP}} = $NOTIFICATIONS_APP
  {{LEGAL_APP}}         = $LEGAL_APP
  {{CORE_APP}}          = $CORE_APP
EOF
echo
if [[ "$ASSUME_YES" != "1" ]]; then
  read -r -p "Proceed with substitution? [y/N]: " ok || true
  [[ "${ok:-}" =~ ^[Yy]$ ]] || die "Aborted."
fi

# ── File selection ───────────────────────────────────────────────────────────
build_find() {
  # Prints NUL-separated paths of regular files, excluding pruned dirs.
  local expr=()
  for p in "${PRUNE[@]}"; do expr+=( -path "./$p" -prune -o ); done
  find . "${expr[@]}" -type f -print0
}

# replace_token TOKEN VALUE  [glob-of-extensions-to-limit | ""]
# Substitutes literal {{TOKEN}} → VALUE across all non-pruned text files.
replace_token() {
  local token="$1" value="$2"
  while IFS= read -r -d '' f; do
    case "$f" in ./setup.sh|"./$MANIFEST") continue;; esac
    if grep -qF "$token" "$f" 2>/dev/null; then
      TOKEN="$token" VALUE="$value" perl -0777 -i -pe \
        'BEGIN{$t=$ENV{TOKEN};$v=$ENV{VALUE}} s/\Q$t\E/$v/g' "$f"
    fi
  done < <(build_find)
}

bold "Substituting tokens…"
replace_token '{{PROJECT_NAME}}'    "$PROJECT_NAME"
replace_token '{{PROJECT_SLUG}}'    "$PROJECT_SLUG"
replace_token '{{ORG_NAME}}'        "$ORG_NAME"
replace_token '{{ORG_SLUG}}'        "$ORG_SLUG"
replace_token '{{PRIMARY_DOMAIN}}'  "$PRIMARY_DOMAIN"
replace_token '{{DEPLOY_REPO}}'     "$DEPLOY_REPO"
replace_token '{{SERVER_TIER}}'     "$SERVER_TIER"
replace_token '{{ENV_PREFIX}}'      "$ENV_PREFIX"
replace_token '{{LOCALE}}'          "$LOCALE"
replace_token '{{TIMEZONE}}'        "$TIMEZONE"
replace_token '{{CURRENCY}}'        "$CURRENCY"
replace_token '{{LICENCE}}'         "$LICENCE"
replace_token '{{DEVELOPER_NAME}}'  "$DEVELOPER_NAME"
replace_token '{{DEVELOPER_EMAIL}}' "$DEVELOPER_EMAIL"
replace_token '{{DATE}}'            "$DATE"
replace_token '{{IDENTITY_APP}}'      "$IDENTITY_APP"
replace_token '{{AUDIT_APP}}'         "$AUDIT_APP"
replace_token '{{CONTENT_APP}}'       "$CONTENT_APP"
replace_token '{{NOTIFICATIONS_APP}}' "$NOTIFICATIONS_APP"
replace_token '{{LEGAL_APP}}'         "$LEGAL_APP"
replace_token '{{CORE_APP}}'          "$CORE_APP"

# ── Residual bare literals in application source ─────────────────────────────
# Source (.py/.html/.tsx/.css/.ts) is not {{ }}-tokenised. Map its bare literals.
# `projectname` is almost always the project slug there; `ProjectName` the name.
bold "Rewriting residual bare literals in application source…"
src_hits=$(grep -rlE 'projectname|ProjectName' \
  --include='*.py' --include='*.html' --include='*.tsx' --include='*.ts' --include='*.css' \
  code/src 2>/dev/null || true)
if [[ -n "$src_hits" ]]; then
  if [[ "$ORG_SLUG" != "$PROJECT_SLUG" ]]; then
    warn "org slug ($ORG_SLUG) ≠ project slug ($PROJECT_SLUG):"
    warn "  bare 'projectname' in source is mapped to the PROJECT slug; review org-namespace hits by hand."
  fi
  while IFS= read -r f; do
    PS="$PROJECT_SLUG" PN="$PROJECT_NAME" perl -i -pe \
      'BEGIN{$ps=$ENV{PS};$pn=$ENV{PN}} s/ProjectName/$pn/g; s/projectname/$ps/g' "$f"
  done <<< "$src_hits"
fi

# ── Verify ───────────────────────────────────────────────────────────────────
# Check only for the KNOWN registry tokens — source legitimately contains other
# {{…}} patterns (Python f-string escapes, Django template variables, JS literals).
bold "Verifying no registry tokens survive…"
TOKEN_RE='\{\{(PROJECT_NAME|PROJECT_SLUG|ORG_NAME|ORG_SLUG|PRIMARY_DOMAIN|DEPLOY_REPO|SERVER_TIER|ENV_PREFIX|LOCALE|TIMEZONE|CURRENCY|LICENCE|DEVELOPER_NAME|DEVELOPER_EMAIL|DATE|IDENTITY_APP|AUDIT_APP|CONTENT_APP|NOTIFICATIONS_APP|LEGAL_APP|CORE_APP)\}\}'
survivors=$(
  while IFS= read -r -d '' f; do
    case "$f" in ./setup.sh|"./$MANIFEST") continue;; esac
    grep -HnE "$TOKEN_RE" "$f" || true
  done < <(build_find)
)
if [[ -n "$survivors" ]]; then
  warn "Unsubstituted tokens remain:"
  printf '%s\n' "$survivors" | head -40
  die "Substitution incomplete — resolve the tokens above (add them to setup.sh) and re-run."
fi

# ── Generate the Python lockfile ─────────────────────────────────────────────
# The template deliberately ships NO uv.lock. A lock pins the root project by
# name, and until this script runs that name is the literal `{{PROJECT_SLUG}}` —
# not a valid PEP 508 name — so no lock can be generated against the unrendered
# template, and a shipped one would only carry the previous project's name.
# Every Dockerfile does `COPY pyproject.toml uv.lock ./` and builds with
# `uv sync --frozen`, so the lock must exist before the first
# `server.sh up --build`. Generate it now, from the rendered pyproject.toml.
bold "Generating the Python lockfile for '$PROJECT_SLUG'…"

# The template gitignores uv.lock so a stale, wrongly-named lock can never be committed
# during template development. An instantiated project is the opposite case: it MUST
# commit the lock or `uv sync --frozen` has nothing to build from. Drop the rule here.
if grep -qE '^uv\.lock$' .gitignore 2>/dev/null; then
  perl -0777 -i -pe 's/^# Python lockfile — BASE TEMPLATE ONLY\.\n(?:#.*\n)*uv\.lock\n\n//m' .gitignore
  grep -qE '^uv\.lock$' .gitignore && warn "could not un-ignore uv.lock — remove the rule from .gitignore by hand." \
    || echo "  .gitignore: uv.lock rule removed (an instantiated project commits its lock)."
fi

if command -v uv > /dev/null 2>&1; then
  if uv lock; then
    echo "  uv.lock created — commit it with the instantiation."
  else
    warn "uv lock failed. No lockfile exists, so the Docker build will fail on"
    warn "'COPY pyproject.toml uv.lock'. Fix pyproject.toml and run:"
    warn "  uv lock"
  fi
else
  warn "uv is not installed, so no uv.lock was created."
  warn "The Docker build will fail on 'COPY pyproject.toml uv.lock' until you run:"
  warn "  uv lock     # install uv first: https://docs.astral.sh/uv/"
fi

echo
bold "Done. '$PROJECT_NAME' instantiated from the base template."
echo "Next: run /scale-planning to regenerate the SCALE-ARCHITECTURE and SERVER-ARCHITECTURE snapshots."
echo "Then delete this script and $MANIFEST once you're satisfied: git rm setup.sh $MANIFEST"
