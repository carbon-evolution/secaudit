# 🔐 SecAudit — Cross-Distro Linux Security Audit Tool

**SecAudit** is a cross-distribution, CLI-based Linux security auditing tool designed to provide **human-readable, risk-scored system assessments** with optional **OpenSCAP compliance and CVE analysis**.

It is built for:
- Security engineers
- Blue teams / SOC analysts
- Linux power users
- Students building real security portfolios

SecAudit runs safely on **Ubuntu, Debian, Fedora, RHEL-based, and Arch Linux** systems with automatic environment detection.

---

## ✨ Features

- ✅ Cross-distro support (Ubuntu, Debian, Fedora, RHEL, Arch)
- ✅ No hardcoded OS assumptions
- ✅ Human-readable CLI output
- ✅ Automatic report archival
- ✅ Risk scoring (LOW / MEDIUM / HIGH)
- ✅ Firewall detection (UFW / firewalld)
- ✅ Fail2Ban validation
- ✅ Open ports visibility
- ✅ CVE & security update awareness
- ✅ Optional **OpenSCAP compliance scanning**
- ✅ Automatic parsing of **HIGH / CRITICAL OpenSCAP findings**
- ✅ Safe to run as non-root (with graceful degradation)

---

## 🖥️ Supported Operating Systems

| Distribution | Supported |
|-------------|-----------|
| Ubuntu | ✅ |
| Debian | ✅ |
| Fedora | ✅ |
| RHEL / Rocky / Alma | ✅ |
| Arch Linux | ✅ (limited CVE metadata) |

---

## 📦 Requirements

### Mandatory
- `bash`
- `coreutils`
- `iproute2` (`ss`) or `net-tools`

### Optional (Auto-Detected)
- `fail2ban`
- `ufw` or `firewalld`
- `openscap-scanner`
- `scap-security-guide`
- `libxml2` (`xmllint`)

SecAudit will **not fail** if optional tools are missing.

---

## 🚀 Quick Start

### Clone the repository
```bash
git clone https://github.com/<your-username>/secaudit.git
cd secaudit



Make the script executable
chmod +x secaudit.sh

Run the audit
./secaudit.sh


🔎 You do not need root, but running with sudo enables deeper checks.

📂 Output & Reports

All reports are automatically saved to:

~/security-audit-reports/


Example:

security-audit-reports/
├── security_audit_2026-02-15_23-18-54.txt
├── oscap-report-2026-02-15_23-18-54.html
└── oscap-results-2026-02-15_23-18-54.xml


CLI output and report files are identical

OpenSCAP HTML reports are browser-ready

📊 Risk Scoring Model

SecAudit assigns weighted risk based on findings:

Finding	Risk Weight
Firewall inactive	+30
Fail2Ban missing	+20
Fail2Ban no active jails	+15
Security updates pending	+30
OpenSCAP HIGH finding	+5 each
OpenSCAP CRITICAL finding	+10 each
Risk Levels

0–20 → LOW

21–50 → MEDIUM

51+ → HIGH

🛡️ OpenSCAP Integration (Optional)

If OpenSCAP is installed, SecAudit will:

Run a compliance scan using SSG profiles

Generate XML + HTML reports

Automatically extract HIGH / CRITICAL failures

Adjust risk score based on severity

Supported OpenSCAP profiles are auto-selected per OS.

📈 Example Output
FAIL2BAN CHECK
[PASS] Fail2Ban running
[WARN] No active jails

OPENSCAP HIGH / CRITICAL FINDINGS
[FAIL] High severity issues detected
Ensure SSH root login is disabled
Ensure password reuse is limited

RISK SUMMARY
Score: 45 / 100
Risk Level: MEDIUM

