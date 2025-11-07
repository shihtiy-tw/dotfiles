# AWS Configuration

Configuration files for the AWS Command Line Interface (CLI).

## Structure

- `config` - AWS CLI configuration file (symlinked to `~/.aws/config`)

## Features

- Region settings
- Output format configuration
- Named profiles for different AWS accounts
- SSO configuration
- CLI customization

## Installation

The main dotfiles `make init` command will set up the AWS configuration automatically.

For manual installation:
```bash
# Create necessary directories
mkdir -p ~/.aws

# Create symlink
ln -sf ~/dotfiles/aws/config ~/.aws/config
```

## Usage

After installation, you can use the AWS CLI with the configured settings:

```bash
# Use default profile
aws s3 ls

# Use a specific profile
aws --profile profile-name ec2 describe-instances
```

## Security Note

The AWS configuration in this repository should NOT include:
- Access keys
- Secret keys
- Session tokens

These sensitive credentials should be stored securely outside of version control.

## Recommended Practices

- Use AWS SSO for authentication when possible
- Rotate credentials regularly
- Use the least privilege principle for IAM roles and users
- Enable MFA for all users

## Resources

- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
- [AWS CLI Configuration Variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-variables)
