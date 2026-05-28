#!/bin/bash

# ==============================================================================
# Script Name:  analyse.logs.sh
# Description:  Automated Log Parser & Host-Based Intrusion Detection Alerting
# ==============================================================================
LOG_FILE="/var/log/auth.log"
REPORT_FILE="/home/homelab/homelab-log-analyser/ssh_failed_report.txt"

# Create a temporary file to process data safely
TEMP_RAW="/tmp/raw_failed.txt"

if [ ! -r "$LOG_FILE" ]; then
  echo "ERROR: Cannot read $LOG_FILE. Ensure you are running this script with sudo." >&2
  exit 1
fi

# Extract malicious SSH attempts
grep -E "sshd.*Invalid user" "$LOG_FILE" | awk '{print $10}' | sort | uniq -c | sort -nr >"$TEMP_RAW"

# Check if we found any hackers
if [ ! -s "$TEMP_RAW" ]; then
  echo -e "SYSTEM STATUS: SECURE\nNo unauthorized access attempts detected during this window." >"$REPORT_FILE"
else
  # Build a beautiful, human-readable dashboard inside the text file
  echo -e "SYSTEM STATUS: WARNING - UNAUTHORIZED ATTEMPTS DETECTED\n" >"$REPORT_FILE"
  echo -e "ATTEMPTS    TARGET USERNAME" >>"$REPORT_FILE"
  echo -e "----------  ----------------" >>"$REPORT_FILE"

  # Format the raw data lines cleanly
  while read -r count username; do
    printf "%-10s  %-16s\n" "$count" "$username" >>"$REPORT_FILE"
  done <"$TEMP_RAW"
fi

# Clean up temp files and lock down permissions
rm -f "$TEMP_RAW"
chmod 600 "$REPORT_FILE"
chown homelab:homelab "$REPORT_FILE"
