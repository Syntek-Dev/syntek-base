#!/bin/sh
set -e

cd /workspace/code/src/backend

echo "[prod] Running migrations..."
python manage.py migrate --no-input

echo "[prod] Collecting static files..."
python manage.py collectstatic --no-input

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
