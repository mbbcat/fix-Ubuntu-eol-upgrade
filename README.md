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
