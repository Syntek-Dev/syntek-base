# Required Sections — Core Security Policies

Required section lists for the four core security policies. Every document also carries
the standard header, version history, ISO alignment note, and disclaimer defined in
[STANDARDS.md](STANDARDS.md). Cross-check against `code/docs/SECURITY.md` and
`project-management/docs/SECURITY-GUIDE.md`.

---

## Information Security Policy

1. Document header (version, owner, status, review date)
2. Version history
3. Purpose and Scope
4. Policy Statement
5. Information Security Objectives
6. Roles and Responsibilities (CISO/owner, management, all staff)
7. Information Classification
8. Asset Management
9. Access Control
10. Cryptography
11. Physical and Environmental Security
12. Operational Security
13. Communications Security
14. Supplier Relationships
15. Incident Management (reference to Incident Response Plan)
16. Business Continuity
17. Compliance (legal, regulatory, contractual obligations)
18. Policy Review and Update Process
19. Related Documents
20. Approval and Sign-Off

---

## Password & Authentication Policy

1. Document header
2. Version history
3. Purpose and Scope
4. Policy Statement
5. Password Requirements
   - Minimum length (≥ 14 characters for privileged accounts, ≥ 12 for standard)
   - Complexity rules
   - Prohibited password patterns (dictionary words, usernames, sequential strings)
   - Password expiry policy (note NCSC guidance against routine expiry)
6. Multi-Factor Authentication (MFA) Requirements
   - Which systems require MFA
   - Acceptable MFA methods (TOTP, hardware key, push notification)
   - Prohibited MFA methods (SMS OTP — note as weak)
7. Password Manager Policy
8. Shared and Service Account Passwords
9. Password Reset and Recovery Procedures
10. Privileged Account Management
11. Monitoring and Auditing
12. Enforcement and Non-Compliance
13. Related Documents
14. Approval and Sign-Off

> The MFA section **must** call out the SMS OTP weakness explicitly — this is a
> quality-checklist item.

---

## Network Security Policy

1. Document header (version, owner, status, review date)
2. Version history
3. Purpose and Scope
4. Policy Statement
5. Network Architecture Overview (text-based topology description with segment definitions)
6. Network Access Control
   - Firewall policy and rules management
   - Network segmentation and VLANs
   - Network Access Control (NAC) — where applicable
   - Zero trust principles — where applicable
7. Encryption Standards
   - Data in transit: TLS 1.2+ minimum (TLS 1.3 preferred)
   - Wireless encryption: WPA3 minimum for new deployments; WPA2-Enterprise for existing
   - VPN: approved protocols and cipher suites
8. Wireless Network Security
   - Corporate vs. guest network separation (separate SSIDs, separate VLANs)
   - Rogue access point detection
   - SSID and BSSID management
9. Remote Access Requirements
   - VPN standards and MFA requirements
   - Approved remote access methods
   - Split tunnelling policy
10. Network Monitoring and Logging
    - Mandatory log sources (firewall, DNS, DHCP, authentication events)
    - Minimum log retention periods
    - Intrusion Detection / Prevention (IDS/IPS) — where applicable
    - Security Information and Event Management (SIEM) — where applicable
11. DDoS Mitigation Measures
12. Network Change Management
    - Change request and approval process
    - Testing requirements before production deployment
    - Rollback procedures
    - Emergency change procedure
13. Third-Party and Supplier Network Access
14. Incident Response for Network Compromises (reference to Incident Response Plan)
15. Related Documents
16. Approval and Sign-Off

---

## Data Classification Policy

1. Document header (version, owner, status, review date)
2. Version history
3. Purpose and Scope
4. Policy Statement
5. Classification Framework Overview
6. Classification Levels (3–4 levels with criteria and examples)
   - **Public** — information approved for public release; no harm if disclosed
   - **Internal** — general business information not for public release but not sensitive
   - **Confidential** — sensitive business or personal information; restricted access
   - **Restricted** — highest sensitivity; regulatory, legal, or reputational impact if disclosed
7. Classification Criteria and Decision Tree (text-based flowchart guiding employees to correct level)
8. Common Data Type Examples

   | Data Type | Classification Level | Rationale |
   | --------- | -------------------- | --------- |

9. Handling Requirements by Classification Level

   | Classification | Storage | Transmission | Encryption | Access Control | Printing / Physical |
   | -------------- | ------- | ------------ | ---------- | -------------- | ------------------- |

10. Data Owner Responsibilities
11. Retention and Destruction Requirements by Classification Level
12. Breach Notification Procedures by Classification Level
13. Employee Responsibilities and Training
14. Compliance and Audit
15. Related Documents
16. Approval and Sign-Off
