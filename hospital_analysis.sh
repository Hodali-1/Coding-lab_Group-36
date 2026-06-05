#!/bin/bash
# hospital_analysis.sh
# Author: Grace

process_vitals() {
    echo "=========================================="
    echo "  Processing Critical Vitals..."
    echo "=========================================="

    if [ ! -d "active_logs" ] || [ ! -d "reports" ]; then
        echo "ERROR: Required directories missing. Run hospital_admin.sh first."
        exit 1
    fi

    > reports/critical_alerts.txt
    echo "Timestamp,Device_ID,Value" >> reports/critical_alerts.txt

    for logfile in active_logs/heart_rate.log active_logs/temperature.log; do
        if [ -f "$logfile" ]; then
            echo "  Scanning $logfile for CRITICAL entries..."
            grep "CRITICAL" "$logfile" \
                | awk -F',' '{print $1 "," $2 "," $3}' \
                >> reports/critical_alerts.txt
        else
            echo "  No file found: $logfile (skipping)"
        fi
    done

    CRITICAL_COUNT=$(grep -c "CRITICAL" reports/critical_alerts.txt 2>/dev/null || echo 0)
    echo "  Done. $CRITICAL_COUNT critical alert(s) saved."
}

water_audit() {
    echo "=========================================="
    echo "  ICU Water Usage Audit"
    echo "=========================================="

    WATER_LOG="active_logs/water_usage.log"

    if [ ! -f "$WATER_LOG" ]; then
        echo "ERROR: $WATER_LOG not found."
        exit 1
    fi

    AVG=$(awk -F',' '/ICU_WATER_RESERVE/ {sum += $3; count++} END {
        if (count > 0) printf "%.2f", sum/count
        else print "0.00"
    }' "$WATER_LOG")

    TOTAL_READINGS=$(grep -c "ICU_WATER_RESERVE" "$WATER_LOG" 2>/dev/null || echo 0)

    printf "  %-35s %s\n" "Device:" "ICU_WATER_RESERVE"
    printf "  %-35s %s\n" "Total Readings:" "$TOTAL_READINGS"
    printf "  %-35s %s\n" "Average Water Usage:" "${AVG} liters"
    echo "=========================================="
}

process_vitals
water_audit