#!/usr/bin/env bash
#
# posture-guard.sh — the deployment-posture guard for the destructive dev scripts.
#
# Sourced, never executed. Functions only; nothing runs on source except loading the shared
# conflict-marker pattern, so sourcing twice is harmless. Every public name is `posture_`.
#
# CONTRACT
#   posture_guard ROOT MODE OVERRIDE COMPOSE_NAME ENV_FILE [INVOCATION WORD...]
#     ROOT          absolute repository root — the caller's BASH_SOURCE-derived PROJECT_ROOT.
#                   Never cwd, never an environment variable: the carrier and the template
#                   proof are both anchored here, and the self-test aims it at a fixture.
#     MODE          refuse | warn. The refuse-versus-warn policy lives here, not in callers.
#     OVERRIDE      the value the caller parsed from --force-posture, or "".
#     COMPOSE_NAME  the `name:` of the LAST compose file in the caller's set (the worktree
#                   override outranks the base file's).
#     ENV_FILE      the file the caller hands Compose as --env-file, or "" for none. Compose reads
#                   COMPOSE_PROJECT_NAME from it when the shell sets none, so the guard does too
#                   (review R-001); it is read as data through _lib/env-file.sh, never sourced.
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
#   posture_compose_name FILE...
#     Prints the compose project name the caller's compose set declares, for COMPOSE_NAME.
#     Compose merges its files in order and a later top-level `name:` replaces an earlier one,
#     so the last declaring file wins — the worktree override over the base. Prints "" when
#     none declares one, which fails any COMPOSE_PROJECT_NAME comparison closed. Returns 0.
#     The name is printed as declared; the guard normalises it as Compose does (F-018), and
#     a declared name that normalises to nothing fails the target check closed.
#
#   posture_compose_project FILE...
#     Prints the project Compose acts on for that declared name — posture_compose_name over the
#     set, normalised as Compose does (F-018) — for a caller to pin with `compose -p`, so a
#     COMPOSE_PROJECT_NAME in the shell or the env-file can never select (or be printed as) a
#     different project. Returns 1, with a reason on stderr and nothing on stdout, when no file
#     declares a name or the name cannot be normalised faithfully (interpolation, non-ASCII,
#     empty after normalising): the same cases the guard fails closed on.
#
#   posture_above_development
#     Succeeds when the last guard call read staging or production: where a prompting caller's
#     --yes goes inert. A template or development run is not above development.
#
#   posture_unconfirmed
#     A prompting caller's empty read. Above development it refuses (return 4, the prefix):
#     with --yes inert, an unanswered prompt is a scripted run that authorised nothing, and an
#     exit-0 abort would report success for work never done (TM-06). Elsewhere returns 0.
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
# shellcheck source=code/src/scripts/_lib/env-file.sh
if [[ "${BASH_SOURCE[0]}" == */* ]]; then source "${BASH_SOURCE[0]%/*}/env-file.sh"
else source ./env-file.sh
fi

posture_say() { printf 'posture-guard: %s — %s\n' "$1" "$2" >&2; }

# printf %q, so a hostile value cannot write terminal escapes into the refusal.
posture_quote() { printf '%q' "$1"; }
# True when the argument holds any byte outside printable ASCII. Call under LC_ALL=C so the
# bracket class is a byte range, not the caller's locale.
# The argument with CRLF, CR, NEL (C2 85), U+2028 (E2 80 A8) and U+2029 (E2 80 A9) each replaced
# by LF, matched as bytes. Trailing LFs are dropped, as the caller's $(cat) already does.
posture_unify_breaks() {
  local LC_ALL=C
  local s="$1"
  s="${s//$'\r\n'/$'\n'}"; s="${s//$'\r'/$'\n'}"; s="${s//$'\xc2\x85'/$'\n'}"
  s="${s//$'\xe2\x80\xa8'/$'\n'}"; s="${s//$'\xe2\x80\xa9'/$'\n'}"
  printf '%s' "$s"
}
# True when the argument is all printable ASCII (tab allowed) and matches the ERE. Call under
# LC_ALL=C, so a BOM or a non-ASCII space before the key cannot pass as leading whitespace.
posture_ascii_match() {
  local s="${1//$'\t'/ }"
  [[ "$s" != *[![:print:]]* && "$1" =~ $2 ]]
}
posture_has_non_ascii() { [[ "$1" == *[![:print:]]* || "$1" == *[$'\x80'-$'\xff']* ]]; }

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
  # Top-level forms YAML can read as ANY key, this one included, that a line reader cannot
  # model (review R-002): an explicit `?` key, a tag, an anchor, an alias, a flow collection,
  # and a quoted key carrying an escape. Copier writes none of them, so each fails closed as
  # unrecognised rather than letting a second posture hide behind the canonical line.
  local exotic='^[?!&*{[]' escaped="^[\"'][^\"']*\\\\" after=0
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
  # Every line break a YAML loader honours becomes the LF this reader splits on: CRLF, a lone CR,
  # NEL, U+2028 and U+2029 (PyYAML, which Copier loads answers with, treats all five as breaks).
  # A key hidden after one then counts as a second key; and Copier's own dumper writes NEL, U+2028
  # and U+2029 raw inside a quoted free-text answer, whose continuation is indented and so ignored.
  content="$(posture_unify_breaks "$content")"
  while IFS= read -r line; do
    line="${line%$'\r'}"
    # The first non-blank line after the key: indented content there continues the plain
    # scalar, which YAML folds into the value ("development production"), so it is not a value.
    if (( after )) && [[ -n "${line//[[:space:]]/}" ]]; then
      after=0
      [[ "$line" =~ ^[[:space:]]+[^[:space:]#] ]] && odd=1
    fi
    if [[ "$line" =~ $exotic || "$line" =~ $escaped ]]; then
      odd=1
    elif [[ "$line" =~ $anykey ]]; then
      keys=$((keys + 1))
      if [[ "$line" =~ $canon ]]; then value="${line#DEPLOYMENT_POSTURE:}"; after=1; else odd=1; fi
    elif [[ "$line" =~ ^[[:space:]]*#[[:space:]]*DEPLOYMENT_POSTURE[[:space:]]*: ]]; then
      comments=$((comments + 1))
    fi
  done <<<"$content"
  if (( keys == 0 && ! odd )); then
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
  local compose_name="$1" env_file="${2-}" endpoint path origin
  local ctx="${DOCKER_CONTEXT:-}" host="${DOCKER_HOST:-}" cpn="${COMPOSE_PROJECT_NAME:-}" cpn_from cpn_shown
  posture_target_reason=""
  # "project" when the failure is the compose project rather than the daemon (review R-003),
  # so the refusal prints a repair that can actually clear it.
  posture_target_kind=""
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
  # The project Compose will act on (F-018): the declared name as Compose normalises it, or
  # an explicit COMPOSE_PROJECT_NAME, which Compose never rewrites — it refuses one not
  # already in normal form. Compare those, never the raw strings.
  local project
  posture_target_kind=project
  # COMPOSE_PROJECT_NAME from the shell first, else from the --env-file — Compose's own
  # precedence (review R-001). A shell value exported empty falls through to the file, which can
  # only refuse more often than Compose would, never less. An env-file value the literal reader
  # will not interpret is a project the guard cannot name, so it fails closed.
  # The value is printed only when it came from the shell. A live env file's contents never
  # reach the output: an AI session may be reading it, and no AI tool reads a live .env.*.
  cpn_from="COMPOSE_PROJECT_NAME"; cpn_shown="$(posture_quote "$cpn")"
  if [[ -z "$cpn" && -n "$env_file" ]]; then
    posture_env_project "$env_file" || return 1
    cpn="$posture_env_cpn"
    [[ -n "$cpn" ]] && cpn_from="COMPOSE_PROJECT_NAME in the env-file $(posture_quote "$env_file")" \
      && cpn_shown="(value not shown)"
  fi
  # Two declared forms the shell port cannot reproduce faithfully, so the guard fails closed
  # rather than guess: `${VAR}` (Compose interpolates before it normalises, and the guard does
  # not), and any non-ASCII byte (Go's ToLower folds some, e.g. U+212A to `k`, where an ASCII
  # port would drop them).
  if [[ "$compose_name" == *'$'* ]] || LC_ALL=C posture_has_non_ascii "$compose_name"; then
    posture_target_reason="the declared compose project $(posture_quote "$compose_name") uses interpolation or non-ASCII characters, so the project Compose would act on cannot be determined"
    return 1
  fi
  project="$(posture_normalise_name "$compose_name")"
  if [[ -n "$compose_name" && -z "$project" ]]; then
    # Compose would fail to load ("project name must not be empty") or fall back to some
    # other name; either way the guard cannot name the project, so it fails closed.
    posture_target_reason="the declared compose project $(posture_quote "$compose_name") normalises to an empty name, so the project Compose would act on cannot be determined"
    return 1
  fi
  if [[ -n "$cpn" && "$cpn" != "$(posture_normalise_name "$cpn")" ]]; then
    posture_target_reason="$cpn_from $cpn_shown is not a valid Compose project name (lower-case a-z, 0-9, _ and - only, starting with a letter or digit); Compose would refuse it"
    return 1
  fi
  if [[ -n "$cpn" && "$cpn" != "$project" ]]; then
    posture_target_reason="$cpn_from $cpn_shown does not match the declared compose project $(posture_quote "$compose_name"), which Compose names $(posture_quote "$project")"
    return 1
  fi
  posture_target_kind=""
  posture_candidate="$endpoint"
}

# The env-file's COMPOSE_PROJECT_NAME, into posture_env_cpn ("" = not set). Compose's env-file
# parser is not line-based — it strips a BOM, skips any Unicode space, accepts `=` or `:` with
# spaces around it, and starts a new statement after a closing quote on the same line — so the
# guard does not model it. It counts every mention of the key anywhere in the file, comments
# included (a `#` line can sit inside a multi-line quoted value), and accepts exactly one, on a
# line that is plain ASCII `[export ]COMPOSE_PROJECT_NAME=value`. Any other mention is a project
# the guard cannot name, so it fails closed. The value goes through env-file.sh's literal reader.
posture_env_project() {
  local file="$1" line hits found=""
  local canon='^[[:blank:]]*(export[[:blank:]]+)?COMPOSE_PROJECT_NAME='
  posture_env_cpn=""
  [[ -f "$file" && -r "$file" ]] || return 0
  # A NUL byte makes grep treat the file as binary and report no match, while Compose reads on
  # past it: refuse the file outright, and search it with -a regardless.
  if [[ "$(LC_ALL=C tr -d '\000' <"$file" | wc -c)" != "$(wc -c <"$file")" ]]; then
    posture_target_reason="the env-file $(posture_quote "$file") contains a NUL byte, so the project Compose would act on cannot be determined"
    return 1
  fi
  hits="$(LC_ALL=C grep -aoF -- COMPOSE_PROJECT_NAME "$file" | wc -l)" || hits=0
  (( hits == 0 )) && return 0
  found="$(LC_ALL=C grep -aF -- COMPOSE_PROJECT_NAME "$file")" || found=""
  found="${found%$'\r'}"
  if (( hits > 1 )) || ! LC_ALL=C posture_ascii_match "$found" "$canon"; then
    posture_target_reason="the env-file $(posture_quote "$file") mentions COMPOSE_PROJECT_NAME other than on one plain COMPOSE_PROJECT_NAME=value line, so the project Compose would act on cannot be determined"
    return 1
  fi
  if ! posture_env_cpn="$(_env_strip "${found#*=}" COMPOSE_PROJECT_NAME "$file" 2>/dev/null)"; then
    posture_env_cpn=""
    posture_target_reason="COMPOSE_PROJECT_NAME in the env-file $(posture_quote "$file") cannot be read literally (it uses interpolation), so the project Compose would act on cannot be determined"
    return 1
  fi
}

# Compose's project-name normalisation, verbatim in shell. Primary source, read 15/11/2026:
# compose-spec/compose-go loader/loader.go, NormalizeProjectName —
#   s = strings.ToLower(s); keep only regexp "[a-z0-9_-]" matches; strings.TrimLeft(s, "_-")
# — applied to the top-level `name:` (projectName, `if !opts.SkipNormalization`). An explicit
# name (-p or COMPOSE_PROJECT_NAME) is NOT normalised: projectName returns
# InvalidProjectNameErr unless it already equals its normalised form. The rule as documented:
# https://docs.docker.com/compose/how-tos/project-name/ — "Project names must contain only
# lowercase letters, decimal digits, dashes, and underscores, and must begin with a lowercase
# letter or decimal digit." LC_ALL=C pins the ranges to ASCII, as Go's regexp class is.
posture_normalise_name() {
  # LC_ALL is set before the expansion: in one `local` statement `${1,,}` would expand first,
  # in the caller's locale. Callers reject non-ASCII input before this runs.
  local LC_ALL=C
  local s="${1,,}"
  s="${s//[^a-z0-9_-]/}"
  s="${s#"${s%%[!_-]*}"}"
  printf '%s' "$s"
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
  local root="${1-}" mode="${2-}" override="${3-}" compose_name="${4-}" env_file="${5-}"
  if (( $# >= 5 )); then shift 5; else shift "$#"; fi
  local target_ok="" carrier_reason="" rerun=""
  local obligation='migrations here are expand-then-contract: add nullable, backfill, constrain; drop the old column in a later release'

  posture_resolved=""
  posture_carrier_state=""
  posture_target_reason=""
  posture_target_kind=""
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
  if posture_resolve_target "$compose_name" "$env_file"; then
    target_ok=1
    posture_endpoint="$posture_candidate"
    posture_target_valid=1
  fi

  if [[ "$mode" == warn ]]; then
    # Step 6 — every refusal becomes a warning; the binding stays exactly as step 3 left it.
    if [[ -z "$target_ok" && "$posture_target_kind" == project ]]; then
      posture_say warning "the compose project is unverified: $posture_target_reason; continuing under the existing Docker selection"
    elif [[ -z "$target_ok" ]]; then
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

  if [[ -z "$target_ok" && "$posture_target_kind" == project ]]; then
    posture_say refused "the compose project cannot be verified: $posture_target_reason. Unset or correct COMPOSE_PROJECT_NAME (in the shell or the env-file), or the compose file's top-level name:, and re-run; --force-posture does not waive this"
    posture_clear_binding
    return 4
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

posture_compose_name() {
  local f line value name=""
  for f in "$@"; do
    [[ -n "$f" && -f "$f" && -r "$f" ]] || continue
    value=""
    while IFS= read -r line || [[ -n "$line" ]]; do
      line="${line%$'\r'}"
      [[ "$line" =~ ^name:[[:space:]]*(.*)$ ]] || continue
      value="${BASH_REMATCH[1]}"
      if [[ "$value" =~ ^\"([^\"]*)\" || "$value" =~ ^\'([^\']*)\' ]]; then
        value="${BASH_REMATCH[1]}"
      else
        value="${value%%[[:space:]]#*}"
        value="${value%"${value##*[![:space:]]}"}"
      fi
    done <"$f"
    [[ -n "$value" ]] && name="$value"
  done
  printf '%s' "$name"
}

posture_compose_project() {
  local name project
  name="$(posture_compose_name "$@")"
  if [[ -z "$name" ]]; then
    printf 'posture_compose_project: no compose file in the set declares a top-level name:\n' >&2
    return 1
  fi
  if [[ "$name" == *'$'* ]] || LC_ALL=C posture_has_non_ascii "$name"; then
    printf 'posture_compose_project: the declared name %s uses interpolation or non-ASCII characters\n' "$(posture_quote "$name")" >&2
    return 1
  fi
  project="$(posture_normalise_name "$name")"
  if [[ -z "$project" ]]; then
    printf 'posture_compose_project: the declared name %s normalises to an empty name\n' "$(posture_quote "$name")" >&2
    return 1
  fi
  printf '%s' "$project"
}

posture_above_development() {
  [[ "${posture_resolved-}" == staging || "${posture_resolved-}" == production ]]
}

posture_unconfirmed() {
  posture_above_development || return 0
  posture_say refused "no confirmation was read at the prompt, and this project is at '$posture_resolved'. An unanswered prompt is a refusal here, not an abort; answer it, or pipe 'yes' to it from a script that also names the live posture with --force-posture"
  return 4
}
