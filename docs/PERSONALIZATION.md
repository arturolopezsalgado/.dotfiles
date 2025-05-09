# Personalization System

This document explains how the personalization system works and how to manage sensitive information in your dotfiles.

## How Personalization Works

The dotfiles repository uses a templating system to avoid storing sensitive personal information in Git:

1. **Template Files**: Configuration files with placeholders (e.g., `config-personal.template`)
2. **Personalization Script**: Collects user information and creates actual config files
3. **Gitignore Rules**: Prevents committing personalized files to the repository

## Template Files

Template files use a naming convention with the `.template` extension and contain placeholders for sensitive information. For example:

```ini
# ~/.dotfiles/home/.config/git/config-personal.template
[user]
  name = __PERSONAL_NAME__
  email = __PERSONAL_EMAIL__

[credential]
  username = "__PERSONAL_GITHUB__"
```

## Available Placeholders

Current placeholders used in templates:

| Placeholder | Description |
|-------------|-------------|
| `__PERSONAL_NAME__` | Your name for personal projects |
| `__PERSONAL_EMAIL__` | Your personal email address |
| `__PERSONAL_GITHUB__` | Your personal GitHub username |
| `__WORK_NAME__` | Your name for work projects |
| `__WORK_EMAIL__` | Your work email address |
| `__WORK_GITHUB__` | Your work GitHub username |
| `__PERSONAL_PROJECTS_PATH__` | Path to your personal projects directory |
| `__WORK_PROJECTS_PATH__` | Path to your work projects directory |

These placeholders are automatically replaced with your personal information during the installation process.

## Project Directory Structure

During personalization, the script will help you set up your project directory structure:

1. Choose between a dedicated `dev` directory or another directory (like `Documents`)
   ```
   Do you want to create a dedicated 'dev' directory in your home folder? (Recommended) [y/n]
   ```

2. If you choose not to use the `dev` directory, you'll be prompted to specify an alternative:
   ```
   Common alternatives are 'Documents', 'Projects', or 'code'
   Enter the name of the directory to use in your home folder (default: Documents):
   ```

3. Customize the names of your personal and work project subdirectories:
   ```
   Enter name for your personal projects subfolder (default: Personal):
   Enter name for your work projects subfolder (default: Work):
   ```

4. The script will automatically create any directories that don't already exist.

This setup ensures a clean separation between personal and work projects, and the paths are used to configure Git to automatically use the correct identity based on the project location.

## Context-Aware Configurations

The repository uses Git's `includeIf` directive to automatically apply the correct profile based on the repository location. This is fully templated and customized based on your chosen directory structure:

```ini
# ~/.dotfiles/home/.gitconfig.template
[includeIf "gitdir:__PERSONAL_PROJECTS_PATH__/"]
  path = ~/.config/git/config-personal

[includeIf "gitdir:__WORK_PROJECTS_PATH__/"]
  path = ~/.config/git/config-work
```

During installation, the placeholders are replaced with your actual project paths. For example, if you choose to use `~/dev/Personal` for personal projects and `~/dev/Work` for work projects, the resulting `.gitconfig` will contain:

```ini
[includeIf "gitdir:~/dev/Personal/"]
  path = ~/.config/git/config-personal

[includeIf "gitdir:~/dev/Work/"]
  path = ~/.config/git/config-work
```

This ensures your personal email is used for personal projects and your work email for work projects, regardless of what directory structure you've chosen.

## How Personalization Works in the Installation Process

The personalization system is integrated into the installation process as follows:

1. **Running the Personalization Script**: When you run `install.sh`, it calls the `personalize.sh` script early in the process.

2. **Checking Existing Files**: The script checks if personalized files already exist and asks if you want to overwrite them.

3. **Collecting User Information**: You're prompted to enter your personal and work information.

4. **Setting Up Directories**: The script helps you set up your preferred project directory structure.

5. **Creating Configuration Files**: The script generates personalized configuration files from templates.

6. **Symlinking**: After personalization, the installation creates symlinks to your home directory.

## Adding New Personalizable Files

To add a new file that requires personalization:

1. Create the file with the `.template` extension
2. Use placeholders in the format `__PLACEHOLDER_NAME__`
3. Update the `.gitignore` file to exclude the generated file
4. Update the personalization script if needed

## Security Considerations

- Never commit personalized files to the repository
- The `.gitignore` file excludes personalized files
- Review `git diff` before committing to ensure no sensitive data is included
- Use `git filter-branch` if you accidentally commit sensitive information

## Machine-Specific Customization

For machine-specific settings that shouldn't be shared across all computers:

- `.zshrc.local`: Local shell settings
- `.zshenv.local`: Local environment variables
- `.gitconfig.local`: Local Git configuration

These files are loaded automatically if they exist but are not tracked in the repository.
