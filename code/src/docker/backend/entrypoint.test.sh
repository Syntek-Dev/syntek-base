#!/bin/sh
set -e

cd /workspace/code/src/backend

echo "[test] Running migrations..."
python manage.py migrate --no-input

# If arguments are provided (e.g. "pytest --cov=apps"), run them and exit.
# This allows: docker compose run --rm backend-test pytest ...
# Without arguments, start Gunicorn so the container stays up for:
#   docker compose exec backend-test pytest ...
if [ $# -gt 0 ]; then
  echo "[test] Running: $*"
  exec "$@"
fi

echo "[test] Starting Gunicorn + Uvicorn (1 worker)..."
exec gunicorn config.asgi:application \
  -k uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000 \
  --workers 1 \
  --log-level info \
  --access-logfile - \
  --error-logfile -
