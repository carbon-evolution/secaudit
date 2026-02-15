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
