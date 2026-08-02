---
type: guide
agent: desktop
skills: [stack-slint]
model: opus
---

# Desktop Licensing — the Slint Obligation

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB)

What the Royalty-free tier permits, what it demands in return, and the two things it does not
cover. Index: [`../DESKTOP.md`](../DESKTOP.md).

> **This is a reading of the licence text, not legal advice.** Before committing a product line to
> it, have a solicitor confirm it — particularly the embedded exclusion if any target is not a
> general-purpose computer.

---

## The three tiers

| Tier             | Cost | Permits                                                       |
| ---------------- | ---- | ------------------------------------------------------------- |
| **Royalty-free** | Free | Proprietary desktop, mobile and web apps — **including sale** |
| **GPL-3.0**      | Free | Open-source apps under GPL-compatible terms; also embedded    |
| **Commercial**   | Paid | Proprietary apps **including embedded**, on your own terms    |

<%PROJECT_NAME%> takes the **Royalty-free** tier.

## Selling the app is fine

This is the point most often got wrong. The paid Commercial licence is triggered by **embedded
systems**, not by charging money. An application running on a user's own general-purpose computer
or phone, installed as one application among many, qualifies for the Royalty-free tier **however
it is sold** — subscription, one-off purchase, or bundled with a managed service.

## What you owe in return: disclosure

The Royalty-free grant is conditional on disclosing that you use Slint. Either satisfies it:

1. **In-app** — the `AboutSlint` widget in an About screen or dialog reachable from the top-level
   menu, or in a splash screen. **This is what the baseline app does.**
2. **On the web** — the Slint attribution badge on a public page, preferably where the binaries can
   be downloaded.

`code/src/scripts/desktop/package.sh` **refuses to build a release binary** without it. The check
matches the widget _instantiation_ (`AboutSlint {`) after stripping `//` comments, because two
things keep the bare word in the file when the widget is gone — the comment explaining the
obligation, and the `import { ..., AboutSlint }` line.

It still cannot prove the widget is **reachable** in the running UI, only that it is instantiated.
If you restructure the UI, confirm by eye that a user can still get to it.

Removing the disclosure without a Commercial licence is a breach of the grant, which means the app
falls back to having no licence to use Slint at all.

## The two exclusions

### Embedded systems

Not covered. The FAQ defines an embedded system as "a computer system designed to perform a
specific task within a larger mechanical or electrical system" — an appliance screen controller, a
point-of-sale terminal, a car dashboard. Any of those needs the Commercial licence.

If a future target is a kiosk or a purpose-built device rather than a general-purpose computer,
that is a licence change, and it is a **cost** decision to make before the port, not after.

### Redistributing anything that exposes Slint's APIs

The grant "does not permit the distribution of Application that exposes the APIs, in part or in
total, of the Software", nor distributing Slint "alone and without integration into an
Application".

**This is why desktop components are not in the shared package layer.** A reusable UI component
library built on Slint and published for others to build with is precisely a thing that exposes
Slint's APIs. It would also not be an open-source licence, so such packages could not carry the
permissive licence a foundation layer needs.

The consequence, accepted knowingly: **desktop UI is not shared between applications.** Each app
builds its own panels. That duplication is the price of the Royalty-free tier, and it was chosen
over the alternatives (a Commercial licence fee, or a toolkit with a thinner widget set).

## How this is recorded in the audit

`code/src/rust/deny.toml` carries a **per-crate exception** for each Slint crate rather than adding
`LicenseRef-Slint-Royalty-free-2.0` to the general allow-list:

```toml
[[licenses.exceptions]]
crate = "slint"
allow = ["LicenseRef-Slint-Royalty-free-2.0"]
```

That is deliberate. A conditional licence carrying an obligation should be impossible to acquire by
accident for some unrelated dependency — naming each crate keeps the decision visible to anyone
reading the policy, and makes a new Slint-licensed crate appearing in the tree an event that fails
the audit until someone looks at it.

## If the terms change

Slint added the Royalty-free tier after the project's earliest design notes were written, which is
exactly why those notes said GPL-3.0 was the only free option. Treat this document the same way:
re-read the upstream licence before a release that meaningfully expands where the app runs.

Sources: `LICENSES/LicenseRef-Slint-Royalty-free-2.0.md` and `FAQ.md` in the Slint repository.

## Cross-references

- [`UI-AND-STATE.md`](UI-AND-STATE.md) — where the attribution widget sits in the markup
- [`../DESKTOP.md`](../DESKTOP.md) — the guide index
- `code/docs/rust/SUPPLY-CHAIN.md` — the wider dependency policy this fits inside

_Part of the `code/docs/desktop/` sub-document family._
