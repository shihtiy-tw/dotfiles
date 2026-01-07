#!/bin/bash

# Define the directory containing the service and timer files
directory="$1"

# Check if a directory is provided
if [ "$directory" = "" ]; then
  echo "Please provide a directory path."
  exit 1
fi

# Create ~/.config/systemd/user directory if it doesn't exist
mkdir -p ~/.config/systemd/user

# Arrays to hold units
timers_to_start=()

# Loop through each file in the specified directory
for file in "$directory"/*; do
  base_name=$(basename "$file")
  extension="${base_name##*.}"

  # Check for .service or .timer extensions
  if [[ "$extension" == "service" || "$extension" == "timer" ]]; then
    target="$HOME/.config/systemd/user/${base_name}"

    # Create the symbolic link
    ln -sf "$(realpath "$file")" "$target"
    echo "🔗 Created soft link for $file"

    # If it is a timer, add it to the start list
    if [[ "$extension" == "timer" ]]; then
      timers_to_start+=("$base_name")
    fi
  fi
done

# 1. Reload systemd so it sees the new links
echo "🔄 Reloading systemd daemon..."
systemctl --user daemon-reload

# 2. Enable and Start ONLY the timers
for timer in "${timers_to_start[@]}"; do
  echo "🚀 Enabling and starting timer: $timer..."
  systemctl enable --now --user "$timer"
done

# 3. Show status of timers
echo "---------------------------------------------------"
echo "⏰ Current User Timers:"
systemctl list-timers --user
