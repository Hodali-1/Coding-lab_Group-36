#!/usr/bin/env python3
"""
Hospital Data Engine
Simulates Heart Rate, Temperature, and Water Usage data generation.
Usage: python3 hospital_system.py start | stop
"""

import os
import sys
import time
import random
import signal
import datetime

PID_FILE = "/tmp/hospital_system.pid"
LOG_DIR = "active_logs"

DEVICES = {
    "heart_rate": ["HR_MONITOR_01", "HR_MONITOR_02", "HR_MONITOR_03"],
    "temperature": ["TEMP_SENSOR_01", "TEMP_SENSOR_02", "TEMP_SENSOR_03"],
    "water_usage": ["ICU_WATER_RESERVE", "WARD_A_WATER", "WARD_B_WATER"]
}

def get_status(value, metric):
    if metric == "heart_rate":
        if value < 50 or value > 120: return "CRITICAL"
        if value < 60 or value > 100: return "WARNING"
        return "NORMAL"
    elif metric == "temperature":
        if value < 35.0 or value > 39.5: return "CRITICAL"
        if value < 36.0 or value > 38.0: return "WARNING"
        return "NORMAL"
    else:
        if value > 95: return "CRITICAL"
        if value > 80: return "WARNING"
        return "NORMAL"

def generate_data():
    os.makedirs(LOG_DIR, exist_ok=True)
    while True:
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        # Heart Rate
        with open(f"{LOG_DIR}/heart_rate.log", "a") as f:
            for device in DEVICES["heart_rate"]:
                value = random.randint(40, 140)
                status = get_status(value, "heart_rate")
                f.write(f"{timestamp},{device},{value},bpm,{status}\n")

        # Temperature
        with open(f"{LOG_DIR}/temperature.log", "a") as f:
            for device in DEVICES["temperature"]:
                value = round(random.uniform(34.0, 41.0), 1)
                status = get_status(value, "temperature")
                f.write(f"{timestamp},{device},{value},celsius,{status}\n")

        # Water Usage
        with open(f"{LOG_DIR}/water_usage.log", "a") as f:
            for device in DEVICES["water_usage"]:
                value = round(random.uniform(20.0, 100.0), 2)
                status = get_status(value, "water_usage")
                f.write(f"{timestamp},{device},{value},liters,{status}\n")

        time.sleep(5)

def start():
    if os.path.exists(PID_FILE):
        with open(PID_FILE) as f:
            pid = int(f.read())
        try:
            os.kill(pid, 0)
            print(f"Engine already running (PID {pid})")
            return
        except ProcessLookupError:
            pass

    pid = os.fork()
    if pid == 0:
        # Child process
        generate_data()
    else:
        with open(PID_FILE, "w") as f:
            f.write(str(pid))
        print(f"Hospital data engine started (PID {pid})")
        print(f"Logs writing to: {LOG_DIR}/")

def stop():
    if not os.path.exists(PID_FILE):
        print("Engine is not running.")
        return
    with open(PID_FILE) as f:
        pid = int(f.read())
    try:
        os.kill(pid, signal.SIGTERM)
        os.remove(PID_FILE)
        print(f"Hospital data engine stopped (PID {pid})")
    except ProcessLookupError:
        print("Process not found. Cleaning up PID file.")
        os.remove(PID_FILE)

if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1] not in ("start", "stop"):
        print("Usage: python3 hospital_system.py start|stop")
        sys.exit(1)
    if sys.argv[1] == "start":
        start()
    else:
        stop()
