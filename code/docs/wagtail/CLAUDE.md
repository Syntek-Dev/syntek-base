@./CONTEXT.md

# CLAUDE.md — code/docs/wagtail/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/docs/CONTEXT.md` →
`code/docs/WAGTAIL.md` → this folder's `CONTEXT.md` (which document, when — imported above) →
this file.

## Purpose (one line)

The six sub-documents behind `code/docs/WAGTAIL.md` — what Wagtail does, and what this project
has already decided about each part of it.

## How to work here

- **Routing:** reference guides, not code. The `stack-wagtail` skill reads them; `backend` and
  `frontend` reach them through it; `security` cites `ADMIN-AND-PERMISSIONS.md` at audit time;
  `doc-writer` maintains the prose.
- **Model:** Opus for substantive changes and mechanical touches alike.
- **Concrete steps:** change the sub-document → check `WAGTAIL.md`'s routing table still
  describes it accurately → check the `stack-wagtail` skill has not drifted from it → update this
  `CONTEXT.md` if a file is added or removed.
- **Definition of done:** every file carries the `type`/`skills`/`model` routing frontmatter with
  `skills: [stack-wagtail]`; each stays within 300 code lines; every upstream URL returns 200;
  cross-references resolve; British English.

## Guardrails

- **Verify every upstream URL before shipping it.** Wagtail's documentation has no single page
  for rich text or for editorial workflow, and the plausible URLs for both 404. A dead link in a
  guide is worse than no link, because it reads as a promise that someone checked.
- **Never use the version-pinned prefix.** `/en/stable/` is correct here. `/en/v8.0/` resolves
  but freezes; `/en/8.0/` does not resolve at all.
- **Two questions, in this order, in every file.** What Wagtail does, then what this project has
  decided. Reversing them produces a guide that reads as if Wagtail's defaults were ours.
- **Route, never restate.** The media routing invariant belongs to `code/docs/OBJECT-STORAGE.md`,
  the audit record to `code/docs/security/AUDIT-TRAIL.md`, upload validation to
  `code/docs/security/INPUT-AND-API.md`. Repeating a rule here creates a second copy that will
  drift, and this repository keeps each rule in exactly one place.
- **This template ships no Wagtail code.** Never write as though an app, model or script exists.
  The voice is "when you build this, here is how", because these guides _are_ the integration.
- **The four project rules are not negotiable in prose.** Native Willow renditions on Cloudinary
  storage; the custom image model before the first upload; the admin never at `/admin/` with the
  catch-all always last; Wagtail's log models never satisfying the audit trail. Softening any of
  them here silently overrides `code/docs/WAGTAIL.md`.
- Commands cite `code/src/scripts/**/*.sh` — never a raw `python`, `pytest`, `pip` or `uv`
  invocation, whether running one or writing one into a document.

## Output & naming

- **Hand-written:** every file here. Nothing is generated.
- Documentation `SCREAMING-KEBAB-CASE.md`, and a filename never repeats the folder — this is the
  `wagtail/` sub-document family, so `IMAGES-AND-MEDIA.md`, never `WAGTAIL-IMAGES.md`.
