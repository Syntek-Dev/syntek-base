#!/usr/bin/env bash
#
# posture-guard.sh — the deployment-posture guard for the destructive dev scripts.
#
# Sourced, never executed. Functions only; nothing runs on source except loading the shared
# conflict-marker pattern, so sourcing twice is harmless. Every public name is `posture_`.
#
# CONTRACT
#   posture_guard ROOT MODE OVERRIDE COMPOSE_NAME [INVOCATION WORD...]
#     ROOT          absolute repository root — the caller's BASH_SOURCE-derived PROJECT_ROOT.
#                   Never cwd, never an environment variable: the carrier and the template
#                   proof are both anchored here, and the self-test aims it at a fixture.
#     MODE          refuse | warn. The refuse-versus-warn policy lives here, not in callers.
#     OVERRIDE      the value the caller parsed from --force-posture, or "".
#     COMPOSE_NAME  the `name:` of the LAST compose file in the caller's set (the worktree
#                   override outranks the base file's).
#     INVOCATION    the caller's own command words, so a refusal prints a re-run to paste.
#   Returns 0 to permit and 4 to refuse; never calls `exit`. A refusal goes to stderr with
#   the greppable prefix "posture-guard: refused —". This is a new return contract for
#   _lib/: most helpers here return 0 and signal on stdout.
#
#   Outputs, cleared at EVERY entry so no earlier call's verdict can be reused:
#     posture_resolved      development | staging | production, or "" when none is readable
#     posture_endpoint      the validated unix:/// Docker endpoint, or ""
#     posture_target_valid  "1" only after a successful target check, else ""
#     posture_docker        array — filled only by posture_docker_bind
#   A refusal in refuse mode also clears the binding: a refused verdict hands out nothing.
#
#   posture_docker_bind
#     Fills posture_docker with a docker invocation pinned to posture_endpoint — explicit
#     --host, DOCKER_CONTEXT and DOCKER_HOST removed from its environment — so the caller's
#     later calls cannot re-resolve the target. Returns 4 and leaves the array empty when no
#     validated endpoint exists; a warn-mode conversion never manufactures one.
#
# THE VERDICT ORDER IS THE CONTROL
#   1 the override is validated before anything is read;
#   2 the carrier (.copier-answers.yml) is read ONCE into exactly one state;
#   3 the effective Docker target must be one unambiguous local unix socket, at every posture
#     — neither the override nor the template exemption can waive it;
#   4 a legal posture decides: development permits, staging/production only when the
#     override names it;
#   5 no legal posture: copier.yml at ROOT proves the template and permits; otherwise refuse
#     with the repair, the override NOT honoured — there is no live posture for it to name;
#   6 warn mode turns every refusal into a warning and a 0.
#   The posture is read from the carrier only. An exported variable of the carrier's key
#   name is never consulted — that would be a second override channel.

# Sourced by an absolute path in every caller; a bare relative name (no slash) is resolved
# against the current directory instead of being mistaken for a directory itself.
# shellcheck source=code/src/scripts/_lib/conflict-markers.sh
if [[ "${BASH_SOURCE[0]}" == */* ]]; then source "${BASH_SOURCE[0]%/*}/conflict-markers.sh"
else source ./conflict-markers.sh
fi

posture_say() { printf 'posture-guard: %s — %s\n' "$1" "$2" >&2; }

# printf %q, so a hostile value cannot write terminal escapes into the refusal.
posture_quote() { printf '%q' "$1"; }

# ── Docker metadata seam ─────────────────────────────────────────────────────
# Local metadata only: `docker context` reads the context store under the Docker config
# directory and contacts no daemon. The self-test redefines these two after sourcing.
posture_context_names() {
  env -u DOCKER_HOST -u DOCKER_CONTEXT docker context ls --format '{{.Name}}' 2>/dev/null
}
posture_context_endpoint() {
  env -u DOCKER_HOST -u DOCKER_CONTEXT \
    docker context inspect --format '{{.Endpoints.docker.Host}}' -- "$1" 2>/dev/null
}

# ── Step 2: the carrier ──────────────────────────────────────────────────────
# Sets posture_carrier_state to exactly one of: absent unreadable conflict no-key commented
# duplicated unrecognised legal — and posture_resolved when legal.
posture_read_carrier() {
  local file="$1/.copier-answers.yml" content line value="" keys=0 comments=0 odd=0
  local sq="^'([a-z]+)'\$" dq='^"([a-z]+)"$' bare='^[a-z]+$'
  # Any top-level line YAML reads as this key: an optionally quoted key, optional space before
  # the colon. Only the canonical spelling (bare key, colon, then space or end) yields a value;
  # every other spelling still counts, so a second one cannot hide behind the first.
  local anykey="^[\"']?DEPLOYMENT_POSTURE[\"']?[[:space:]]*:" canon='^DEPLOYMENT_POSTURE:([[:space:]]|$)'
  posture_carrier_state=""
  if [[ ! -e "$file" && ! -L "$file" ]]; then posture_carrier_state=absent; return 0; fi
  # The single read. Everything below inspects this copy, never the file again.
  if [[ ! -f "$file" ]] || ! content="$(cat -- "$file" 2>/dev/null)"; then
    posture_carrier_state=unreadable; return 0
  fi
  # The shared detector, fed the copy; the raw pattern as well, because the shared scan
  # honours a suppression directive and a carrier has no business carrying one.
  if [[ -n "$(conflict_markers_scan /dev/stdin <<<"$content")" || "$content" =~ $CONFLICT_MARKER_RE ]]; then
    posture_carrier_state=conflict; return 0
  fi
  while IFS= read -r line; do
    line="${line%$'\r'}"
    if [[ "$line" =~ $anykey ]]; then
      keys=$((keys + 1))
      if [[ "$line" =~ $canon ]]; then value="${line#DEPLOYMENT_POSTURE:}"; else odd=1; fi
    elif [[ "$line" =~ ^[[:space:]]*#[[:space:]]*DEPLOYMENT_POSTURE[[:space:]]*: ]]; then
      comments=$((comments + 1))
    fi
  done <<<"$content"
  if (( keys == 0 )); then
    if (( comments > 0 )); then posture_carrier_state=commented; else posture_carrier_state=no-key; fi
    return 0
  fi
  if (( keys > 1 )); then posture_carrier_state=duplicated; return 0; fi
  if (( odd )); then posture_carrier_state=unrecognised; return 0; fi
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  # Quote-tolerant; anything else — an inline comment included — is not a value we accept.
  if [[ "$value" =~ $sq || "$value" =~ $dq ]]; then value="${BASH_REMATCH[1]}"
  elif [[ ! "$value" =~ $bare ]]; then value=""
  fi
  case "$value" in
    development|staging|production) posture_carrier_state=legal; posture_resolved="$value" ;;
    *) posture_carrier_state=unrecognised ;;
  esac
}

posture_carrier_reason() {
  case "$1" in
    absent)       printf '.copier-answers.yml does not exist at the repository root' ;;
    unreadable)   printf '.copier-answers.yml exists but cannot be read' ;;
    conflict)     printf '.copier-answers.yml carries unresolved merge conflict markers' ;;
    no-key)       printf '.copier-answers.yml has no DEPLOYMENT_POSTURE line' ;;
    commented)    printf '.copier-answers.yml has DEPLOYMENT_POSTURE only in a commented line' ;;
    duplicated)   printf '.copier-answers.yml sets DEPLOYMENT_POSTURE more than once' ;;
    unrecognised) printf '.copier-answers.yml holds an unrecognised DEPLOYMENT_POSTURE value or key spelling' ;;
    *)            printf '.copier-answers.yml is in an unexpected state' ;;
  esac
}

# ── Step 3: the effective Docker target ──────────────────────────────────────
# Precedence per the story plan (09/10/2026): DOCKER_CONTEXT, then DOCKER_HOST, then the
# saved currentContext, then Docker's default context. Docker's own CLI lets DOCKER_HOST win
# when both are set, so a pair that disagrees is refused as ambiguous rather than guessed.
# Every failure sets posture_target_reason; "unknown" is never a local fallback.
posture_context_to_endpoint() {
  local name="$1" origin="$2" names out
  posture_candidate=""
  if [[ "$name" == default ]]; then
    posture_candidate="${DOCKER_HOST:-unix:///var/run/docker.sock}"; return 0
  fi
  if [[ ! "$name" =~ ^[A-Za-z0-9][A-Za-z0-9_.+-]*$ ]]; then
    posture_target_reason="$origin $(posture_quote "$name") is not a valid Docker context name"; return 1
  fi
  if ! names="$(posture_context_names)"; then
    posture_target_reason="the Docker context store could not be listed"; return 1
  fi
  if ! grep -qxF -- "$name" <<<"$names"; then
    posture_target_reason="$origin $(posture_quote "$name") is an unknown Docker context"; return 1
  fi
  if ! out="$(posture_context_endpoint "$name")"; then
    posture_target_reason="inspection of $origin $(posture_quote "$name") failed"; return 1
  fi
  if [[ -z "$out" ]]; then
    posture_target_reason="$origin $(posture_quote "$name") has no Docker endpoint"; return 1
  fi
  if [[ "$out" == *$'\n'* ]]; then
    posture_target_reason="$origin $(posture_quote "$name") reports more than one endpoint"; return 1
  fi
  posture_candidate="$out"
}

# The saved selection in the effective config.json. Sets posture_saved ("" = none saved).
# Parsed by hand because jq is not a dependency; anything not plainly one top-level string
# is malformed, which fails closed. Docker decodes keys with Go's encoding/json, which matches
# them case-insensitively and honours \u escapes, so the key is counted case-folded and any
# \u escape in the file is refused rather than decoded.
posture_saved_context() {
  local dir file content rest count=0
  local re='"[cC][uU][rR][rR][eE][nN][tT][cC][oO][nN][tT][eE][xX][tT]"[[:space:]]*:[[:space:]]*"([^"\\]*)"'
  posture_saved=""
  if [[ -n "${DOCKER_CONFIG:-}" ]]; then dir="$DOCKER_CONFIG"
  elif [[ -n "${HOME:-}" ]]; then dir="$HOME/.docker"
  else posture_target_reason="the Docker configuration directory cannot be located"; return 1
  fi
  file="$dir/config.json"
  if [[ ! -e "$file" && ! -L "$file" ]]; then return 0; fi
  if [[ ! -f "$file" ]] || ! content="$(cat -- "$file" 2>/dev/null)"; then
    posture_target_reason="the Docker configuration $(posture_quote "$file") cannot be read"; return 1
  fi
  rest="${content#"${content%%[![:space:]]*}"}"; rest="${rest%"${rest##*[![:space:]]}"}"
  if [[ "$rest" != \{*\} ]]; then
    posture_target_reason="the Docker configuration $(posture_quote "$file") is malformed"; return 1
  fi
  if [[ "$rest" == *'\u'* ]]; then
    posture_target_reason="the Docker configuration $(posture_quote "$file") is malformed (escaped characters are not decoded here)"; return 1
  fi
  rest="${rest,,}"
  while [[ "$rest" == *'"currentcontext"'* ]]; do
    count=$((count + 1)); rest="${rest#*\"currentcontext\"}"
  done
  (( count == 0 )) && return 0
  if (( count > 1 )) || [[ ! "$content" =~ $re ]]; then
    posture_target_reason="the Docker configuration $(posture_quote "$file") is malformed"; return 1
  fi
  posture_saved="${BASH_REMATCH[1]}"
}

posture_resolve_target() {
  local compose_name="$1" endpoint path origin
  local ctx="${DOCKER_CONTEXT:-}" host="${DOCKER_HOST:-}" cpn="${COMPOSE_PROJECT_NAME:-}"
  posture_target_reason=""
  posture_candidate=""
  if [[ -n "$ctx" ]]; then
    origin="DOCKER_CONTEXT"
    posture_context_to_endpoint "$ctx" "DOCKER_CONTEXT" || return 1
    endpoint="$posture_candidate"
    if [[ -n "$host" && "$host" != "$endpoint" ]]; then
      posture_target_reason="DOCKER_CONTEXT and DOCKER_HOST are both set and disagree"; return 1
    fi
  elif [[ -n "$host" ]]; then
    origin="DOCKER_HOST"; endpoint="$host"
  else
    posture_saved_context || return 1
    if [[ -z "$posture_saved" ]]; then
      origin="the default context"; endpoint="unix:///var/run/docker.sock"
    else
      origin="the saved context"
      posture_context_to_endpoint "$posture_saved" "the saved context" || return 1
      endpoint="$posture_candidate"
    fi
  fi
  if [[ "$endpoint" == unix://* ]]; then
    path="${endpoint#unix://}"
    if [[ "$path" != /?* || "$path" == */ || "$path" == *//* || "/$path/" == */../* \
          || "/$path/" == */./* || "$path" =~ [[:space:]] ]]; then
      posture_target_reason="$origin gives $(posture_quote "$endpoint"): the socket path is not an unambiguous absolute path"
      return 1
    fi
  else
    posture_target_reason="$origin resolves to $(posture_quote "$endpoint"), which is not a local unix socket"
    return 1
  fi
  if [[ -n "$cpn" && "$cpn" != "$compose_name" ]]; then
    posture_target_reason="COMPOSE_PROJECT_NAME $(posture_quote "$cpn") does not match the declared compose project $(posture_quote "$compose_name")"
    return 1
  fi
  posture_candidate="$endpoint"
}

# The re-run command: the caller's words with any earlier --force-posture (both the two-word
# and the --force-posture=X forms) dropped, then
# the live posture named once.
posture_rerun() {
  local live="$1" out="" skip=0 w; shift
  for w in "$@"; do
    if (( skip )); then skip=0; continue; fi
    if [[ "$w" == --force-posture ]]; then skip=1; continue; fi
    [[ "$w" == --force-posture=* ]] && continue
    out+="$(posture_quote "$w") "
  done
  [[ -n "$out" ]] || out="<the same command> "
  printf '%s--force-posture %s' "$out" "$live"
}

posture_clear_binding() {
  posture_endpoint=""
  posture_target_valid=""
  posture_docker=()
}

# ── The entry point ──────────────────────────────────────────────────────────
posture_guard() {
  local root="${1-}" mode="${2-}" override="${3-}" compose_name="${4-}"
  if (( $# >= 4 )); then shift 4; else shift "$#"; fi
  local target_ok="" carrier_reason="" rerun=""
  local obligation='migrations here are expand-then-contract: add nullable, backfill, constrain; drop the old column in a later release'

  posture_resolved=""
  posture_carrier_state=""
  posture_target_reason=""
  posture_clear_binding

  case "$mode" in
    refuse|warn) ;;
    *) posture_say refused "guard mode $(posture_quote "$mode") is neither refuse nor warn (a caller bug)"; return 4 ;;
  esac
  if [[ "$root" != /* ]]; then
    if [[ "$mode" == refuse ]]; then
      posture_say refused "repository root $(posture_quote "$root") is not an absolute path (a caller bug)"; return 4
    fi
    posture_say warning "repository root $(posture_quote "$root") is not an absolute path; posture unknown"
    posture_say notice "posture: unknown — $obligation"
    return 0
  fi

  # Step 1 — validated before anything is read.
  if [[ -n "$override" ]]; then
    case "$override" in
      development|staging|production) ;;
      *)
        if [[ "$mode" == refuse ]]; then
          posture_say refused "--force-posture $(posture_quote "$override") is not a posture; name one of development, staging or production"
          return 4
        fi
        posture_say warning "--force-posture $(posture_quote "$override") is not a posture (development, staging or production) and is ignored"
        override=""
        ;;
    esac
  fi

  # Step 2 — the single read.
  posture_read_carrier "$root"
  [[ "$posture_carrier_state" == legal ]] || carrier_reason="$(posture_carrier_reason "$posture_carrier_state")"

  # Step 3 — at every posture; only success sets the binding outputs.
  if posture_resolve_target "$compose_name"; then
    target_ok=1
    posture_endpoint="$posture_candidate"
    posture_target_valid=1
  fi

  if [[ "$mode" == warn ]]; then
    # Step 6 — every refusal becomes a warning; the binding stays exactly as step 3 left it.
    if [[ -z "$target_ok" ]]; then
      posture_say warning "Docker target locality is unverified: $posture_target_reason; continuing under the existing Docker selection"
    fi
    if [[ -n "$posture_resolved" ]]; then
      posture_say notice "posture: $posture_resolved — $obligation"
    elif [[ -f "$root/copier.yml" ]]; then
      posture_say notice "posture: unknown (template repository: copier.yml present) — $obligation"
    else
      posture_say warning "posture: unknown — $carrier_reason. Repair: set DEPLOYMENT_POSTURE in .copier-answers.yml to one of development, staging or production"
      posture_say notice "posture: unknown — $obligation"
    fi
    return 0
  fi

  if [[ -z "$target_ok" ]]; then
    posture_say refused "the Docker target cannot be verified as local: $posture_target_reason. Select a local unix-socket context (or unset DOCKER_HOST and DOCKER_CONTEXT) and re-run; --force-posture does not waive this"
    posture_clear_binding
    return 4
  fi

  # Step 4 — a legal posture decides, ahead of the template proof.
  if [[ -n "$posture_resolved" ]]; then
    if [[ "$posture_resolved" == development || "$override" == "$posture_resolved" ]]; then
      return 0
    fi
    rerun="$(posture_rerun "$posture_resolved" "$@")"
    posture_say refused "this project is at '$posture_resolved', where this command is destructive. If that is the target you mean, re-run naming the live posture: $rerun"
    posture_clear_binding
    return 4
  fi

  # Step 5 — no legal posture: the template is proven positively, never inferred.
  if [[ -f "$root/copier.yml" ]]; then
    return 0
  fi
  local honoured=""
  [[ -n "$override" ]] && honoured=" --force-posture is not honoured while no posture can be read."
  posture_say refused "the deployment posture cannot be read: $carrier_reason. Repair: set DEPLOYMENT_POSTURE in .copier-answers.yml to one of development, staging or production.$honoured"
  posture_clear_binding
  return 4
}

posture_docker_bind() {
  posture_docker=()
  if [[ "${posture_target_valid-}" != 1 || -z "${posture_endpoint-}" ]]; then
    posture_say refused "no validated Docker endpoint to bind; posture_guard must permit first"
    return 4
  fi
  # shellcheck disable=SC2034  # an output: the caller expands it, this file never does
  posture_docker=(env -u DOCKER_CONTEXT -u DOCKER_HOST docker --host "$posture_endpoint")
}
