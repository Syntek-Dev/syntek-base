# Security Policy

## What this repository is

`syntek-base` is a **project template**. It ships documentation, configuration, Claude Code agent
definitions, and a Django application skeleton. It runs no service, hosts no data, and has no
users. Nothing here is deployed anywhere by us.

That shapes what a vulnerability means in this context. The realistic risk is not "an attacker
compromises syntek-base" — it is **an insecure default propagating into every project generated
from it**. Those are the reports we care most about.

## Reporting a vulnerability

**Do not open a public issue for a security problem.**

Use GitHub's private vulnerability reporting:

1. Go to the [Security tab](https://github.com/Syntek-Dev/syntek-base/security)
2. Choose **Report a vulnerability**

That opens a private advisory visible only to you and the maintainers. If you cannot use it,
email **security@syntekstudio.com** instead.

Please include:

- The file or template default at fault, with a path
- What a project generated from it would end up doing
- A concrete attack, not a category name — how it is reached and what it yields
- The version or commit you looked at

## What we will do

| Stage                | Target                                       |
| -------------------- | -------------------------------------------- |
| Acknowledgement      | 3 working days                               |
| Initial assessment   | 10 working days                              |
| Fix or stated remedy | depends on severity, communicated in writing |

We will tell you what we conclude, including when we decide something is not a vulnerability and
why. If you would like credit in the advisory, say so and we will name you.

We do not operate a paid bug bounty.

## In scope

- Insecure defaults in the template that carry into generated projects — permissive CORS, a
  weak or missing permission check in the skeleton, a secret committed to the tree, an unsafe
  Django setting, a Dockerfile or Compose default that exposes a service
- Anything undermining the security guarantees the docs claim (`code/docs/SECURITY.md`,
  `code/docs/RLS-GUIDE.md`, `code/docs/ENCRYPTION-GUIDE.md`)
- Supply-chain problems in what the template pins — a malicious or compromised dependency in
  `pyproject.toml` / `package.json`, or a GitHub Actions workflow that can be made to run
  untrusted code with write permissions
- Anything in `copier.yml` that lets a template author execute unintended code at generation
  time beyond the documented `_tasks`

## Out of scope

- **Copier's `--trust` requirement.** Generating a project runs the `_tasks` in `copier.yml`.
  This is by design and documented; running a template means running its post-generation tasks.
  Read them before you generate — they are short and deliberately legible.
- Vulnerabilities in a project _you_ built from this template. That project is yours; this
  template is MIT and comes with no warranty. Report those to whoever maintains it.
- Findings from an automated scanner with no demonstrated impact on the template or on what it
  generates.
- The absence of a control the documentation explicitly defers — the deferred-infrastructure
  register in `code/docs/DATABASE.md` and `DEFERRED.md` record these deliberately.
- Security of third-party services the template integrates with (Cloudinary, Sentry, GitHub).
  Report those to the vendor.

## Security posture of generated projects

The template's non-negotiable security rules live in `.claude/CLAUDE.md` §6 and are enforced in
`code/docs/SECURITY.md`. In summary, a project generated from this template is expected to:

- put an explicit permission check on every state-changing Django Ninja endpoint (OWASP A01)
- verify user-supplied IDs against the caller's ownership (no IDOR)
- enforce data invariants in the database, not only in application code
- run with `DEBUG=False` outside local development
- use an explicit `CORS_ALLOWED_ORIGINS` allowlist, never `*`
- take every secret from the environment, never a committed file
- mount Django admin at a non-obvious path, never `/admin/`

If you find the template shipping something that contradicts one of these, that is a valid report
under **In scope** above.

## Supported versions

Only the latest commit on `main` is supported. This is a template — there are no maintained
release branches, and a fix lands as a new commit that live projects pick up with
`copier update`.
