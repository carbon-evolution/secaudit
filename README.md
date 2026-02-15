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
```

### Make the script executable
```bash
chmod +x secaudit.sh
```

### Run the audit
```bash
./secaudit.sh
```

---

## 🛠️ Usage

SecAudit is designed to be simple. For a full audit including OpenSCAP (if available), run with `sudo`:

```bash
sudo ./secaudit.sh
```

If run as a standard user, some system-level checks (like certain firewall rules or restricted log access) might be skipped, but the tool will still provide as much information as possible.

### What it checks:
1.  **Firewall:** Detects `ufw` or `firewalld` status.
2.  **Fail2Ban:** Validates if the service is active and lists enabled jails.
3.  **Network:** Identifies listening ports.
4.  **Updates:** Checks for pending security updates (Distro-specific).
5.  **Compliance:** Executes OpenSCAP scans against standard profiles.

---

## 📊 Reporting

Reports are automatically generated and saved in:
`$HOME/security-audit-reports/`

Each run generates:
- `security_audit_YYYY-MM-DD_HH-MM-SS.txt`: A summary of the CLI output.
- `oscap-results-YYYY-MM-DD_HH-MM-SS.xml`: Raw OpenSCAP results.
- `oscap-report-YYYY-MM-DD_HH-MM-SS.html`: A human-readable HTML compliance report.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.
