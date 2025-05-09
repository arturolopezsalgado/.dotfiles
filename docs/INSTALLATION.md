# Installation Guide

This document explains how to install and set up the dotfiles on a new machine.

## Prerequisites

- macOS (tested on Catalina and newer)
- Administrator access on your machine
- Internet connection (for downloading packages)
- Command Line Tools for Xcode (will be installed automatically if needed)

## Quick Start

### 1. Clone the Repository

```zsh
git clone https://github.com/yourusername/.dotfiles.git ~/.dotfiles
```

### 2. Run the Installation Script

The installation script handles the complete setup process:

```zsh
zsh ~/.dotfiles/setup/install.sh
```

This will guide you through the full setup process:
- Install prerequisites (Xcode Command Line Tools, Homebrew)
- Personalize configuration files with your information
- Create symbolic links to your home directory
- Install packages via Homebrew
- Configure macOS preferences

## Installation Steps Explained

### Prerequisites Installation

The script first ensures all prerequisites are installed:

1. **Detect Mac Architecture**: Determines if you're using an Intel or Apple Silicon Mac
2. **Install Xcode Command Line Tools**: Required for Git, Homebrew, and other development tools
3. **Install Homebrew**: Package manager for installing software packages

These steps are handled by the `prerequisites.sh` script, which is called from the main installation script.

### Personalization

The personalization script (`personalize.sh`) will prompt you for:

1. **Git Identities**:
   - Your name, email, and GitHub username for personal projects
   - Your name, email, and GitHub username for work projects

2. **Project Directories**:
   - Whether you want to create a dedicated 'dev' directory or use another directory (like Documents)
   - Names for your personal and work project subdirectories

These details are used to:
- Create context-specific Git configurations
- Set up your preferred project directory structure
- Generate a personalized `.gitconfig` file

The script will also create the necessary directory structure if it doesn't already exist.

### Dotfiles Symlinking

The installation creates symbolic links from your home directory to the configuration files in the repository using GNU Stow. This allows you to:
- Edit the files in the repository
- Track changes with Git
- Easily update all machines when you make changes

The script will:
1. Install GNU Stow if not already installed
2. Remove any existing symlinks
3. Create new symlinks to all files in the `home/` directory

### Package Installation

The script installs software packages defined in `~/.config/homebrew/Brewfile` including:
- Command-line tools (git, zsh, etc.)
- GUI applications (browsers, editors, utilities)
- Programming languages and tools
- macOS-specific applications and utilities

You can customize the `Brewfile` before installation to add or remove packages.

### macOS Configuration

The final step configures various macOS settings through several specialized scripts:

- **Dock**: Appearance, position, and applications
- **Finder**: Default behavior and preferences
- **Menu Bar**: Visibility and appearance
- **Control Center**: Organization and options
- **System Settings**: Various system-wide preferences

Before applying these settings, the script creates a backup of your current macOS settings, allowing you to restore them if needed.

## Customizing the Installation

### Changing Default Packages

Edit `~/.config/homebrew/Brewfile` to add or remove packages before running the installation.

### Skipping Steps

The installation script will prompt you before each major step, allowing you to skip any part of the process.

## Updating an Existing Installation

To update your dotfiles on an existing machine:

```zsh
cd ~/.dotfiles
git pull
zsh setup/install.sh
```

The script is designed to safely update existing configurations without overwriting your personalized settings.

## Troubleshooting

### Common Issues

**Homebrew Installation Fails**
- Run `xcode-select --install` manually
- Try running Homebrew installation separately: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

**Symlink Creation Fails**
- Check if the destination files already exist
- Use `--overwrite` flag if you want to replace existing files

**macOS Settings Not Applied**
- Some settings may require logging out and back in
- Check System Settings manually for any settings that didn't apply

### Getting Help

If you encounter issues that aren't covered here, please:
1. Check the logs in the terminal output
2. Create an issue on the GitHub repository
