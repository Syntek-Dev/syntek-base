#!/usr/bin/env bash
#
# v4.0.0-manifest-name.sh — restore this project's own name to pyproject.toml.
#
# WHAT CHANGED IN THE TEMPLATE. Until v4.0.0, syntek-base wrote its project-slug token
# straight into `pyproject.toml`'s `[project] name` and let Copier render it. That made
# the template itself unusable by its own toolchain: uv validates that field as a package
# name, `<`, `%` and `>` are not legal in one, and `uv lock` failed while PARSING with
# "Not a valid package or extra name". No lockfile could exist, so basedpyright, pip-audit,
# ruff-via-uv-run and every test suite were guarded off in the template. From v4.0.0 the
# file carries the house constant `syntek-base`, and a copier `_task` rewrites that literal
# to the project's slug at generation.
#
# WHY THAT BROKE AN EXISTING PROJECT. The branding `_task` was gated to `copy`, so it did not
# run on an update. Your project's manifest holds your slug, put there by the old token
# render. Copier updates by
# applying the difference between the OLD template render and the NEW one — and that
# difference is "your slug becomes syntek-base". It applies cleanly, raises no conflict,
# and the update reports success with your manifest now claiming to be the template.
#
# The damage is not cosmetic. `uv lock` and `uv sync` resolve against that name, the
# Dockerfiles run `uv sync --frozen`, and your committed `uv.lock` still pins the old one —
# so the next container build fails on a lockfile mismatch for a package nobody renamed.
#
# WHAT THIS DOES. Reads PROJECT_SLUG back out of `.copier-answers.yml`, which Copier has
# just rewritten with your answers, and puts it back. This is a mechanical one-line restore
# with exactly one correct outcome, which is why it acts rather than advising: leaving it to
# a human means leaving a broken build behind a success message.
#
# Anchored to the exact literal `name = "syntek-base"` rather than `^name = `, because
# [project] is not the only table in this file that could carry a name key and a loose
# pattern would rewrite the first one it met.
#
# NOW A BACKSTOP (23/08/2026). The branding task in copier.yml is ungated and runs on update
# too, ahead of `uv lock`, so on a current template the manifest is already correct by the
# time this fires and it exits at the grep below. It stays because it is the only cure for a
# project whose update ran under a template that still gated that task — and because being a
# no-op costs one grep.
#
# Runs automatically as a copier `_migrations` entry when an update crosses v4.0.0. Safe to
# run by hand afterwards: it is idempotent, and a manifest already naming this project is
# left untouched.
#
# Working directory is the project being updated.
#
# Exit codes:  0 = always. A migration that fails an update leaves the project half-
#              upgraded, which is worse than a manifest this prints instructions for.
#
set -euo pipefail

MANIFEST="pyproject.toml"
ANSWERS=".copier-answers.yml"
TEMPLATE_NAME='name = "syntek-base"'

[[ -f "$MANIFEST" ]] || exit 0
grep -qF "$TEMPLATE_NAME" "$MANIFEST" || exit 0

printf '\n▸ v4.0.0 migration — the package name in %s\n\n' "$MANIFEST"

# `PROJECT_SLUG: my-project`, with optional quotes. Copier writes this file through
# to_nice_yaml, so the key is at column zero and the value is on the same line.
SLUG=$(sed -n 's/^PROJECT_SLUG:[[:space:]]*["'"'"']\{0,1\}\([^"'"'"']*\)["'"'"']\{0,1\}[[:space:]]*$/\1/p' \
  "$ANSWERS" 2>/dev/null | head -1 || true)

if [[ -z "$SLUG" ]]; then
  printf '  Could not read PROJECT_SLUG from %s, so the name has been left alone.\n\n' "$ANSWERS"
  printf '  Your manifest now reads `%s`, which is the TEMPLATE'"'"'s name rather than\n' "$TEMPLATE_NAME"
  printf '  your own. Edit that one line to your project'"'"'s slug before the next\n'
  printf '  container build, then re-lock:\n\n'
  printf '      uv lock\n\n'
  exit 0
fi

perl -0777 -i -pe "s/^name = \"syntek-base\"\$/name = \"$SLUG\"/m" "$MANIFEST"

printf '  Restored to `name = "%s"`.\n\n' "$SLUG"
printf '  The template now carries its own name in this field and brands it at\n'
printf '  generation; an update cannot run that step, so it is done here instead.\n\n'
printf '  Nothing else is needed unless your lockfile disagrees. If a build fails on\n'
printf '  `uv sync --frozen`, re-lock and commit the result:\n\n'
printf '      uv lock\n\n'

exit 0
