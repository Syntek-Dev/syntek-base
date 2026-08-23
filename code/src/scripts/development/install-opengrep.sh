#!/usr/bin/env bash
#
# install-opengrep.sh — Install the pinned Opengrep engine that static-analysis.sh runs.
#
#                       WHY THIS EXISTS. static-analysis.sh is deliberately optional on a
#                       laptop: engine absent, note printed, exit 0. That contract is only
#                       honest because CI carries the other half — but until this script
#                       there was no local route to the engine at all, so a rule could be
#                       written, committed and released without its author ever once
#                       watching it run. An audit that cannot run where it ships is one
#                       nobody ever sees fail, and that applies to the rule's author as
#                       much as it does to the gate.
#
#                       The instruction that stood in its place was worse than absent. It
#                       read: pick the asset for your platform, chmod +x it, put it on
#                       PATH — an unverified binary, downloaded over the internet, made
#                       executable by hand. The CI job that runs this audit states the
#                       opposite policy outright: this is the first downloaded binary in
#                       the repository's toolchain and it does not arrive unverified.
#
#                       COSIGN IS REQUIRED, NOT PREFERRED. There is no degraded path that
#                       installs an unverified binary with a warning, because the degraded
#                       path is the one most people would take, and a supply-chain check
#                       everybody skips is a supply-chain check nobody has. Missing cosign
#                       is exit 1 with the route for this platform, never a shrug.
#
#                       WHAT IS VERIFIED. Upstream signs every release asset with Sigstore.
#                       cosign checks that signature against the exact workflow identity
#                       that produced the binary, before the binary is executed. The
#                       signature proves who built it, not which version it is — so the pin
#                       is asserted separately, against what actually landed on disk.
#
#                       IT LIVES HERE RATHER THAN BESIDE THE AUDIT IT SERVES, and the reason
#                       is mechanical: two things glob the audit directory and act on every
#                       member. The pre-PR gate RUNS each one, so an installer shelved there
#                       would put a signed 46 MB download inside every pre-PR run; the
#                       template-integrity check requires each one in the README's
#                       audit-script register, where an installer is not an audit and the row
#                       would be a lie. Both would need a by-name exception on a scope whose
#                       own header argues that lists drift silently. This directory globs
#                       nothing, and the two other installers are already its neighbours.
#
#                       THE SIGNING IDENTITY IS HELD IN TWO PLACES, deliberately and not
#                       silently: here, and in the CI workflow for this audit, which installs
#                       the engine its own way on a runner that has sudo and a known
#                       architecture. That is a duplicated constant rather than a
#                       duplicated rule — if upstream moves its release workflow, whichever
#                       copy is stale fails LOUDLY, because verification simply refuses. A
#                       version bump updates both together.
#
# Pin:          the root .opengrep-version, read and never restated. This repository's
#               fourth toolchain pin, beside those for Node, Python and Rust.
#
# Requirements: curl, base64, cosign. No sudo: the default prefix is a user directory.
#
# Usage: install-opengrep.sh [--prefix DIR] [--force] [--quiet] [--help]
#
# Exit codes:  0 = the pinned, signature-verified engine is installed (or already was)
#              1 = a requirement is missing, the platform has no signed asset, the
#                  signature did not verify, or the installed build is not the pin
#              2 = script error (bad arguments)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
PIN_FILE="$PROJECT_ROOT/.opengrep-version"

RELEASE_BASE="https://github.com/opengrep/opengrep/releases/download"

# Pinned exactly rather than by regex, matching what CI verifies against: only the
# opengrep release workflow, running on GitHub's OIDC issuer, may have produced this
# binary. If upstream renames or moves that workflow this fails loudly on the next
# version bump, which is the correct outcome and better than a regex loose enough to
# keep passing through it.
CERT_IDENTITY='https://github.com/opengrep/opengrep/.github/workflows/rolling-release.yml@refs/heads/main'
CERT_OIDC_ISSUER='https://token.actions.githubusercontent.com'

PREFIX="${XDG_BIN_HOME:-$HOME/.local/bin}"
FORCE=false
QUIET=false

log()  { $QUIET || printf '  %s\n' "$*"; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }
ok()   { $QUIET || printf '  \033[32m✓\033[0m  %s\n' "$*"; }
warn() { printf '  \033[33m⚠\033[0m  %s\n' "$*" >&2; }
die()  { printf 'install-opengrep.sh error: %s\n' "$*" >&2; exit 2; }
fail() { printf '\033[31m✗\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
install-opengrep.sh — Install the pinned, signature-verified Opengrep engine

Usage:
  install-opengrep.sh                  Install into ${XDG_BIN_HOME:-$HOME/.local/bin}
  install-opengrep.sh --prefix DIR     Install into DIR instead
  install-opengrep.sh --force          Reinstall even when the pinned build is present
  install-opengrep.sh --quiet          Suppress progress output

The version comes from the root .opengrep-version. cosign is required: there is no
path here that installs an unverified binary.

Exit codes: 0 installed (or already present)  1 requirement/verification failure  2 script error
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --prefix) PREFIX="${2:-}"; shift 2 ;;
    --force)  FORCE=true;      shift   ;;
    --quiet)  QUIET=true;      shift   ;;
    --help|-h) usage; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done

[ -n "$PREFIX" ] || die "--prefix needs a directory"

bold ""
bold "▸ install-opengrep.sh"

# ── The pin ───────────────────────────────────────────────────────────────────
[ -f "$PIN_FILE" ] || fail "no .opengrep-version at the repository root — nothing to pin to"
VERSION="$(tr -d '[:space:]' < "$PIN_FILE")"
[ -n "$VERSION" ] || fail ".opengrep-version is empty — the pin is the whole point"
log "pinned version: $VERSION"

# ── Already installed? ────────────────────────────────────────────────────────
if ! $FORCE && command -v opengrep >/dev/null 2>&1; then
  present="$(opengrep --version 2>/dev/null | tr -d '[:space:]' || true)"
  if [ "$present" = "$VERSION" ]; then
    ok "opengrep $VERSION is already on PATH at $(command -v opengrep)"
    exit 0
  fi
  log "opengrep ${present:-(unreadable)} is on PATH and the pin is $VERSION — replacing it"
fi

# ── Which signed asset this platform takes ────────────────────────────────────
#
# Every asset listed here is one upstream signs; the .tar.gz core builds are NOT
# signed and are deliberately not reachable from this script. A platform with no
# signed asset is a hard stop rather than a fallback to an unverified one.
os="$(uname -s)"
arch="$(uname -m)"
libc="gnu"
if [ "$os" = "Linux" ] && ! ldd --version 2>&1 | grep -qiE 'glibc|gnu libc'; then
  libc="musl"
fi

case "$os/$arch/$libc" in
  Linux/x86_64/gnu)             ASSET="opengrep_manylinux_x86" ;;
  Linux/aarch64/gnu|Linux/arm64/gnu) ASSET="opengrep_manylinux_aarch64" ;;
  Linux/x86_64/musl)            ASSET="opengrep_musllinux_x86" ;;
  Linux/aarch64/musl|Linux/arm64/musl) ASSET="opengrep_musllinux_aarch64" ;;
  Darwin/arm64/*)               ASSET="opengrep_osx_arm64" ;;
  Darwin/x86_64/*)              ASSET="opengrep_osx_x86" ;;
  MINGW*/*/*|MSYS*/*/*|CYGWIN*/*/*) ASSET="opengrep_windows_x86.exe" ;;
  *)
    fail "no signed Opengrep asset for $os/$arch.
  Signed builds cover manylinux and musllinux (x86_64, aarch64), macOS (arm64, x86_64)
  and Windows x86. The .tar.gz core builds are unsigned and this script will not fetch
  one. Run the audit in CI instead, where the gate actually bites."
    ;;
esac
log "platform: $os/$arch ($libc libc) -> $ASSET"

# ── Requirements ──────────────────────────────────────────────────────────────
command -v curl   >/dev/null 2>&1 || fail "curl is required to fetch the release asset"
command -v base64 >/dev/null 2>&1 || fail "base64 is required — the certificate ships base64-wrapped"

if ! command -v cosign >/dev/null 2>&1; then
  fail "cosign is required and is not on PATH.

  This is the repository's first downloaded binary and it does not arrive unverified,
  so there is no --skip-verify here by design.

  Releases: https://github.com/sigstore/cosign/releases — read the tag from there rather
  than from this message, and substitute it below. A version is deliberately not pinned
  here: cosign verifies someone else's signatures and wants to be current, unlike
  .opengrep-version, which pins an engine whose output has to be reproducible.

    macOS           brew install cosign
    Any platform    curl -fsSL -o ~/.local/bin/cosign \\
                      https://github.com/sigstore/cosign/releases/download/vX.Y.Z/cosign-linux-amd64
                    chmod +x ~/.local/bin/cosign
                    (swap the asset for your OS and architecture; no sudo needed)
    Debian/Ubuntu   the release also ships cosign_X.Y.Z_amd64.deb for dpkg -i
    Go toolchain    go install github.com/sigstore/cosign/v3/cmd/cosign@latest
                    (the major in that path tracks the current release series)

  CI installs it with sigstore/cosign-installer, which is the same check by another
  route (.github/workflows/audit-static-analysis.yml)."
fi

# ── Download ──────────────────────────────────────────────────────────────────
WORK="$(mktemp -d)" || fail "could not create a temporary directory"
trap 'rm -rf "$WORK"' EXIT

base="$RELEASE_BASE/v${VERSION}"
log "downloading $ASSET and its signing material…"
curl -fsSL -o "$WORK/opengrep"      "$base/$ASSET"       || fail "could not download $base/$ASSET"
curl -fsSL -o "$WORK/opengrep.cert" "$base/$ASSET.cert"  || fail "could not download the certificate for $ASSET"
curl -fsSL -o "$WORK/opengrep.sig"  "$base/$ASSET.sig"   || fail "could not download the signature for $ASSET"

# ── Verify, before anything is made executable ────────────────────────────────
log "verifying the Sigstore signature…"
base64 -d < "$WORK/opengrep.cert" > "$WORK/opengrep.pem" \
  || fail "the certificate did not decode — refusing to install an asset we cannot check"

cosign verify-blob \
  --certificate "$WORK/opengrep.pem" \
  --signature "$WORK/opengrep.sig" \
  --certificate-identity "$CERT_IDENTITY" \
  --certificate-oidc-issuer "$CERT_OIDC_ISSUER" \
  "$WORK/opengrep" >/dev/null 2>&1 \
  || fail "the signature did not verify against the pinned release-workflow identity.
  Nothing has been installed. Either upstream moved that workflow — in which case
  CERT_IDENTITY here and in audit-static-analysis.yml both need updating together —
  or this asset is not what it claims to be."
ok "signature verified against the pinned release-workflow identity"

# ── Install ───────────────────────────────────────────────────────────────────
mkdir -p "$PREFIX" || fail "could not create $PREFIX"
[ -w "$PREFIX" ]   || fail "$PREFIX is not writable. Pass --prefix with a directory you own, or re-run with elevated privileges."

target="$PREFIX/opengrep"
case "$ASSET" in *.exe) target="$PREFIX/opengrep.exe" ;; esac
install -m 0755 "$WORK/opengrep" "$target" || fail "could not install into $PREFIX"
ok "installed $target"

# ── Assert the pin against what actually landed ───────────────────────────────
#
# A release tag can be moved. The signature proves who built the binary, not which
# version it is, so the pin is checked against the installed build rather than assumed
# from the URL it came down.
installed="$("$target" --version 2>/dev/null | tr -d '[:space:]' || true)"
if [ "$installed" != "$VERSION" ]; then
  rm -f "$target"
  fail ".opengrep-version pins $VERSION but the downloaded build reports ${installed:-(unreadable)}.
  The binary has been removed rather than left on PATH pretending to be the pin."
fi
ok "installed build reports $installed, matching the pin"

case ":$PATH:" in
  *":$PREFIX:"*) ;;
  *) warn "$PREFIX is not on your PATH — add it, or static-analysis.sh will still report the engine absent" ;;
esac

log ""
log "next: bash code/src/scripts/audits/static-analysis.sh --self-test"
log "      the self-test exits 2 without the engine where the ordinary scan exits 0,"
log "      so running it is how you find out the install actually took."
log ""
