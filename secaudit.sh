#!/usr/bin/env bash
set -euo pipefail

# ==============================
# GLOBAL CONFIG
# ==============================
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_DIR="$HOME/security-audit-reports"
REPORT="$REPORT_DIR/security_audit_$DATE.txt"
OSCAP_RESULTS_XML="$REPORT_DIR/oscap-results-$DATE.xml"
OSCAP_REPORT_HTML="$REPORT_DIR/oscap-report-$DATE.html"

RISK_SCORE=0
MAX_SCORE=100

mkdir -p "$REPORT_DIR"

exec > >(tee "$REPORT") 2>&1

# ==============================
# BASIC SAFETY CHECKS
# ==============================
if [[ $EUID -ne 0 ]]; then
  echo "[INFO] Script not running as root. Some checks may be skipped."
fi

if ! command -v bash &>/dev/null; then
  echo "[FAIL] Bash not found"
  exit 1
fi

# ==============================
# OS DETECTION
# ==============================
OS=""
PKG_MGR=""
OSCAP_DS=""

if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  OS=$ID
fi

case "$OS" in
  ubuntu|debian)
    PKG_MGR="apt"
    OSCAP_DS="/usr/share/xml/scap/ssg/content/ssg-ubuntu-ds.xml"
    ;;
  fedora)
    PKG_MGR="dnf"
    OSCAP_DS="/usr/share/xml/scap/ssg/content/ssg-fedora-ds.xml"
    ;;
  rhel|rocky|almalinux)
    PKG_MGR="dnf"
    OSCAP_DS="/usr/share/xml/scap/ssg/content/ssg-rhel-ds.xml"
    ;;
  arch)
    PKG_MGR="pacman"
    OSCAP_DS=""
    ;;
  *)
    echo "[WARN] Unsupported or unknown OS: $OS"
    ;;
esac

# ==============================
# HEADER
# ==============================
echo "========================================"
echo "        SYSTEM SECURITY AUDIT"
echo "        Host: $(hostname)"
echo "        OS: ${PRETTY_NAME:-Unknown}"
echo "        Date: $(date)"
echo "========================================"
echo ""

# ==============================
# FIREWALL CHECK
# ==============================
echo "=== FIREWALL CHECK ==="
if command -v firewall-cmd &>/dev/null && systemctl is-active --quiet firewalld; then
  echo "[PASS] Firewalld is active"
elif command -v ufw &>/dev/null && ufw status | grep -q active; then
  echo "[PASS] UFW is active"
else
  echo "[WARN] Firewall not detected or inactive"
  ((RISK_SCORE+=30))
fi
echo ""

# ==============================
# FAIL2BAN CHECK
# ==============================
echo "=== FAIL2BAN CHECK ==="
if command -v fail2ban-client &>/dev/null; then
  if systemctl is-active --quiet fail2ban; then
    echo "[PASS] Fail2Ban running"
    JAILS=$(fail2ban-client status 2>/dev/null | grep "Jail list" | cut -d: -f2 | xargs)
    if [[ -z "$JAILS" ]]; then
      echo "[WARN] No active jails"
      ((RISK_SCORE+=15))
    else
      echo "[INFO] Active jails: $JAILS"
    fi
  else
    echo "[WARN] Fail2Ban installed but not running"
    ((RISK_SCORE+=20))
  fi
else
  echo "[INFO] Fail2Ban not installed"
fi
echo ""

# ==============================
# OPEN PORTS
# ==============================
echo "=== OPEN PORTS ==="
if command -v ss &>/dev/null; then
  ss -tuln | grep LISTEN || true
else
  netstat -tuln || true
fi
echo ""

# ==============================
# CVE / SECURITY UPDATES
# ==============================
echo "=== SECURITY UPDATE CHECK ==="
case "$PKG_MGR" in
  apt)
    apt list --upgradable 2>/dev/null | grep -i security || echo "[PASS] No security updates detected"
    ;;
  dnf)
    dnf updateinfo list security 2>/dev/null || echo "[PASS] No security advisories"
    ;;
  pacman)
    echo "[INFO] Arch Linux does not provide CVE metadata by default"
    ;;
esac
echo ""

# ==============================
# OPENSCAP SCAN (OPTIONAL)
# ==============================
echo "=== OPENSCAP SCAN ==="
if command -v oscap &>/dev/null && [[ -f "$OSCAP_DS" ]]; then
  sudo oscap xccdf eval \
    --profile xccdf_org.ssgproject.content_profile_standard \
    --results "$OSCAP_RESULTS_XML" \
    --report "$OSCAP_REPORT_HTML" \
    "$OSCAP_DS" &>/dev/null || true

  if [[ -f "$OSCAP_RESULTS_XML" ]]; then
    echo "[PASS] OpenSCAP scan completed"
    echo "[INFO] HTML report: $OSCAP_REPORT_HTML"

    HIGH=$(xmllint --xpath "count(//*[local-name()='rule-result'][@severity='high' and @result='fail'])" "$OSCAP_RESULTS_XML" 2>/dev/null || echo 0)
    CRIT=$(xmllint --xpath "count(//*[local-name()='rule-result'][@severity='critical' and @result='fail'])" "$OSCAP_RESULTS_XML" 2>/dev/null || echo 0)

    ((RISK_SCORE+=HIGH*5))
    ((RISK_SCORE+=CRIT*10))
  fi
else
  echo "[INFO] OpenSCAP not available for this OS"
fi
echo ""

# ==============================
# RISK SUMMARY
# ==============================
echo "========================================"
echo "RISK SUMMARY"
echo "========================================"
echo "Score: $RISK_SCORE / $MAX_SCORE"

if (( RISK_SCORE <= 20 )); then
  echo "Risk Level: LOW"
elif (( RISK_SCORE <= 50 )); then
  echo "Risk Level: MEDIUM"
else
  echo "Risk Level: HIGH"
fi

echo ""
echo "Audit complete."
echo "Reports saved in: $REPORT_DIR"
echo "========================================"
