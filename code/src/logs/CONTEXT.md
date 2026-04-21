# code/src/logs — Local Log Files

Runtime log files written by the Django backend in **dev and test environments only**.

> **Staging and production do not write logs to disk.** Those environments log to stdout
> (JSON format), which Promtail captures and ships to Loki. See `code/docs/LOGGING.md`.

## What goes here

| File                            | Written by                   | Contains                         |
| ------------------------------- | ---------------------------- | -------------------------------- |
| `django.log`                    | Django `RotatingFileHandler` | All application log output       |
| `django.log.1` … `django.log.5` | Log rotation                 | Rotated backups (auto-generated) |

All files in this directory are gitignored. Only this `CONTEXT.md` and `.gitkeep` are tracked.

## What does NOT go here

- Exception reports → Glitchtip (staging/prod) or the console (dev/test)
- Metrics → Prometheus
- Aggregated logs → Loki
- Bug reports or incident notes → `project-management/src/13-BUGS/`

## Accessing logs locally

```bash
# Tail live output
docker compose -f code/src/docker/docker-compose.dev.yml exec backend \
    tail -f /workspace/src/logs/django.log

# Grep for errors
docker compose -f code/src/docker/docker-compose.dev.yml exec backend \
    grep ERROR /workspace/src/logs/django.log
```

## Log rotation

The `RotatingFileHandler` is configured with:

- Max file size: 10 MB
- Backup count: 5 (so max 60 MB total on disk)

To manually clear logs during development:

```bash
docker compose -f code/src/docker/docker-compose.dev.yml exec backend \
    sh -c "truncate -s 0 /workspace/src/logs/django.log"
```

## Cross-references

- `code/docs/LOGGING.md` — full logging and observability guide
- `code/workflows/10-debugging-with-logs/` — debugging workflow using logs
