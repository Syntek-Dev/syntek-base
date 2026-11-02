#!/usr/bin/env bash
#
# v7.8.0-leaked-adr.sh — remove the one syntek-base ADR that shipped into projects by accident.
#
# WHAT HAPPENED. copier.yml re-included project-management/src/**/*TEMPLATE*, which matches the
# word anywhere in a name, so
#   project-management/src/15-DECISIONS/ADR-US004-PATTERNED-REGISTRATION-PRESERVES-SHIPPED-TEMPLATES-09-10-2026.md
# — a decision about syntek-base's own citation gate — reached every project generated or
# updated at 7.7.0. 7.8.0 narrows the re-include to *-TEMPLATE.*, which stops new projects
# receiving it, but Copier never touches a path it excludes, so an existing project keeps it.
#
# WHAT IT DOES. Deletes that file ONLY when it is byte-identical to what 7.7.0 shipped: the
# file is normalised by putting its one rendered token (DEVELOPER_NAME, on the Deciders line)
# back, then compared by sha256 with the template's 7.7.0 copy. An edited file — or a project's
# own ADR that happens to carry the name — is left in place with a warning, because only a
# human can tell a decision they adopted from one they never made.
#
# NEVER FAILS THE UPDATE, for the reason v2.0.0-renumber-src.sh records: a non-zero exit aborts
# every migration declared after this one and leaves the project half-upgraded.
#
# Idempotent: a second run finds the file absent and does nothing.
# Working directory is the project being updated.
#
# Exit codes:  0 = always
#
set -uo pipefail

ADR="project-management/src/15-DECISIONS/ADR-US004-PATTERNED-REGISTRATION-PRESERVES-SHIPPED-TEMPLATES-09-10-2026.md"
# sha256 of the file as it sits in the template at v7.7.0, token unrendered.
SHIPPED_SHA="e902db952e204ecc59c23faf2c91d3a8ccd29b6b025c59a2bb9deac17aecb703"

printf '\n▸ 7.8.0 — the syntek-base ADR that shipped by accident\n'

[[ -f "$ADR" ]] || { echo "  not present — nothing to do"; exit 0; }

opener='<''%' # split so the token gate never reads a bare opener in this file
closer='%''>'
token="${opener}DEVELOPER_NAME${closer}"
actual="$(sed -E "s/^\*\*Deciders:\*\* .* — approved remediation in this conversation\$/**Deciders:** ${token} — approved remediation in this conversation/" "$ADR" | sha256sum | cut -d' ' -f1)"

if [[ "$actual" == "$SHIPPED_SHA" ]]; then
  if rm -f "$ADR"; then
    echo "  removed $ADR — it was syntek-base's own decision, never this project's. Commit the deletion with this update"
  else
    echo "  ! could not remove $ADR — delete it by hand"
  fi
else
  echo "  ! $ADR differs from what 7.7.0 shipped, so it was left in place."
  echo "    If this project never made that decision, delete it by hand."
fi
exit 0
