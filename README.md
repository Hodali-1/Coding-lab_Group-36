# Coding-lab_GroupXX — Hospital Data Management System

## Group Members
| Member | Role | Responsibilities |
|--------|------|-----------------|
| Hodali | The Architect / Security Lead / Archivist | `hospital_admin.sh`, `hospital_archive.sh` |
| Grace  | Clinical Analyst / Facility Auditor | `hospital_analysis.sh` |

---

## Project Overview
This project simulates a hospital data management system that:
- Generates live patient vitals data (Heart Rate, Temperature, Water Usage)
- Secures the system environment with correct directory permissions
- Analyzes critical alerts and resource usage
- Archives logs with timestamps for record-keeping

---

## Repository Structure
```
Coding-lab_GroupXX/
├── hospital_system.py     # Data engine — generates live logs
├── hospital_admin.sh      # Setup & security (Hodali)
├── hospital_archive.sh    # Log archiving (Hodali)
├── hospital_analysis.sh   # Data analysis (Grace)
├── .gitignore             # Excludes logs and reports
└── README.md              # This file
```

---

## How to Run

### Step 1 — Set up the environment
```bash
bash hospital_admin.sh
```

### Step 2 — Start the data engine
```bash
python3 hospital_system.py start
```

### Step 3 — Analyze live data
```bash
bash hospital_analysis.sh
```

### Step 4 — Archive the logs
```bash
bash hospital_archive.sh
```

### Stop the engine
```bash
python3 hospital_system.py stop
```

---

## Git Workflow

Each member works on their own branch:
```bash
# Hodali
git checkout -b setup-and-archiving

# Grace
git checkout -b analysis-scripts
```

Commit at least 3 times per person, then merge into `main`:
```bash
git add .
git commit -m "Your descriptive message"
git push origin your-branch-name
# Then open a Pull Request on GitHub to merge into main
```

---

## Important — Data Privacy
Active logs, archived logs, and reports are excluded from GitHub via `.gitignore`.  
**Do NOT commit the `active_logs/`, `archived_logs/`, or `reports/` folders.**
