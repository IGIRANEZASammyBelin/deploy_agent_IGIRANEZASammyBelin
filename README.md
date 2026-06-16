Attendance Tracker Deployment Agent
A Bash shell script that handles environment validation, workspace setup, config editing, and signal trapping.
Features
Validation: Checks user input, verifies file dependencies, and stops you from overwriting existing directories.
Configuration: Asks for custom attendance thresholds and updates config.json using sed.
Signal Handling: Uses a POSIX trap on SIGINT (Ctrl+C) to archive any active runtime progress into a .tar.gz file and clean up the workspace.
Health Check: Checks that core dependencies like python3 are available before running.
Project Architecture
textattendance_tracker_<project_name>/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
    └── reports.log
