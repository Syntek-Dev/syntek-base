# VULN Plan — US000 {VULNERABILITY TITLE}

_Template — copy to `VULN-PLAN-US###-<DESCRIPTOR>.md`, replace every `[EXAMPLE]` row
and `{PLACEHOLDER}` with this story's own analysis, and delete this note once populated.
This is the **pre-implementation** vulnerability record — the sprint-blocking finding for
a single Critical/High vulnerability tied to one story; its post-implementation
counterpart is `../IMPLEMENTATION/VULN-IMPL-US000-TEMPLATE.md`._

| Field             | Value                                                                 |
| ----------------- | --------------------------------------------------------------------- |
| **Vulnerability** | {short human-readable name — the finding, not the story}              |
| **Finding ID**    | {internal ref, e.g. `VULN-{n}` or `{SCOPE}-{n}`}                      |
| **Story**         | US### — {short title}; blocks {US### / SPRINT-##}                     |
| **Discovered**    | {DD/MM/YYYY} — {source: planning audit / STRIDE review / code review} |
| **Source**        | {originating audit or threat-model path that raised this}             |
| **Author**        | {name / agent}                                                        |
| **Status**        | Open — sprint blocker                                                 |

> This folder tracks **Critical/High only**. A finding here is a sprint blocker: a
> remediation story must be in the sprint plan before implementation begins, and the
> matching `../IMPLEMENTATION/` closure must exist before that story ships.

---

## 1. Classification

The three frameworks applied to this finding — one row.

| Severity       | STRIDE                     | OWASP Top 10 (2025)              | NIST CSF 2.0 function |
| -------------- | -------------------------- | -------------------------------- | --------------------- |
| [EXAMPLE] High | I — Information Disclosure | A01:2025 — Broken Access Control | PR (Protect)          |

_Record the severity (Critical / High), the STRIDE category (one or more of S/T/R/I/D/E),
the OWASP A01–A10 reference, and the NIST CSF 2.0 function (GV/ID/PR/DE/RS/RC) this
finding maps to. Multiple STRIDE letters are allowed where the finding spans classes._

## 2. Description

What the vulnerability is, the invariant it breaks, the entry point, and the concrete
impact. One paragraph per distinct finding.

- **[EXAMPLE] {Finding}** — {a caller reaches {resource} via {entry point} without the
  {control} that should gate it, disclosing / tampering / elevating to {impact}}.

_State the broken invariant, the reachable entry point, and the realistic impact. No live
payloads, secrets, or tokens._

## 3. Affected code

Where the weakness lives — paths, symbols, tables, or design artefacts only. No secrets.

| Location                                | What is exposed                           |
| --------------------------------------- | ----------------------------------------- |
| [EXAMPLE] `{path/to/file}` · `{symbol}` | {the vulnerable resolver / policy / view} |

_One row per affected file, resolver, RLS policy, or data store. Paths under `code/`
are references only — never paste code or configuration here._

## 4. Proof of concept (safe)

A safe, **non-working** description only — enough to prove the finding, never enough to
arm it. Never a live exploit payload, secret, or token.

- [EXAMPLE] {Authenticated as {role A}, request {role B}'s {resource} by `{id}`. Correct
  behaviour: the request is denied / returns not-found and writes a WARNING audit entry.
  A leak returns {what should not be visible}.}

_Describe the reproduction at the level of "which request, expected vs actual outcome" —
no operable exploit string._

## 5. Recommendation (required controls)

The controls the remediation story must implement. Each becomes an explicit, testable
acceptance criterion on the remediation story, and is closed with evidence in the
`../IMPLEMENTATION/` record.

- [ ] [EXAMPLE] {Enforce {control} at {layer}; fail-safe default is {deny / no rows}.}
- [ ] [EXAMPLE] {Add {test} asserting the exploit path is blocked and audited.}

## 6. Remediation ownership

Which story carries which control, and any governance prerequisite (e.g. explicit
sign-off, a dependency story) that must clear before the fix can land.

- {Control(s) → US###}; {prerequisite / sign-off, if any}.

## 7. Status

Open — sprint blocker. Closure recorded in
`../IMPLEMENTATION/VULN-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` once the fix is verified
in code and this record is flipped to Resolved.

---

## Cross-references

- `../IMPLEMENTATION/VULN-IMPL-US000-TEMPLATE.md` — the post-implementation closure record
- `../../AUDITS/PLANNING/` · `../../THREAT-MODEL/PLANNING/` — the sibling categories this
  finding is escalated from
- `../../ASSESSMENTS/PLANNING/` — the posture assessment that references this finding
- `../../../01-STORIES/` — the remediation story being planned
- `project-management/docs/SECURITY-GUIDE.md` — the governing STRIDE / OWASP / NIST guide
- `project-management/workflows/09-security-checks/` — the workflow that produces this
