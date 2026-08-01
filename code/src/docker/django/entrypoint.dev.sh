#!/bin/sh
set -e

cd /workspace/code/src/django

echo "[dev] Running migrations..."
python manage.py migrate --no-input

# No collectstatic in dev: WHITENOISE_USE_FINDERS=True serves static live from source, so CSS/JS
# edits appear on refresh with no rebuild. collectstatic runs only in staging/prod (hashed files).

# If a command was passed (compose `command:`), honour it instead of the default web
# server. No service currently passes one; the hook is kept so a future worker or
# one-off task container can reuse this image.
if [ "$#" -gt 0 ]; then
  echo "[dev] Running passed command: $*"
  exec "$@"
fi

echo "[dev] Starting Uvicorn (--reload; watches .py + templates)..."
# Dev runs Uvicorn directly for reliable hot-reload. Uvicorn's watchfiles reloader (shipped in
# uvicorn[standard]) watches the source tree and reloads on any .py OR template (.html) change —
# including django-components templates, whose per-class template cache is cleared by the reload.
# It handles inode-replacing editors (unlike gunicorn's --reload with the Uvicorn worker, which is
# flaky). Static (CSS/JS) is served live by WhiteNoise finders — no reload needed. Staging and prod
# keep Gunicorn + UvicornWorker unchanged (see entrypoint.staging.sh / entrypoint.prod.sh).
exec uvicorn config.asgi:application \
  --host 0.0.0.0 --port 8000 \
  --reload \
  --reload-dir /workspace/code/src/django \
  --reload-include "*.html" \
  --log-level debug
