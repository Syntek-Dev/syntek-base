---
type: guide
agent: security
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Security — Cryptography, Data Classification, and Browser Storage

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}} **Language**:
British English (en_GB) **Timezone**: {{TIMEZONE}}
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
- Set an explicit `Path` and `Domain` on cookies to prevent them being sent more broadly than
  intended.
- Set `Secure` on all cookies. There is no valid reason for a cookie to be sent over HTTP in
  production.

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
  [`../../project-management/docs/GDPR-GUIDE.md`](../../project-management/docs/GDPR-GUIDE.md) for
  the full GDPR compliance patterns.

_Part of the `code/docs/` documentation family. See [`../SECURITY.md`](../SECURITY.md) for the full index._
