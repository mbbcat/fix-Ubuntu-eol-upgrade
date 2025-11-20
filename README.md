# fix-eol-upgrade

Scripts to fix Ubuntu **end‑of‑life (EOL) upgrade traps** by redirecting apt sources to `old-releases.ubuntu.com` and running `do-release-upgrade`.

## Overview
When an interim Ubuntu release goes EOL, the official mirrors are shut down. This breaks `apt update` and blocks `do-release-upgrade`. These scripts automate:

- Detecting your current Ubuntu codename
- Redirecting apt sources to the old-releases archive
- Backing up original sources files
- Logging all actions
- Running `do-release-upgrade`

## Usage

### General Ubuntu
```bash
chmod +x fix-eol-upgrade.sh
./fix-eol-upgrade.sh
## ⚠️ Disclaimer

This project is provided **“as‑is”** with **no warranty of any kind**.  
Running `fix-eol-upgrade.sh` or `wsl-eol-fix.sh` will make changes to your system’s package sources and attempt a distribution upgrade.

- Use at your **own risk**.  
- The authors and contributors are **not responsible** for any data loss, broken installs, or other damage that may occur.  
- Always **backup your system** before running upgrade scripts.  
- This tool is intended for **experienced users** who understand the risks of modifying apt sources and performing distribution upgrades.  
- If you are unsure, the safest path is to perform a **fresh install** of a supported Ubuntu release instead of using this script.  

By using this software, you acknowledge that you are solely responsible for the outcome.

---

## 📑 Sample Log Output

A typical run will generate a log at `/var/log/fix-eol-upgrade.log`.  
Here’s an excerpt from `sample-log.txt` included in this repo:

```text
2025-11-20T16:00:12 :: === Starting fix-eol-upgrade for Ubuntu 22.10 (kinetic) ===
2025-11-20T16:00:12 :: User responsibility response: y
2025-11-20T16:00:15 :: User proceed response: y
2025-11-20T16:00:15 :: Backup directory ensured at /etc/apt/backup-eolfix
2025-11-20T16:00:15 :: Backed up /etc/apt/sources.list -> /etc/apt/backup-eolfix/sources.list.2025-11-20-1600
2025-11-20T16:00:16 :: Rewrote /etc/apt/sources.list to point at old-releases
2025-11-20T16:00:17 :: Running apt update...
Hit:1 http://old-releases.ubuntu.com/ubuntu kinetic InRelease
Fetched 12.3 MB in 2s (6,200 kB/s)
2025-11-20T16:00:22 :: Running do-release-upgrade...
Upgrades to Ubuntu 23.04 available
2025-11-20T16:00:30 :: === Completed fix-eol-upgrade ===
