# code/src/logs — Local Log Files

Runtime log files written by the Django backend in **dev only**. The dev `django` service
bind-mounts this directory (`../logs:/workspace/code/src/logs`), so the file the container writes
is the file the host reads. Test keeps no log file — console only.

The reference deployment runs Grafana Alloy shipping logs to Loki, queried with LogQL in
Grafana, and Prometheus for metrics (`how-to/src/PLATFORM-PROVIDERS.md`).

> **Staging and production do not write logs to disk.** Every line Django's `LOGGING` emits is
> JSON in every environment but test (wide here in dev, minimal on staging and production stdout,
> which Grafana Alloy ships to <%LOG_AGGREGATOR%>). Two streams stay plain text: uvicorn's dev
> access log on the console, and the process-server stream (`gunicorn.error`, `uvicorn.error`) on
> stderr. See `code/docs/logging/DJANGO-LOGGING.md`.

## Directory Tree

```text
code/src/logs/
├── CLAUDE.md     ← operating rules
├── CONTEXT.md    ← this file
├── .gitignore    ← ignores every log file written here
└── .gitkeep      ← keeps the directory in git while its contents stay out
```

The directory is tracked and its contents are not: Django's file handler needs the path to
exist before it will start, and git does not track empty directories.

## What goes here

| File                            | Written by                   | Contains                                                                     |
| ------------------------------- | ---------------------------- | ---------------------------------------------------------------------------- |
| `django.log`                    | Django `RotatingFileHandler` | Django's dev lines, one JSON object each (wide: every extra, full traceback) |
| `django.log.1` … `django.log.5` | Log rotation                 | Rotated backups (auto-generated)                                             |

All files in this directory are gitignored. Only this `CONTEXT.md` and `.gitkeep` are tracked.

## What does NOT go here

- Exception reports → <%ERROR_TRACKING%> (staging/prod) or the console (dev/test)
- uvicorn's access and error lines → the dev console only, plain text
- Metrics → Prometheus
- Aggregated logs → <%LOG_AGGREGATOR%>
- Bug reports or incident notes → `project-management/src/21-BUGS/`

## Accessing logs locally

```bash
# Follow live backend output
bash code/src/scripts/development/logs.sh --service django --follow   # the django container's stdout

# Read the log file directly on the host — the bind mount puts it here
tail -f code/src/logs/django.log

# Filter by level (each line is JSON, so match the key)
grep '"level":"ERROR"' code/src/logs/django.log
```

## Log rotation

The `RotatingFileHandler` is configured with:

- Max file size: 10 MB
- Backup count: 5 (so max 60 MB total on disk)

The dev container runs as root, so the file on the host is owned by `root` (mode 644): anyone can
read it, but deleting it from the host needs root. To manually clear logs during development, open
a shell in the `django` container and truncate the file inside it — this is the one copy of the
step:

```bash
bash code/src/scripts/development/shell.sh

# Inside the shell
truncate -s 0 /workspace/code/src/logs/django.log
```

## Cross-references

- `code/docs/LOGGING.md` — full logging and observability guide
- `code/workflows/09-debugging-with-logs/` — debugging workflow using logs
