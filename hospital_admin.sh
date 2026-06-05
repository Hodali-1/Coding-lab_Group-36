#!/bin/bash
# ============================================================
# hospital_admin.sh
# Author: Hodali
# Purpose: Initialize and secure the hospital system environment
# ============================================================

# --- Member 1 (Hodali - The Architect) ---
# initialize_system: Creates required directories if they don't exist

initialize_system() {
    echo "=========================================="
    echo "  Initializing Hospital System..."
    echo "=========================================="

    for dir in active_logs archived_logs reports; do
        if [ ! -d "$dir" ]; then
            echo "Creating $dir directory..."
            mkdir -p "$dir"
            echo "  ✔ $dir created successfully."
        else
            echo "  ✔ $dir already exists. Skipping."
        fi
    done

    echo ""
    echo "Directory initialization complete."
    echo ""
}

# --- Member 2 (Hodali - The Security Lead) ---
# secure_data: Restricts active_logs so only the owner can read/write

secure_data() {
    echo "=========================================="
    echo "  Securing active_logs directory..."
    echo "=========================================="

    if [ ! -d "active_logs" ]; then
        echo "ERROR: active_logs directory not found. Run initialize_system first."
        exit 1
    fi

    chmod 600 active_logs
    echo "  ✔ Permissions set: owner read/write only (600)"
    echo ""
    echo "  Current permissions:"
    ls -ld active_logs
    echo ""
}

# --- Member 3 (Hodali - The Orchestrator) ---
# Execution logic: calls functions in order and prints confirmation

initialize_system
secure_data

echo "=========================================="
echo "  System Environment Secured"
echo "  Date: $(date)"
echo "=========================================="
