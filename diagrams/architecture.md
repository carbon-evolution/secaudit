# SecAudit – Architecture & Workflow Diagrams

This document describes how **SecAudit** works internally and how data flows
from system checks to the final risk score.

---

## 🧱 High-Level Architecture

```mermaid
flowchart TD
    A[User runs secaudit.sh] --> B[Pre-flight Checks]
    B --> C[OS Detection]
    C --> D[Firewall Check]
    C --> E[Fail2Ban Check]
    C --> F[Open Ports Scan]
    C --> G[CVE / Security Updates Check]
    C --> H[OpenSCAP Scan (Optional)]

    D --> I[Risk Engine]
    E --> I
    F --> I
    G --> I
    H --> I

    I --> J[Risk Score Calculation]
    J --> K[Human-readable Report]
    K --> L[Saved to ~/security-audit-reports]

sequenceDiagram
    participant User
    participant SecAudit
    participant OS
    participant OpenSCAP

    User->>SecAudit: Run secaudit.sh
    SecAudit->>OS: Detect distro & package manager
    SecAudit->>OS: Check firewall status
    SecAudit->>OS: Check Fail2Ban status
    SecAudit->>OS: Enumerate listening ports
    SecAudit->>OS: Check security updates
    SecAudit->>OpenSCAP: Run compliance scan (if available)
    OpenSCAP-->>SecAudit: XML + HTML results
    SecAudit->>SecAudit: Parse HIGH / CRITICAL findings
    SecAudit->>User: Display report + risk score


flowchart LR
    A[Finding Detected] --> B{Severity}
    B -->|Low| C[+0–5]
    B -->|Medium| D[+10–20]
    B -->|High| E[+5 per finding]
    B -->|Critical| F[+10 per finding]

    C --> G[Risk Score]
    D --> G
    E --> G
    F --> G

    G --> H{Final Level}
    H -->|0–20| I[LOW]
    H -->|21–50| J[MEDIUM]
    H -->|51+| K[HIGH]
