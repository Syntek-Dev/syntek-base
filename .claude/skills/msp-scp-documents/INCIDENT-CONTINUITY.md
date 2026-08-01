# Required Sections — Incident Response & Business Continuity

Required section lists for the incident response plan and business continuity plan.
Every document also carries the standard header, version history, ISO alignment note,
and disclaimer defined in [STANDARDS.md](STANDARDS.md).

---

## Incident Response Plan

1. Document header
2. Version history
3. Purpose and Scope
4. Incident Response Objectives
5. Definitions (what constitutes an incident, severity levels)
6. Incident Severity Classification table (P1 Critical, P2 High, P3 Medium, P4 Low with response times)
7. Roles and Responsibilities (Incident Response Team, on-call contacts)
8. Incident Response Phases
   - Phase 1: Identification and Triage
   - Phase 2: Containment (short-term and long-term)
   - Phase 3: Eradication
   - Phase 4: Recovery
   - Phase 5: Post-Incident Review (lessons learnt, report)
9. Communication Plan (internal escalation, external notification — ICO within 72 hours for personal data breaches under UK GDPR)
10. Evidence Preservation
11. Contact Directory (internal team, external — NCSC, legal, PR, cyber insurer)
12. Incident Log Template
13. Post-Incident Report Template
14. Testing and Exercises (tabletop, simulation schedule)
15. Related Documents
16. Approval and Sign-Off

> Two quality-checklist items apply here: the **P1–P4 severity classification table**
> must be present, and the **ICO 72-hour notification** requirement must appear in the
> communication plan for personal-data breaches. Cross-check
> `project-management/docs/GDPR-GUIDE.md`.

---

## Business Continuity Plan

1. Document header (version, owner, status, review date)
2. Version history
3. Purpose and Scope
4. Business Continuity Objectives
5. Critical Business Process Inventory

   | Process | Owner | Priority | RTO | RPO |
   | ------- | ----- | -------- | --- | --- |

6. Recovery Time Objective (RTO) and Recovery Point Objective (RPO) Definitions and Targets
7. Business Impact Analysis Summary (impact of loss of each critical process)
8. Recovery Strategies (overview)
9. IT Disaster Recovery Procedures
   - Backup and restore procedures
   - Failover procedures
   - Cloud and off-site recovery procedures
10. Recovery Runbooks (per critical system — numbered step-by-step procedures)
11. Vendor and Service Provider Dependencies (and their continuity implications)
12. Communication Plan
    - Internal escalation chain
    - External stakeholder notification (customers, regulators, insurers)
13. Alternate Working Arrangements
14. Testing and Maintenance Schedule
15. Training and Awareness
16. Related Documents
17. Approval and Sign-Off
