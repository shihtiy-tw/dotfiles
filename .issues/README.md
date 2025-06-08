# Git Issues

This is a distributed issue tracking repository based on Git.

## Overview

Git Issues allows you to manage project issues directly within your Git repository, without requiring an external issue tracking system. Issues are stored as files within the repository, making them fully versioned and accessible offline.

## Usage

### Basic Commands

```bash
# Create a new issue
git issue create

# List all issues
git issue list

# Show details of a specific issue
git issue show <issue-id>

# Assign an issue to someone
git issue assign <issue-id> <assignee>

# Close an issue
git issue close <issue-id>

# Comment on an issue
git issue comment <issue-id>
```

### Advanced Features

- Tagging and categorizing issues
- Searching and filtering issues
- Importing/exporting issues from/to other systems
- Customizable issue templates

## Benefits

- No external dependencies or services required
- Issues travel with your repository
- Full offline access
- Complete issue history preserved
- Familiar Git workflow

## Resources

Visit [git-issue](https://github.com/dspinellis/git-issue) for more information and documentation.
