#!/bin/bash
# Ubuntu EOL Upgrade Fixer
# ⚠️ USE AT YOUR OWN PERIL ⚠️
# This script modifies apt sources and runs do-release-upgrade.
# Backups are created automatically. Logs are written to /var/log/fix-eol-upgrade.log.

set -euo pipefail

LOGFILE="/var/log/fix-eol-upgrade.log"
BACKUP_DIR="/etc/apt/backup-eolfix"
STAMP=$(date +%F-%H%M)
CODENAME=$(lsb_release -sc)
RELEASE=$(lsb_release -sr)

log() { echo "$(date +%F-%T) :: $1" | sudo tee -a "$LOGFILE"; }

log "=== Starting fix-eol-upgrade for Ubuntu $RELEASE ($CODENAME) ==="

echo "⚠️ WARNING: This script modifies apt sources and runs do-release-upgrade."
echo "⚠️ USE AT YOUR OWN PERIL. Backups will be created, but you are responsible for restoring them if needed."
echo

read -p "Do you accept full responsibility? (y/n): " RESPONSIBILITY
log "User responsibility response: $RESPONSIBILITY"
[[ "$RESPONSIBILITY" == "y" ]] || { echo "❌ Responsibility not accepted. Exiting."; log "Execution aborted."; exit 1; }

read -p "Shall we proceed with the upgrade? (y/n): " PROCEED
log "User proceed response: $PROCEED"
[[ "$PROCEED" == "y" ]] || { echo "❌ Upgrade cancelled."; log "Execution aborted."; exit 1; }

sudo mkdir -p "$BACKUP_DIR"
log "Backup directory ensured at $BACKUP_DIR"

[ -f /etc/apt/sources.list ] && sudo cp /etc/apt/sources.list "$BACKUP_DIR/sources.list.$STAMP" && log "Backed up sources.list"
[ -f /etc/apt/sources.list.d/ubuntu.sources ] && sudo cp /etc/apt/sources.list.d/ubuntu.sources "$BACKUP_DIR/ubuntu.sources.$STAMP" && log "Backed up ubuntu.sources"

cat <<EOF | sudo tee /etc/apt/sources.list > /dev/null
deb http://old-releases.ubuntu.com/ubuntu/ $CODENAME main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ ${CODENAME}-updates main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ ${CODENAME}-backports main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ ${CODENAME}-security main restricted universe multiverse
EOF
log "Rewrote sources.list"

cat <<EOF | sudo tee /etc/apt/sources.list.d/ubuntu.sources > /dev/null
Types: deb
URIs: http://old-releases.ubuntu.com/ubuntu/
Suites: $CODENAME ${CODENAME}-updates ${CODENAME}-backports
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://old-releases.ubuntu.com/ubuntu/
Suites: ${CODENAME}-security
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF
log "Rewrote ubuntu.sources"

log "Running apt update..."
sudo apt update | sudo tee -a "$LOGFILE"

log "Running apt full-upgrade..."
sudo apt -y full-upgrade | sudo tee -a "$LOGFILE"

log "Running do-release-upgrade..."
sudo do-release-upgrade -f DistUpgradeViewNonInteractive | sudo tee -a "$LOGFILE"

log "=== Completed fix-eol-upgrade ==="
