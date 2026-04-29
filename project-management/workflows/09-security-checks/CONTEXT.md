# Workflow: Security Checks

> **Agent hints — Model:** Opus · **MCP:** `mcp-mermaid` (threat model diagrams)

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
- STRIDE (Spoofing, Tampering, Repudiation, Information Disclosure, DoS, Elevation) is the threat model framework
- Findings are documented in `project-management/src/09-SECURITY/`
- Any blocking findings must be resolved before proceeding to sprint planning

## Cross-references

- `project-management/src/09-SECURITY/` — security audit output
- `project-management/src/04-USER-FLOW/` — user journeys under review
- `project-management/src/07-WIREFRAMES/` — wireframes under review
- `project-management/docs/GIT-GUIDE.md` — commit and PR conventions
