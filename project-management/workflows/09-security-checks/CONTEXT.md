# Workflow: Security Checks

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/09-security-checks/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow after wireframes and before sprint planning to:

- Threat-model the planned features based on user flows and wireframes
- Identify security requirements and constraints for the development phase
- Confirm authentication, authorisation, and data protection requirements are designed correctly

## Prerequisites

- [ ] User flows completed in `project-management/src/04-USER-FLOW/`
- [ ] Wireframes signed off in `project-management/src/07-WIREFRAMES/`
- [ ] GDPR compliance review complete (`workflows/08-gdpr-compliance`)

## Key concepts

- Security is reviewed at design stage — before a line of code is written
- Three complementary frameworks are applied:
  - **STRIDE** — threat modelling per user flow and wireframe (Spoofing, Tampering, Repudiation, Information Disclosure, DoS, Elevation of Privilege)
  - **OWASP Top 10** — web application vulnerability categories (A01–A10) mapped to each finding
  - **NIST CSF 2.0** — risk management function mapped to each finding (Govern, Identify, Protect, Detect, Respond, Recover)
- Findings are documented in `project-management/src/09-SECURITY/`
- Any blocking findings must be resolved before proceeding to sprint planning

## Cross-references

### Hard gates — read before executing Step 1

- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP Top 10, and NIST CSF 2.0 frameworks; required before threat-modelling begins

### Soft references — consult during execution

- `project-management/src/09-SECURITY/` — security audit output
- `project-management/src/04-USER-FLOW/` — user journeys under review
- `project-management/src/07-WIREFRAMES/` — wireframes under review
- `project-management/src/08-GDPR/` — GDPR review findings inform the threat model
- `project-management/docs/GIT-GUIDE.md` — commit and PR conventions
- `code/workflows/08-security-hardening/` — **the code-layer counterpart**: this workflow
  threat-models the design and produces findings; that one audits and hardens the built code
  against OWASP A01–A10 and NIST SP 800-63B. Design-stage findings recorded here are what it
  verifies; it is entered from `17-api-code/` (after mutating endpoints exist) or as a
  release/incident pass, never directly from this workflow.
- `code/docs/SECURITY.md` — technical security requirements developers must implement from findings
- `code/docs/ENCRYPTION-GUIDE.md` — encryption requirements identified during threat modelling
- `code/docs/RLS-GUIDE.md` — row-level security patterns for multi-tenant data access findings
- `project-management/workflows/10-qa-checks/` — next step after security sign-off
