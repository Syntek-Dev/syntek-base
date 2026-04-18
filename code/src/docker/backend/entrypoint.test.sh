#!/bin/sh
set -e

cd /workspace/code/src/backend

echo "[test] Running migrations..."
python manage.py migrate --no-input

# Server stays up so tests can run against it via:
#   docker compose exec backend-test pytest
echo "[test] Starting Gunicorn + Uvicorn (1 worker)..."
exec gunicorn config.asgi:application \
  -k uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000 \
  --workers 1 \
  --log-level info \
  --access-logfile - \
  --error-logfile -
