#!/bin/bash
# ============================================================
# hospital_archive.sh
# Author: Hodali
# Purpose: Rotate logs from active_logs to archived_logs
# ============================================================

# --- Member 4 (Hodali - The Archivist) ---

TIMESTAMP=$(date +%Y%m%d_%H%M)

echo "=========================================="
echo "  Hospital Log Archiver"
echo "  Timestamp: $TIMESTAMP"
echo "=========================================="

# Check required directories exist
for dir in active_logs archived_logs; do
    if [ ! -d "$dir" ]; then
        echo "ERROR: $dir not found. Run hospital_admin.sh first."
        exit 1
    fi
done

# Move each log file to archived_logs with timestamp in name
for logfile in heart_rate temperature water_usage; do
    src="active_logs/${logfile}.log"
    dest="archived_logs/${logfile}_${TIMESTAMP}.log"

    if [ -f "$src" ]; then
        mv "$src" "$dest"
        echo "  ✔ Archived: $src → $dest"
    else
        echo "  ℹ No file found: $src (skipping)"
    fi

    # Recreate empty log file so the Python engine can keep writing
    touch "$src"
    echo "  ✔ Recreated empty: $src"
done

echo ""
echo "  Log rotation complete. System continues recording."
echo "=========================================="
