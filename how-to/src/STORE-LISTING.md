# Store Listing — This Project's Register

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>

**Mobile-only.** Present only in a project generated with the mobile surface.

What <%PROJECT_NAME%> actually says in the App Store and on Google Play — every text field, the
value this project uses, and the budget it has to fit.

**The rule that produced this table is not here.** It lives on the build side, in
[`code/docs/discoverability/APP-STORE.md`](../../code/docs/discoverability/APP-STORE.md) — the
fields, what each is for, and the vendor documentation each limit was read from. **That guide is
authoritative; if a number here disagrees with it, the guide is right and this file is stale.**
Only the guide carries `Source:` and `Verified:` dates, because a date in two places is a date
that rots in one of them.

**This file is the answer sheet, and it is yours.**

---

## How to fill this in

1. Read [`APP-STORE.md`](../../code/docs/discoverability/APP-STORE.md) first — particularly **Section 2**,
   because Apple's keyword budget is counted in **bytes**, not characters.
2. Write each value into the **This project** column.
3. Fill the **Used** column with the real count — `len(text)` for every field except Apple
   keywords, which is `len(text.encode("utf-8"))`.
4. Enter the same values in App Store Connect and the Play Console. **They are authoritative**;
   this file is the reviewable copy, not the live one.
5. Re-check on every listing change. Nothing in this repository can verify these for you — see
   `APP-STORE.md` → _What is mechanically checkable here_.
6. **What's New / release notes is the one row that moves on every ship**, and it is
   **overwritten, not appended.** This register records what the store says _now_; the history of
   what it said before already lives on the mobile package's own track
   (`code/src/mobile/CHANGELOG.md` and `RELEASES.md`). Keeping a second copy here would give one
   history two homes, and the stale one would look as authoritative as the live one.

> **A blank cell is an unanswered question, not a default.** An unfilled row means that field is
> either empty in the store or set to something nobody in this repository has reviewed.

---

## Apple App Store

| Field                 | Limit         | This project | Used | Notes                                            |
| --------------------- | ------------- | ------------ | ---- | ------------------------------------------------ |
| App name              | 2–30 chars    |              |      | **Not** `app.json` `expo.name` — see below       |
| Subtitle              | 30 chars      |              |      | Appears under the name throughout the App Store  |
| Keywords              | **100 bytes** |              |      | Comma-separated. Never the app or company name   |
| Description           | 4000 chars    |              |      | Plain text — HTML is not supported               |
| Promotional text      | 170 chars     |              |      | Editable without a new version; use it for these |
| What's New in version | 4000 chars    |              |      | Per release; the release workflow prompts for it |

## Google Play

| Field             | Limit                                | This project | Used | Notes                                                |
| ----------------- | ------------------------------------ | ------------ | ---- | ---------------------------------------------------- |
| App name          | 30 chars                             |              |      | Characters, not bytes, at any character width        |
| Short description | 80 chars                             |              |      | The one line shown before a reader taps More         |
| Full description  | 4000 chars                           |              |      | Play indexes this; Apple does not index its own      |
| Release notes     | _read it off the Play Console field_ |              |      | Deliberately unpinned — see `APP-STORE.md` Section 1 |

---

## The two names, and why they are separate rows

| Name               | Where it is set                          | This project          |
| ------------------ | ---------------------------------------- | --------------------- |
| On-device name     | `code/src/mobile/app.json` → `expo.name` | `<%MOBILE_APP_NAME%>` |
| Store listing name | App Store Connect / Play Console         | _(fill in above)_     |

They are different fields and can hold different strings. If they differ, record **why** here —
`APP-STORE.md` Section 3 treats a divergence as a decision, never as a default.

---

## What is deliberately not in this register

| Concern                                            | Where it is answered                                     |
| -------------------------------------------------- | -------------------------------------------------------- |
| Screenshots, preview video, the app icon           | `code/docs/visual-design/MOBILE.md`                      |
| Privacy nutrition labels, Data Safety declarations | `project-management/src/09-GDPR/`                        |
| The register the copy is written in                | `how-to/src/BRAND-VOICE.md` Section 5                    |
| Why each field exists and what its limit is        | `code/docs/discoverability/APP-STORE.md`                 |
| Keyword research, competitor analysis, reviews     | **Nothing here.** Growth activities, ruled out repo-wide |

---

## Cross-references

- [`code/docs/discoverability/APP-STORE.md`](../../code/docs/discoverability/APP-STORE.md) — the
  rule this register answers, and the only place the limits carry a verification date
- [`BRAND-VOICE.md`](BRAND-VOICE.md) Section 5 — store-listing copy is the marketing register under hard
  constraints, owned by `stack-react-native`
- `project-management/workflows/23-release/` — the release procedure that prompts for the What's
  New row. It fires on a **mobile package bump**, not on every release: a root-only bump reaches
  no store, so most releases never touch this file
- [`PLATFORM-PROVIDERS.md`](PLATFORM-PROVIDERS.md) · [`INVARIANTS.md`](INVARIANTS.md) — the other
  per-project answer sheets, same rule-elsewhere/answer-here split
