---
type: guide
agent: security
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Security

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}} **Language**:
British English (en_GB) **Timezone**: {{TIMEZONE}}
**Claude Model:** opus — OWASP controls, Django Ninja API security, IDOR prevention, incident response

Security documentation for the {{PROJECT_NAME}} stack. Covers authentication, authorisation,
cryptography, data classification, input validation, Django Ninja API security, supply chain,
monitoring, and incident response.

## Sub-documents

| Document                                                                     | Covers                                                                                       |
| ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| [`security/AUTH-AND-AUTHZ.md`](security/AUTH-AND-AUTHZ.md)                   | Authentication, authorisation, anti-enumeration rules, `admin_db` restriction                |
| [`security/INPUT-AND-API.md`](security/INPUT-AND-API.md)                     | Input validation, Django Ninja API security, throttling, file upload security                |
| [`security/CRYPTO-AND-DATA.md`](security/CRYPTO-AND-DATA.md)                 | Approved algorithms, banned algorithms, key management, browser storage, data classification |
| [`security/SECRETS-AND-TRANSPORT.md`](security/SECRETS-AND-TRANSPORT.md)     | Secrets management, TLS, container security                                                  |
| [`security/SUPPLY-CHAIN.md`](security/SUPPLY-CHAIN.md)                       | Dependency security, lock file integrity, CI/CD pipeline security, package provenance        |
| [`security/MONITORING-AND-INCIDENT.md`](security/MONITORING-AND-INCIDENT.md) | Security logging, alerting, and incident response procedure                                  |
| [`security/OWASP-AND-CHECKLIST.md`](security/OWASP-AND-CHECKLIST.md)         | OWASP Top 10 2025 mitigations, stack-specific rules (Django, HTMX), pre-deploy checklist     |

_Edge-enforced controls — security headers, TLS, request body-size, CF/CF-Tunnel — are
catalogued as the deploy contract in
[`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`](../../how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md);
this doc keeps owning the "why", SERVER-ARCHITECTURE owns "what the server provides"._

_Part of the `code/docs/` documentation family._
