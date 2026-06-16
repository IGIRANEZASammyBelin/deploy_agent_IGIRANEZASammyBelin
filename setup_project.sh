#!/bin/bash
cleanup() {
    if [ -n "$TARGET_DIR" ] && [ -d "$TARGET_DIR" ]; then
        echo "Stopping! Saving your progress first..."
        tar -czf "${TARGET_DIR}_archive.tar.gz" "$TARGET_DIR" 2>/dev/null
        rm -rf "$TARGET_DIR"
        echo "Saved. Cleaned up. Bye!"
    fi
    exit 1
}
trap cleanup SIGINT

echo "Enter a project name:"
read -r user_input
if [ -z "$user_input" ]; then
    echo "Error: Project name cannot be empty." >&2
    exit 1
fi

TARGET_DIR="attendance_tracker_${user_input}"
if [ -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR already exists." >&2
    exit 1
fi

if ! mkdir -p "$TARGET_DIR/Helpers" "$TARGET_DIR/reports" 2>/dev/null; then
    echo "Could not create folders, check your permissions." >&2
    exit 1
fi

cp attendance_checker.py "$TARGET_DIR/" || { echo "Error: attendance_checker.py missing." >&2; exit 1; }
cp assets.csv "$TARGET_DIR/Helpers/" || { echo "Error: assets.csv missing." >&2; exit 1; }
cp config.json "$TARGET_DIR/Helpers/" || { echo "Error: config.json missing." >&2; exit 1; }
cp reports.log "$TARGET_DIR/reports/" || { echo "Error: reports.log missing." >&2; exit 1; }
echo "All done! Your project is ready at $TARGET_DIR/"

echo "Do you want to update attendance thresholds? (yes/no):"
read -r choice
if [ -z "$choice" ]; then
    echo "Error: Please enter yes or no." >&2
    exit 1
fi

if [ "$choice" == "yes" ]; then
    echo "Enter Warning threshold (default 75):"
    read -r warning
    echo "Enter Failure threshold (default 50):"
    read -r failure

    if ! [[ "$warning" =~ ^[0-9]+$ ]] || ! [[ "$failure" =~ ^[0-9]+$ ]]; then
        echo "Error: Thresholds must be numbers. Keeping defaults." >&2
    else
        sed -i "s/\"warning\":.*/\"warning\": $warning,/g" "$TARGET_DIR/Helpers/config.json"
        sed -i "s/\"failure\":.*/\"failure\": $failure/g" "$TARGET_DIR/Helpers/config.json"
        echo "Done! Thresholds have been updated."
    fi
else
    echo "No changes made, keeping the defaults."
fi

if python3 --version >/dev/null 2>&1; then
    echo "python3 is installed, you are good to go."
else
    echo "Heads up: python3 is not installed on this machine."
fi

