# code/docs/security

Sub-documents for security practices. Covers authentication, authorisation, cryptography, data classification, input validation, Django Ninja API security, monitoring, incident response, OWASP guidance, and supply chain security.

## Directory Tree

```text
code/docs/security/
├── CLAUDE.md                  ← operating rules
├── CONTEXT.md                 ← this file
├── AUDIT-TRAIL.md             ← The audit record: schema, write path, contents, PII, retention, tamper-resistance (OWASP A09)
├── AUTH-AND-AUTHZ.md          ← Authentication and authorisation patterns
├── CRYPTO-AND-DATA.md         ← Cryptography, data classification, and browser storage
├── INPUT-AND-API.md           ← Input validation, Django Ninja API security, throttling, file uploads
├── MONITORING-AND-INCIDENT.md ← Logging, monitoring, and incident response
├── OWASP-AND-CHECKLIST.md     ← OWASP Top 10, stack-specific security, and checklist
├── SECRETS-AND-TRANSPORT.md   ← Secrets management, transport security, and container security
└── SUPPLY-CHAIN.md            ← Dependency security and supply chain best practices
```

## Cross-references

- `code/docs/SECURITY.md` — the index these sub-documents belong to
