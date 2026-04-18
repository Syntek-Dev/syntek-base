#!/bin/sh
set -e

cd /workspace/code/src/backend

echo "[dev] Running migrations..."
python manage.py migrate --no-input

echo "[dev] Starting Gunicorn + Uvicorn (1 worker, --reload)..."
exec gunicorn config.asgi:application \
  -k uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000 \
  --workers 1 \
  --reload \
  --log-level debug \
  --access-logfile - \
  --error-logfile -
