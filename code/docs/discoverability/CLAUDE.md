@./CONTEXT.md

# CLAUDE.md — code/docs/discoverability/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table + the seam this sits on, imported above) → this file.

## Purpose (one line)

The split-out detail for the discoverability standard — per-page metadata, JSON-LD structured
data, and the root/`.well-known` surface — behind the `code/docs/DISCOVERABILITY.md` entry point.

## How to work here

- **Routing:** `seo` (Opus) to author; `doc-writer` (Opus) for restructuring. These guides govern
  the SEO wiring in `project-management/workflows/20-frontend-code/` and are the method side of
  `workflows/12-seo-checks/`.
- **Model:** Opus throughout — implementation doctrine, not planning.
- **Concrete steps:** edit the relevant sub-doc → keep `../DISCOVERABILITY.md` a thin index and
  update the `CONTEXT.md` file table on any change → verify with
  `bash code/src/scripts/audits/docs-length.sh`.
- **Definition of done:** each file ≤ 300 lines; cross-references resolve; British English; the
  checklist and these guides do not state the same rule twice.

## Guardrails

- **Never restate a checklist requirement here, and never state a method there.**
  `project-management/docs/SEO-CHECKLIST.md` owns _what must be true per page_; these documents
  own _how this stack does it_. A rule written on both sides drifts, and the copy is believed as
  readily as the original — the failure `code/docs/DOCUMENTATION-PAIRING.md` exists to prevent.
- **The ownership sentence names both halves.** A bare cross-reference is not a bridge: it says
  two documents are related without saying which one is wrong when they disagree
  (`architecture/BUILD-OPERATE-SEAM.md`).
- **Do not re-document what another guide owns** — Core Web Vitals belong to
  `performance/FRONTEND-PERFORMANCE.md`, ops endpoints to `logging/HEALTH-CONTRACT.md`, mail DNS
  and ACME to `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`. Cite, never copy.
- **`robots.txt` is not a security control.** Never present a `Disallow` rule as protection;
  anything that must not be reached is blocked at the edge.
- **`/admin/` and `/portal/` stay out of every sitemap and indexable surface** — a
  non-negotiable, not a preference.
- The register in `ROOT-SURFACE.md` Section 3 is the enumeration of the root surface. Adding a root
  file without adding its row leaves a file nobody owns.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/DISCOVERABILITY.md`.
- A surface-specific sub-document (e.g. app-store listing) is **copier-gated**, never templated
  in or out of a shared file — the mechanism that gates `visual-design/MOBILE.md`.
