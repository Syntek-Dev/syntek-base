---
type: guide
agent: cicd
skills: [global-workflow]
model: opus
---

# Celery First-Run Review — Enabling the Worker & Beat per Environment

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB) **Timezone**: {{TIMEZONE}}
**Claude Model:** opus — first-run rollout review for the Celery worker + beat schedule

> **Read this before you first start the Celery `worker`/`beat` in any long-lived
> environment (dev → staging → prod).** A never-started `worker`/`beat` means the
> schedule is **inert** — nothing fires anywhere until each environment is **redeployed**
> with the `worker`/`beat` services actually running. Starting those services is the
> deliberate enablement act. Enable **one environment at a time**, each with the review
> below — never a silent flip.

Cross-references: this project's `CELERY_BEAT_SCHEDULE` (`config/settings` — the task
list and source of truth), `how-to/docs/FEATURE-DEPLOY.md` (the wider feature-rollout
deploy review), and `GAPS.md` (any open `<GAP-…>` first-run enablement entries).

---

## 1. Why a first run is different

A schedule that has **never fired in a long-lived environment** does not act on "today's"
data on its first tick — it acts on the **entire historical backlog at once**. A daily
retention sweep dormant for months will, on its first run, process every row that has aged
past the retention window in that whole period. Two distinct backlogs matter:

- **Row backlog** — periodic sweeps (`beat`) act on every over-age row in a single pass.
- **Queued-task backlog** — because tasks are **not** eager outside `test`
  (`CELERY_TASK_ALWAYS_EAGER=True` is `test` only), every `.delay()` since the broker was
  provisioned has been enqueued to Valkey with **no worker to drain it**. The moment the
  `worker` first connects it drains **all** of it — including any stale outward-facing
  sends (emails, search-engine pings, webhooks). Inspect / purge the queue before first
  start (§4).

The remedy is a deliberate, reviewed, **env-by-env** enablement — never a silent flip.

---

## 2. Rollout order

Enable in this order, repeating the review at each step:

1. **dev** — local, safe: a local mail-capture tool holds outbound email, the outward-send
   gate is empty/off (no outward submission), no real subjects. Prove `worker`/`beat` run
   Celery and tasks execute.
2. **staging** — confirm the email backend is not pointed at a live customer inbox and the
   outward-send gate is empty/off **before** starting the worker. Then enable.
3. **prod** — only after staging is clean. Run the destructive-sweep dry-run count (§3.1)
   **first**.

Nothing happens until the environment is redeployed with the worker/beat services running
— starting them is the deliberate enablement act.

---

## 3. First-run review — every scheduled task, by class

Source of truth: this project's `CELERY_BEAT_SCHEDULE` (`config/settings`). Reconcile every
entry against the classes below and review each on its **first** run in an environment that
has never run it. The **class** sets the risk:

| Task class                                                                               | Typical schedule    | First-run effect on a never-run environment                                        | Risk / gate                                         |
| ---------------------------------------------------------------------------------------- | ------------------- | ---------------------------------------------------------------------------------- | --------------------------------------------------- |
| **Destructive retention / PII sweep** — erase or null PII on over-age rows               | daily               | Acts on the **whole** historical backlog of over-age rows in one irreversible pass | **HIGHEST — run the dry-run count first (§3.1)**    |
| **Outward-facing send** — email, search-engine ping, webhook                             | event-triggered     | Drains and sends the **whole** queued/over-age backlog outward on first connect    | **High — gate the channel before first drain (§4)** |
| **Expiring-file cleanup** — delete blobs past their TTL from the object store            | hourly / daily      | Deletes every expired file accumulated across the dormant period                   | Medium — deletes real files; only expired rows      |
| **Cache / index regen** — rebuild a cache file or search index                           | daily               | One local rebuild (atomic temp-swap); no outward call                              | Low — local write only                              |
| **Benign maintenance** — keyspace sweeps, id-only fan-out, fault-swallowing housekeeping | frequent (~seconds) | Negligible; swallows faults                                                        | Benign                                              |

Any single project task can span classes (e.g. a sweep that both nulls PII **and** deletes
files) — take the **highest** risk that applies.

### 3.1 Highest risk — destructive sweeps (dry-run count first)

A destructive retention / PII sweep is irreversible and bulk. In prod (and any env with
real data) run a **read-only count** in a Django shell **before** enabling the schedule,
and confirm the number is expected. Parameterise the model and the age predicate for the
specific sweep under review:

```python
from datetime import timedelta

from django.utils import timezone

from apps.<app>.models import <Model>  # the model the sweep erases

cutoff = timezone.now() - timedelta(days=RETENTION_DAYS)  # from settings
candidates = <Model>.objects.filter(<age_field>__lt=cutoff)  # + any "still holds PII" predicate
print("would act on:", candidates.count())
```

Reach a Django shell:

- **dev** — `bash code/src/scripts/development/shell.sh` (backend service), then
  `python manage.py shell`.
- **staging / prod** — run the same read-only count in that environment's Django shell via
  the `{{DEPLOY_REPO}}` runbooks.

If the count is a surprising backlog, hold the schedule and confirm the retention decision
with {{DEVELOPER_NAME}} before the first tick. Repeat the count-first check for **every** destructive
sweep in the schedule, swapping in that sweep's model and predicate.

### 3.2 Verify every beat entry resolves to a registered task

Before enabling `beat`, confirm each `CELERY_BEAT_SCHEDULE` entry's task **name** matches a
task the worker actually registers. A name mismatch is silent while beat is dormant, but
once beat runs the worker logs `Received unregistered task` on every tick and that job
never executes. A name fix lives in `config/settings` — hand off to `backend` and land it
**before** enabling beat.

---

## 4. Queued-task backlog — the worker drains everything on first connect

Outward-facing sends are usually **not** beat-scheduled — they are event-triggered
`.delay()` calls queued on the request path (`transaction.on_commit`). With no worker they
accumulate in Valkey; the first worker to connect drains the **whole** queue. Typical
channels:

- **Outward email** — verification / password-reset / invitation / notification sends.
- **Search-engine ping / webhook** — submits published URLs or fires outbound webhooks to
  third parties (outward-facing).

**Gating to confirm before starting the worker:**

- **Email backend** — dev routes to a **local mail-capture tool** (held, never outward).
  Staging/prod use the real `EMAIL_BACKEND` (SMTP). Confirm staging is not pointed at a
  live customer inbox, or that draining a stale backlog of sends is acceptable, before
  first start.
- **Outward-send gate** — each outward channel is gated by a key/flag (e.g. a
  search-engine ping key or webhook secret). The send path returns early when the gate is
  empty/unset, so **no** submission is ever queued while it is off. Keep the gate **off in
  dev/staging**; set it **only in prod**. This keeps outward submission a prod-only action.
- **Purge stale messages if needed** — where a stale backlog may exist, inspect the queue
  depth and purge it before the worker starts, so nothing drains first. In the worker
  container the underlying operation is `celery -A config purge -f`; run it **before** the
  `worker` service is started.

---

## 5. Per-environment enablement checklist

Run top-to-bottom for each environment in turn (dev → staging → prod):

1. **Verify beat task names** — every `CELERY_BEAT_SCHEDULE` entry resolves to a registered
   task; any mismatch fixed and merged (§3.2).
2. **Confirm gating** — email backend and every outward-send gate correct for the env (§4).
3. **Dry-run count** — every destructive sweep's count reviewed and expected (§3.1).
4. **Queue hygiene** — inspect / purge the Celery queue if a stale backlog may exist (§4).
5. **Redeploy** — pull the fixed image; the entrypoint now honours the `worker`/`beat`
   `command:`. On staging this also brings up any newly-added `worker`/`beat` services.
6. **Start & verify** — start `worker` + `beat`; confirm PID 1 in each container is Celery,
   not the web server (inspect `/proc/1/cmdline`; expect `celery -A config worker …`;
   repeat for `beat`). On dev, reach the container via
   `bash code/src/scripts/development/shell.sh`.
7. **Watch the first ticks** — tail the logs
   (`bash code/src/scripts/development/logs.sh` on dev; the `{{DEPLOY_REPO}}` runbooks on a
   server) and confirm the sweeps report expected counts and no `unregistered task` errors,
   then move to the next environment.

---

## 6. GAPS cross-reference

- Track the deliberate per-environment enablement as a `<GAP-…>` entry in `GAPS.md` until
  every environment is live — {{DEVELOPER_NAME}}'s rollout call. Owner: `cicd`.
- Any beat task-name fix (§3.2) is a separate `<GAP-…>` in `config/settings`. Owner:
  `backend`.
