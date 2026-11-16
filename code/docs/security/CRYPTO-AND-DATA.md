---
type: guide
skills: [security, stack-django, stack-htmx-templates]
model: opus
---

# Security — Cryptography, Data Classification, and Browser Storage

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Crypto algorithm selection, data classification, browser storage security

---

## Cryptography and Encryption Standards

Use well-established, vetted cryptographic libraries. Never implement cryptographic primitives from
scratch.

### Approved algorithms

| Purpose                                | Algorithm                              | Notes                                                                                                                      |
| -------------------------------------- | -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Password hashing (1st choice)          | argon2id                               | Minimum: m=19456 (19 MiB), t=2, p=1. Recommended: m=47104 (46 MiB), t=1, p=1. High security: m=131072 (128 MiB), t=3, p=4. |
| Password hashing (2nd choice)          | scrypt                                 | When argon2id is unavailable. Minimum: N=2^17, r=8, p=1 (128 MiB).                                                         |
| Password hashing (3rd choice / legacy) | bcrypt                                 | Legacy systems only. Work factor >= 13 (2026 minimum). 72-byte input limit — pre-hash with HMAC-SHA384 + pepper if needed. |
| Password hashing (FIPS-140)            | PBKDF2-HMAC-SHA256                     | Only when FIPS-140 compliance is required. >= 600,000 iterations.                                                          |
| Symmetric encryption                   | AES-256-GCM, ChaCha20-Poly1305         | Always use authenticated encryption (AEAD)                                                                                 |
| Hashing (non-password)                 | SHA-256, SHA-384, SHA-512, BLAKE3      | For checksums, HMACs, content addressing                                                                                   |
| Key derivation                         | HKDF, PBKDF2 (>= 600,000 iterations)   | HKDF preferred; PBKDF2 only when HKDF is unavailable or FIPS is required                                                   |
| Asymmetric encryption                  | RSA-OAEP (>= 2048-bit), X25519/Ed25519 | Prefer Curve25519 for new projects                                                                                         |
| Digital signatures                     | Ed25519, RSA-PSS (>= 2048-bit)         | Ed25519 preferred                                                                                                          |
| HMAC                                   | HMAC-SHA256, HMAC-SHA512               | For message authentication, webhook verification                                                                           |

### Banned algorithms

These must never be used for security purposes. Their presence in a codebase is a security finding:

- **MD5** — broken collision resistance. Acceptable only for non-security checksums (e.g., cache
  busting) where collision resistance is not required.
- **SHA-1** — broken collision resistance. Do not use for signatures, certificates, or integrity
  verification.
- **DES / 3DES** — insufficient key length.
- **AES-ECB** — no diffusion; identical plaintext blocks produce identical ciphertext blocks. Always
  use a mode with an IV/nonce (GCM, CBC with HMAC, CTR).
- **RC4** — multiple known vulnerabilities.
- **Blowfish** (for encryption) — use AES-256-GCM instead. Note: bcrypt (based on Blowfish) remains
  acceptable for password hashing in legacy systems only.

### Key management

- Encryption keys are secrets and must follow all secrets management rules. Never hardcode keys.
- Encryption keys must be separate from application secrets (database passwords, API keys).
- Use a dedicated key management system (HashiCorp Vault, AWS KMS, or equivalent) in production.
- Rotate encryption keys on a defined schedule. For symmetric keys protecting data at rest, support
  key versioning so that old data can be decrypted with the old key and re-encrypted with the new
  one during rotation.
- When a key is retired, ensure all data encrypted with that key is re-encrypted before the old key
  is destroyed.
- Zeroize keys in memory after use where the language permits.

### Rules

- Always use authenticated encryption (AEAD). Encrypt-then-MAC is acceptable if AEAD is unavailable,
  but MAC-then-encrypt and encrypt-only are not.
- Never reuse a nonce/IV with the same key. For AES-256-GCM, use a 96-bit random nonce per
  encryption operation. If nonce collision risk is unacceptable (high-volume systems), use
  AES-256-GCM-SIV or XChaCha20-Poly1305 with a 192-bit nonce.
- Ciphertext must include the nonce and authentication tag. The decryption function must verify the
  tag before returning plaintext.
- Use constant-time comparison for HMAC verification and token comparison to prevent timing attacks.
  In Python: `hmac.compare_digest()`. In TypeScript: `crypto.timingSafeEqual()`.

---

## Database Security

Row Level Security (RLS) is the primary database-layer access control for all user-scoped and
tenant-scoped tables. Full details are in [`../RLS-GUIDE.md`](../RLS-GUIDE.md).

**Key rules:**

- RLS must be enabled and forced on all tables that store user-scoped or tenant-scoped data.
- The `admin_db` (BYPASSRLS) role has a strictly limited set of authorised call sites only — see
  [`AUTH-AND-AUTHZ.md`](AUTH-AND-AUTHZ.md) for the restricted usage table.
- RLS session context (`app.current_user_id`) must be set via `RLSMiddleware` for HTTP requests and
  via `set_rls_context` for Celery tasks before any query.

---

## Browser Storage Policy

Client-side storage is visible to any JavaScript running on the page, including third-party scripts
and XSS payloads. Store data in the most restrictive location appropriate.

### Authentication tokens

- **Always use `httpOnly`, `Secure`, `SameSite=Lax` (or `Strict`) cookies** for authentication
  tokens (session IDs, JWTs used for auth). These cookies are inaccessible to JavaScript, protecting
  them from XSS.
- **Never store authentication tokens in `localStorage` or `sessionStorage`.** Both are accessible
  to any JavaScript on the page.

### Other data

| Storage                   | Acceptable use                                                                   | Never store                                       |
| ------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------- |
| `httpOnly` Secure cookies | Auth tokens, session IDs, CSRF tokens                                            | -                                                 |
| `sessionStorage`          | Ephemeral UI state (form wizard progress, scroll position) that is not sensitive | Tokens, PII, secrets                              |
| `localStorage`            | Non-sensitive user preferences (theme, language, dismissed notices)              | Tokens, PII, secrets, anything that grants access |
| `IndexedDB`               | Large client-side datasets (offline-first apps, cached content)                  | Tokens, PII, secrets                              |

### Rules

- If a value grants access to anything (a token, a session, an API key), it must be in an `httpOnly`
  cookie. No exceptions.
- If a value contains PII, it must not be stored client-side at all unless the application is
  explicitly designed for offline use — and even then, it must be encrypted at rest in IndexedDB
  with a key derived from user authentication.
- `SameSite=Lax` is the minimum for all cookies. Use `SameSite=Strict` where the cookie does not
  need to be sent on cross-site navigations.
- **Cookies are host-only, and the session and CSRF cookies take `__Host-` names in every
  environment that serves TLS.** **[gate: fail]** (`csrf-cookie-httponly-absent`,
  `cookie-host-prefix-absent`, `cookie-scope-widened`) Never set `SESSION_COOKIE_DOMAIN` or
  `CSRF_COOKIE_DOMAIN`: with no `Domain` a cookie is sent only to the host that issued it, so a
  subdomain cannot _read_ it. Omitting `Domain` does not stop a subdomain _writing_ a cookie the
  apex accepts — the `__Host-` prefix does. So each TLS-serving settings module assigns
  `SESSION_COOKIE_NAME = "__Host-sessionid"` and `CSRF_COOKIE_NAME = "__Host-csrftoken"` beside
  its `SESSION_COOKIE_SECURE = True` and `CSRF_COOKIE_SECURE = True` (`staging.py:21-24`,
  `production.py:21-24`); `dev.py` keeps Django's plain names, because a `__Host-` cookie cannot
  be set over HTTP. `base.py` assigns `CSRF_COOKIE_HTTPONLY = True` once, for every environment
  (`base.py:159-164`).
  - **The prefix's three preconditions**, each checked by the browser before it stores the
    cookie: `Secure` (the bullet below); `Path=/`, Django's default, so `SESSION_COOKIE_PATH` and
    `CSRF_COOKIE_PATH` are never set to anything else; and no `Domain`. Break one and the browser
    discards the cookie silently — no error, no log, just an anonymous request.
  - **Three limits.** Protection is **per cookie name**: only the two named cookies carry it. A
    **browser without prefix support** accepts a prefixed cookie unconditionally, so the prefix is
    defence in depth over the settings, never a substitute for them. And **`CSRF_COOKIE_HTTPONLY`
    does not defend the CSRF token against XSS**: `{% csrf_token %}` renders it into the DOM and
    `hx-headers` into a `<body>` attribute, both readable by injected script. It stops a script
    reading the _cookie_, and that is all.
- Set `Secure` on all cookies. There is no valid reason for a cookie to be sent over HTTP in
  production.

### Cookie scope — what the rule rests on, and what it reaches

This section owns cookie-scope doctrine; every other guide that names a cookie setting defers here.

- **Client code takes the CSRF token from the page, never from the cookie.** With `HttpOnly` set,
  `document.cookie` cannot see it, and the cookie's name differs by environment anyway. Any
  JavaScript or HTMX request reads the token from `{% csrf_token %}` or the `hx-headers` attribute.
- **Development and the TLS environments name the cookies differently** — `sessionid` and
  `csrftoken` in dev, `__Host-sessionid` and `__Host-csrftoken` in staging and production. A
  fixture, Playwright selector, monitoring rule or edge config matching `sessionid` literally
  passes in dev and fails in production; match on `settings.SESSION_COOKIE_NAME` or
  `settings.CSRF_COOKIE_NAME` instead.
- **The edge is a precondition.** `__Host-` requires the cookie to have been set over a genuinely
  secure connection. Django emits the `Secure` attribute from the setting, so that half is this
  repository's and is gated. `SECURE_SSL_REDIRECT` is not: it trusts `request.is_secure()`, which
  `SECURE_PROXY_SSL_HEADER` (`staging.py:19`, `production.py:19`) derives from
  `X-Forwarded-Proto`. A plain-HTTP request carrying a client-supplied `X-Forwarded-Proto: https`
  skips the redirect, is served over HTTP, and the browser discards the prefixed cookie. The edge
  must strip any client-supplied value and set its own —
  `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6. No gate covers it: whether an
  edge strips a header is not a property of this tree.
- **Scope: the session and CSRF cookies only.** `django.contrib.messages` is installed, and its
  default storage falls back to a cookie that stays unprefixed and subdomain-writable, as would
  any language cookie. Neither is covered by this rule.
- **What the gate can and cannot see.** `code/src/scripts/audits/negative-space.sh` reads every
  `*.py` under `code/src/django/config/settings/`, packages and symlinks included, and evaluates
  the **code part** of each line — a trailing comment neither hides an assignment nor satisfies
  one, string contents (multi-line strings and docstrings too) are never read as code, and a
  CRLF line ending changes nothing. It recognises plain, indented, annotated (`NAME: str = …`),
  chained (`A = NAME = …`) and augmented (`NAME += …`) assignments, and **the last occurrence in
  a module wins**: a later plain name, a later `*_COOKIE_SECURE = False`, or a
  `CSRF_COOKIE_HTTPONLY` left anything but `True` in **any** module is a finding naming that
  module. Presence still needs an unconditional, column-0 compliant line; an indented one alone
  is not presence. The TLS modules it holds to the `__Host-` rule are `staging.py` and
  `production.py` (or `staging/__init__.py` and `production/__init__.py` when they are
  packages) and **any other module assigning `SECURE_SSL_REDIRECT`, `SESSION_COOKIE_SECURE` or
  `CSRF_COOKIE_SECURE = True`**. A `Domain` of `None` and a `Path` of exactly `"/"` (`'/'`,
  `r"/"`) are host-only, not findings.
  - **It fails closed.** Any other whole-token occurrence of a cookie setting name in code — after
    a semicolon, in tuple unpacking, `del`, a walrus, a parenthesised, `for` or `import … as`
    target, a subscript-first chain — is an **unrecognised occurrence**: it never counts as
    presence and always counts as an override or a widened scope. **A read is one too**:
    `X = SESSION_COOKIE_SECURE` or `if CSRF_COOKIE_HTTPONLY:` in a settings module is a finding.
    The remedy is to read `django.conf.settings` from the code that needs the value, never from
    inside a settings module, and to write each setting as one plain assignment. There is no
    suppression annotation, by design.
  - **A module it cannot read is a finding** naming that module, never a silent pass.
  - The copier migration `cookie-domain-conflict.sh` carries the same detector, byte for byte,
    names unreadable modules the same way, and the self-test proves the two report the same
    settings.

  **A green run proves that directory, not a global rule.** It is line-based, not a parser, so
  these remain invisible or misread:
  - a runtime write to `django.conf.settings` — an `AppConfig.ready()` is the canonical place;
  - an environment-driven value — `env("X")` is read as "not compliant", never as what it holds;
  - any settings module outside `code/src/django/config/settings/`, and anything reaching the
    directory through `from … import *`, `setattr`, `globals()`, `exec` or a name built at
    runtime — none of them spells the setting as a token;
  - an identifier spelt with fullwidth or other NFKC-equivalent characters, which Python folds
    to the setting's name and the scanner does not, and a name inside an f-string's braces;
  - a multi-line value, or one built by concatenation or a variable, which reads as "not
    compliant" — a false finding, never a false pass;
  - a keyword argument on its own line inside a call (`NAME=True,`), which reads as an assignment;
  - control flow: an unconditional line after an `if` block wins whether or not the block ran.

### Libraries that write to client storage by default

**The rules above are absolute, and two libraries in this stack break them silently unless
configured.** A rule nothing enforces is a false green, so each carries its enforcement point here.

**HTMX writes rendered DOM to `localStorage`.** Its history cache stores full page snapshots —
ten by default — so any page rendering personal data persists that PII to disk, in the one place
the table above says it may never go. The user takes no action and sees nothing.

- **The base template carries `<meta name="htmx-config" content='{"historyCacheSize": 0}'>`.**
  This is structural, not per-page: history navigation still works, the URL is simply re-requested
  from the server. **Enforcement: a test asserts the meta renders**, because there is one place to
  get it wrong and a grep would police a population of one.
- The per-page alternative, `hx-history="false"`, is **not** the policy. It requires every author
  to correctly classify every page as personal-data-rendering, forever, and the failure is silent
  and one-directional.

**Alpine's `$persist` defaults to `localStorage`** and carries the identical exposure, but is
opt-in per component rather than on by default.

- **`$persist` may never hold personal data**, exactly as the table states.
- **Reach for it only where client-side state genuinely beats server-side.** State the server can
  hold, the server holds. This is the technology ladder applied to storage: persistence is not a
  free choice, it is a rung you must justify climbing to.
- Where the state is non-sensitive but should not outlive the tab,
  `$persist.using(sessionStorage)` is the documented alternative. **`sessionStorage` is not a PII
  escape hatch** — it is a shorter lifetime, not a security boundary, and the table bans PII from
  it too.

**Neither storage protects against XSS.** Both are readable by any script on the page; the only
difference between them is residency.

---

## Data Classification

Every piece of data handled by the application belongs to a classification tier. The tier determines
the security controls required.

| Tier             | Examples                                                                                               | Controls                                                                                                                                                                                                            |
| ---------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Public**       | Marketing content, public API documentation, open-source code                                          | No special controls. Integrity protection (checksums, signed releases) where relevant.                                                                                                                              |
| **Internal**     | Internal documentation, non-sensitive configuration, team communications                               | Access restricted to authenticated team members. Not exposed to public endpoints.                                                                                                                                   |
| **Confidential** | User PII (names, emails, addresses), financial data, client project details, internal business metrics | Encrypted at rest and in transit. Access logged. Access restricted by role. Retention and deletion policies enforced. Subject to GDPR/data protection obligations.                                                  |
| **Restricted**   | Encryption keys, passwords, authentication tokens, payment card data, health records                   | Encrypted at rest with dedicated key management. Access restricted to the minimum necessary. Access logged and alerted. Zeroized in memory after use. Subject to regulatory requirements (PCI DSS, GDPR Article 9). |

### Rules

- Every new data field or storage location must be classified before implementation.
- Data must not be stored at a lower classification tier than it requires.
- Restricted data must never appear in logs. Confidential data may appear in logs only if masked or
  redacted (e.g., email: `s***@example.com`).
- When data is shared with third parties, verify that the third party meets the controls required for
  the data's classification tier.
- Data retention and deletion must follow the classification tier's requirements. See
  [`project-management/docs/GDPR-GUIDE.md`](../../../project-management/docs/GDPR-GUIDE.md) for
  the full GDPR compliance patterns.

_Part of the `code/docs/` documentation family. See [`../SECURITY.md`](../SECURITY.md) for the full index._
