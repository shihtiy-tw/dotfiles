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

# Loop through each file in the specified directory that ends with .service or .timer
for file in "$directory"/*; do
  base_name=$(basename "$file")
  extension="${base_name##*.}"

  if [[ "$extension" == "service" || "$extension" == "timer" ]]; then
    target="$HOME/.config/systemd/user/${base_name}"
    ln -sf "$(realpath "$file")" "$target"
    echo "Created soft link for $file to $target"
  fi
done
