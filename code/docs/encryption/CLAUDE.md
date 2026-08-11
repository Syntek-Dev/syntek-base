@./CONTEXT.md

# CLAUDE.md — code/docs/encryption/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The split-out detail for the field-level encryption standard — Fernet field
encryption and searchable lookup tokens for encrypted fields — behind the
`code/docs/ENCRYPTION-GUIDE.md` entry point.

## How to work here

- **Routing:** `doc-writer` (Opus) to author; consumed before adding any
  PII field, and by `gdpr` and the `06-gdpr-enforcement` workflow.
- **Model:** Opus for substantive guidance and typos or re-indexing.
- **Concrete steps:** edit the relevant sub-doc (`FIELD-ENCRYPTION.md`,
  `LOOKUP-TOKENS.md`) → keep `ENCRYPTION-GUIDE.md` a thin index and update the
  `CONTEXT.md` file table on any change → verify length with
  `code/src/scripts/audits/docs-length.sh`.
- **Definition of done:** guidance matches the shipped Fernet pipeline in
  `apps/core`; each file ≤ 300 lines; cross-references resolve; British English.

## Guardrails

- **300-line instructional limit** per file — split rather than overflow.
- **Encryption keys are secrets** — env only; never embed a key, sample key, or
  ciphertext that reveals one in the docs.
- Lookup tokens must remain deterministic-but-non-reversing as documented — never
  advise storing plaintext PII alongside an encrypted field to make search easier.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/ENCRYPTION-GUIDE.md`.
