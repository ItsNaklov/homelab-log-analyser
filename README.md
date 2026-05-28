# Homelab SSH Log Analyzer

A simple automated script that scans Linux security logs (`auth.log`) for failed SSH login attempts, filters out false alarms, and displays a clean status dashboard whenever you log into your server.

## How It Works

1. **`analyse.logs.sh`**: A Bash script that grabs failed SSH attempts, counts them by username, and saves a secure report.
2. **Systemd Timer**: Runs the script automatically in the background every night at midnight.
3. **`.bashrc` Hook**: Displays the final report on your screen the moment you open a terminal.

## Repository Files

- `analyse.logs.sh` - The log parsing script.
- `log-analyser.service` - Systemd service definition.
- `log-analyser.timer` - Systemd daily automation scheduler.
- `.gitignore` - Prevents raw security logs from being uploaded to GitHub.

## Quick Setup

### Script Activation

```bash
chmod +x ~/homelab-log-analyser/analyse.logs.sh
```
