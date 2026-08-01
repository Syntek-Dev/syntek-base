#!/bin/sh
set -e

cd /workspace/code/src/django

echo "[prod] Running migrations..."
python manage.py migrate --no-input

echo "[prod] Collecting static files..."
python manage.py collectstatic --no-input

# If a command was passed (compose `command:`), honour it instead of the default web
# server. No service currently passes one; the hook is kept so a future worker or
# one-off task container can reuse this image.
if [ "$#" -gt 0 ]; then
  echo "[prod] Running passed command: $*"
  exec "$@"
fi

echo "[prod] Starting Gunicorn + Uvicorn workers..."
exec gunicorn config.asgi:application \
  -k uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000 \
  --workers "${GUNICORN_WORKERS:-4}" \
  --worker-connections 1000 \
  --max-requests "${GUNICORN_MAX_REQUESTS:-1000}" \
  --max-requests-jitter 100 \
  --timeout "${GUNICORN_TIMEOUT:-30}" \
  --keep-alive 5 \
  --log-level warning \
  --access-logfile - \
  --error-logfile -
