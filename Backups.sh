### Backups
### Before making changes, the scripts back up:
### /etc/apt/sources.list
### /etc/apt/sources.list.d/ubuntu.sources
### Backups are stored in /etc/apt/backup-eolfix/ with timestamps. Restore manually if needed:


sudo cp /etc/apt/backup-eolfix/sources.list.YYYY-MM-DD-HHMM /etc/apt/sources.list
sudo cp /etc/apt/backup-eolfix/ubuntu.sources.YYYY-MM-DD-HHMM /etc/apt/sources.list.d/ubuntu.sources
