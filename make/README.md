# Make Scripts

This directory contains scripts and configuration files used by the Makefile in the root of the dotfiles repository.

## Structure

- `envfile` - Environment variables used by the Makefile
- `init.sh` - Main initialization script for setting up dotfiles
- `install-init.sh` - Script for installing dependencies
- `color-theme.sh` - Script for switching between light and dark themes
- `envtest.sh` - Script for testing environment variables
- `mac/` - macOS-specific scripts
- `systemd/` - Systemd service files

## Key Scripts

### init.sh

This script:
- Creates necessary directories
- Backs up existing configuration files
- Creates symlinks from the dotfiles repository to the appropriate locations

### install-init.sh

This script installs dependencies required by the dotfiles, such as:
- Terminal emulators
- Shell utilities
- Text editors
- Version control tools

### color-theme.sh

This script switches between light and dark themes for:
- Terminal emulators
- Text editors
- Shell prompts
- Other applications that support theming

## Usage

These scripts are primarily used by the Makefile in the root directory and should not be executed directly unless you know what you're doing.

To use the functionality provided by these scripts, use the corresponding Makefile targets:

```bash
# Initialize dotfiles
make init

# Install dependencies
make install

# Switch to dark theme
make dark

# Switch to light theme
make light
```

## Customization

If you need to customize the behavior of these scripts:

1. Edit the `envfile` to change environment variables
2. Modify the individual scripts to change their behavior
3. Update the Makefile to add new targets or modify existing ones
