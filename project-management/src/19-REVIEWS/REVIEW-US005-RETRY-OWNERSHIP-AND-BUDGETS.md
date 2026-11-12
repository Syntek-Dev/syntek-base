# Code Review — US005 Exactly one layer decides to retry, and every budget says how long it may take

**Last Updated**: 12/11/2026 · **Story**: US005 · **Status**: In Review

| Field        | Value                                                                                                                                                                                                                                                                    |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Story**    | US005 — exactly one layer decides to retry, and every budget says how long it may take                                                                                                                                                                                   |
| **Branch**   | `us005/retry-ownership-and-budgets` (cut from `testing` at `eb902ea`; build `3be34d9`, `c5f0f59`, `23fd139`, `d980aeb`; sign-off `11653bc`; review fixes `1349a18`, `9e65a76`, `27720b7`; re-walk `f290d43`)                                                             |
| **PR**       | One PR carrying every commit (Sam, 12/11/2026) · target `testing`                                                                                                                                                                                                        |
| **Reviewer** | Claude — at `23-pr-and-review`, an independent `qa-tester` (Step 1) and `review` → `code-reviewer` (Step 2) pass at `11653bc`, each finding put to an adversarial verifier; then an independent verifier of each fix round. None of them wrote the doctrine or the fixes |
| **Date**     | 12/11/2026                                                                                                                                                                                                                                                               |
| **Verdict**  | No blocker. 3 Medium and 5 Low confirmed at Steps 1-2, 2 refuted; 1 Medium and 6 Low/Info raised by the fix-round verifier. **Every one fixed in this PR** (Sam, 12/11/2026). Awaits Sam's reviewer approval                                                             |

**Codes from:** `../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` → _Key
Decisions_ and its "Added 11/11/2026", "Added 12/11/2026" and "Settled 12/11/2026" sections — every
ruling there is Sam's, and none is re-raised here.
**Story:** `../02-STORIES/US005.md` — the acceptance criteria this review judges against.

---

## 1. Scope & files reviewed

Markdown doctrine, a bash audit and its fixtures, one Prettier leg, the copier contract and one
`.github/scripts` gate. No Python, template, endpoint, migration or UI.

| File                                                                                  | Change                                                                                                     |
| ------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `code/docs/reliability/RETRIES.md` · `BUDGETS.md` (new) · `code/docs/RELIABILITY.md`  | The US005 doctrine: one retry owner, the budget table, the persisted schedule; review fixes R-01 to NEW-07 |
| Surface guides (`TASK-AUTHORING.md`, `WEBHOOKS.md`, `TOOL-DESIGN.md`, and siblings)   | Repaired to route to the family rather than restate it                                                     |
| `code/src/scripts/audits/doc-references.sh` + fixtures                                | `[template artefact]` class; review fixes QA-01, QA-05, R-06, NEW-07                                       |
| `code/src/scripts/syntax/format.sh`                                                   | `yaml` and `json` legs                                                                                     |
| `copier.yml` · `.github/scripts/shipped-artefacts.sh` · `doc-references-shipping.txt` | ClickUp exports never ship; only the README is re-included (QA-01)                                         |

---

## 2. Findings

### 2.1 Steps 1-2 — `qa-tester` and `code-reviewer` at `11653bc`; fixed in `1349a18`

| ID    | Severity | File:line                                                 | Issue                                                                                                      | Resolution/Status             |
| ----- | -------- | --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ----------------------------- |
| R-02  | Medium   | `RETRIES.md:162` vs `BUDGETS.md:42`                       | `RemoteThrottled` is a `DependencyUnavailable`, so the default form retried a 429/503 before `Retry-After` | Fixed — `1349a18`, option (a) |
| R-01  | Medium   | `BUDGETS.md:109-121`                                      | Start guard let an attempt start late in its `t + q` lease; failure write unconditional                    | Fixed — `1349a18`             |
| R-03  | Medium   | `BUDGETS.md:85-87` vs `RETRIES.md:138`                    | Two `expires` rules (`T` and `first_attempt_at + T - t`); merged with QA-03                                | Fixed — `1349a18`             |
| QA-03 | Low      | as R-03; `RETRIES.md:218-221`                             | An expired Celery message is `REVOKED`, never reaching the exhaustion outcome                              | Fixed — `1349a18`             |
| QA-02 | Low      | `../18-TESTS/AUTOMATED/US005-TEST-STATUS.md:139,159`      | Survivor table and status line still read 29 after F-001                                                   | Fixed — `1349a18`             |
| QA-01 | Low      | `copier.yml:119-121`; `shipped-artefacts.sh:88`; the gate | A phantom ClickUp `CONTEXT.md`/`CLAUDE.md` pair re-included; an absent re-included path went unchecked     | Fixed — `1349a18`             |
| R-04  | Low      | `BUDGETS.md:98-100`                                       | "In the same transaction as that enqueue" read as enqueueing inside the transaction                        | Fixed — `1349a18`             |
| R-06  | Low      | `doc-references.sh` header; `FORWARD-VOICE.md:110`        | The "artefact trees today" lists named four; the derivation reads five                                     | Fixed — `1349a18`             |
| QA-05 | Low      | `doc-references.sh:1209`                                  | The decision-identifier sweep was case-sensitive                                                           | Fixed — `1349a18`             |

### 2.2 Fix-round verification of `1349a18`; fixed in `9e65a76` and `27720b7`

The verifier confirmed all nine above resolved, checked the Celery claims against the 5.7.0 source
and docs, and raised:

| ID     | Severity | File:line                               | Issue                                                                                 | Resolution/Status                 |
| ------ | -------- | --------------------------------------- | ------------------------------------------------------------------------------------- | --------------------------------- |
| NEW-01 | Medium   | `RETRIES.md` _Honouring `Retry-After`_  | Under option (a) a bare 503 on the default form was never retried                     | Fixed — `27720b7`, Sam option (i) |
| NEW-02 | Low      | `US005-TEST-STATUS.md:110,159`          | Self-test count 228 after the QA-01 probe made it 229                                 | Fixed — `9e65a76`                 |
| NEW-03 | Low      | `BUDGETS.md` _The declarative default_  | The copyable default names `RemoteThrottled` without saying it is not yet built       | Fixed — `9e65a76`                 |
| NEW-04 | Low      | `BUDGETS.md` declarative total-age line | The `expires` deadline read the Default row's derived `T`, which leaves no queue room | Fixed — `9e65a76`                 |
| NEW-05 | Low      | `BUDGETS.md` persisted-schedule insert  | `now()` is the transaction start, so a long transaction ate into `q`                  | Fixed — `9e65a76`                 |
| NEW-06 | Info     | `BUDGETS.md` lost-publish recovery      | The recovery costs one of `n` attempts, unstated                                      | Fixed — `9e65a76`                 |
| NEW-07 | Info     | `doc-references.sh` catch-all arm       | Resolving re-included paths were tested but not counted                               | Fixed — `9e65a76`                 |
| NEW-08 | Low      | `RETRIES.md` _Honouring `Retry-After`_  | An unparseable `Retry-After` had no stated class                                      | Fixed — `01f1563`                 |
| NEW-09 | Low      | `RETRIES.md` header-aware row prose     | The declarative arm omitted a bare 429; "there" had two antecedents                   | Fixed — `01f1563`                 |
| NEW-10 | Low      | `RETRIES.md:147-151`                    | Missing-counts-as-0 and "with or without" now hold on the persisted schedule only     | Fixed — `01f1563`                 |
| NEW-11 | Low      | `BUDGETS.md` _Overrides_                | The legitimacy test did not admit the numeric-`T` override NEW-04 requires            | Fixed — `01f1563`                 |

The verification of `9e65a76` and `27720b7` raised NEW-08 to NEW-11; its check of `01f1563` and
`b2b317d` returned **APPROVE** with one non-blocking nit (`RETRIES.md:190` comment reads "carrying"
rather than "a usable" `Retry-After`; still true, since the class exists only with a parsed value).

### 2.3 Refuted, not recorded as defects

- **QA-04** — check 6 tests leaks only: already F-025 and its `GAPS.md` row.
- **R-05** — "tracked separately" wording: covered by F-004, which Sam accepted 12/11/2026.

---

## 3. Dimension checklists

### 3.1 Security (OWASP)

- [x] N/A — no endpoint, permission path or ID lookup. `Retry-After` as untrusted input is a
      doctrine control (`RETRIES.md` _Honouring `Retry-After`_), reviewed under R-02 and NEW-01.

### 3.2 GDPR / PII

- [x] N/A — no personal data processed. The retention example drops automatic retry (Sam, Q3);
      attempt logs and failure records carry identifiers only.

### 3.3 Test coverage vs floors

- [x] N/A — no code path, no suite (`US005.md` _Verification Checks_). Stand-ins: `doc-references.sh
--self-test` 229 probes, exit 0; the manual guide, re-walked after each fix round.

### 3.4 Quality, DRY & file length

- [x] One rule, one home — `doctrine-drift.sh` exit 0 on 4 claims; R-03 removed the one duplicate.
- [x] `docs-length.sh` exit 0, 808 files; the reliability family within 300.
- [x] `format.sh` clean (Prettier and rustfmt); `lint.sh` clean on every Markdown file the branch
      edits. Its whole-tree run fails only on the gitignored `graphify-out/`, which is not this branch's.
- [ ] ShellCheck **not run locally** — no project script wraps it; CI's job is the evidence.

### 3.5 Performance

- [x] N/A — no query or hot path.

### 3.6 Accessibility (WCAG 2.2 AA)

- [x] N/A — no user-facing UI in this story.

---

## 4. Required actions before merge

| Action                                                  | Finding      | Owner  | Status                                             |
| ------------------------------------------------------- | ------------ | ------ | -------------------------------------------------- |
| Re-walk the rows `9e65a76` and `27720b7` touch          | NEW-01 to 07 | Claude | Done — 21 rows, all Pass (`7c409d3`)               |
| Confirm the countersignature covers the re-walked guide | —            | Sam    | Done — 12/11/2026                                  |
| Reviewer approval                                       | —            | Sam    | Done — 12/11/2026, on the agent reviewer's APPROVE |

---

## 5. Verdict & status transition

- **Verdict:** **Approve-with-nits** — Sam's reviewer approval 12/11/2026, given on the agent
  reviewer's APPROVE at `b2b317d`; the one nit is above.
- **Reasoning:** every confirmed finding is fixed and independently verified; the gates stand at
  the 28-finding baseline with no new class.
- **Status transition:** `In Progress → In Review` at Step 3 (12/11/2026). `Accepted` is
  recorded when the PR's CI passes and it merges into `testing`.

---

## 6. Notes

- **Gate evidence, `b2b317d`** (agent reviewer, clean worktree; the remaining figures at `27720b7`): `doc-references.sh` exit 1 on 28 `[dangling path]`, 0 other;
  `--self-test` exit 0, 229 probes; `docs-length.sh`, `doctrine-drift.sh`, `docs-pairing.sh` exit 0;
  `shipped-artefacts.sh` exit 0 on renders with `INCLUDE_CLICKUP` true and false, self-test 8/8;
  `template-render.sh --check-references` exit 0 downstream (at `1349a18`'s tree).
- **The first walk could not have caught R-02**: no row checked which exceptions the declarative
  tuple catches. Recorded as an edge case in the QA record.
- **Celery facts** were read from the Celery docs (context7) and the 5.7.0 source: `dont_autoretry_for`
  since 5.3; an expired message `REVOKED` with `task_revoked(expired=True)`; `Retry` re-raised
  before `autoretry_for` is matched; `expires` carried into the retry signature.

---

## Cross-references

- `../02-STORIES/US005.md` — the story under review
- `../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — the plan
- `../18-TESTS/AUTOMATED/US005-TEST-STATUS.md` · `../18-TESTS/MANUAL/US005-MANUAL-TESTING.md` — the
  test records
- `../11-QA/IMPLEMENTATION/QA-IMPL-US005-RETRY-OWNERSHIP-AND-BUDGETS-12-11-2026.md` — the paired QA record
- `../20-FINDINGS/FINDING-US005-RETRY-OWNERSHIP-AND-BUDGETS-12-11-2026.md` — the story's findings
- `project-management/workflows/23-pr-and-review/` · `code/workflows/07-review/`
