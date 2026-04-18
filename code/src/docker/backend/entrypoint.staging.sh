#!/bin/sh
set -e

cd /workspace/code/src/backend

echo "[staging] Running migrations..."
python manage.py migrate --no-input

echo "[staging] Collecting static files..."
python manage.py collectstatic --no-input

echo "[staging] Starting Gunicorn + Uvicorn workers..."
exec gunicorn config.asgi:application \
  -k uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000 \
  --workers "${GUNICORN_WORKERS:-2}" \
  --worker-connections 1000 \
  --max-requests "${GUNICORN_MAX_REQUESTS:-1000}" \
  --max-requests-jitter 50 \
  --timeout "${GUNICORN_TIMEOUT:-30}" \
  --log-level info \
  --access-logfile - \
  --error-logfile -
