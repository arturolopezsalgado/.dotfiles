# Dotfiles

A modern, modular dotfiles system for macOS development environments.

## Overview

This repository contains a comprehensive set of configuration files and scripts that automate the setup and customization of a macOS development environment. It's designed to be:

- **Secure**: Sensitive information is never stored in the repository
- **Modular**: Components are organized logically for easy maintenance
- **Customizable**: Easy to adapt to your specific needs and preferences
- **Documented**: Clear explanations of how everything works

## Features

- **Modular Zsh Configuration**: Organized by function for better maintainability
- **Context-Aware Git Config**: Automatically use different settings for personal and work projects
- **Customizable Project Structure**: Personalize your development directories during setup
- **macOS Customization**: Scripts for configuring various aspects of macOS
- **Package Management**: Homebrew automation for software installation
- **Terminal Setup**: Configuration for modern terminals (Ghostty, iTerm2)
- **Personalization System**: Securely handle sensitive information

## Quick Start

```zsh
# Clone the repository
git clone https://github.com/yourusername/.dotfiles.git ~/.dotfiles

# Run the installation script
zsh ~/.dotfiles/setup/install.sh
```

The installation script will:
1. Prompt for your personal information
2. Help you configure your preferred project directory structure
3. Create symlinks to your home directory
4. Install packages via Homebrew
5. Configure macOS settings

## Documentation

Detailed documentation is available in the `/docs` directory:

- [Installation Guide](docs/INSTALLATION.md): Step-by-step installation instructions
- [Personalization System](docs/PERSONALIZATION.md): How sensitive information is handled
- [Repository Structure](docs/STRUCTURE.md): Organization of the repository

## Directory Structure

```
.dotfiles/
├── docs/                  # Detailed documentation
├── home/                  # Files symlinked to home directory
│   ├── .config/           # XDG config directory
│   │   ├── git/           # Git configuration
│   │   ├── zsh/           # Modular Zsh configuration
│   │   └── ...            # Other app configs
│   ├── .gitconfig         # Git configuration
│   ├── .zshenv            # Zsh environment variables
│   └── .zshrc             # Zsh configuration
├── setup/                 # Setup and installation scripts
│   ├── install.sh         # Main installation script
│   ├── macos/             # macOS customization scripts
│   ├── scripts/           # Helper scripts
│   └── utils/             # Utility functions
└── README.md              # This file
```

## Key Components

### Shell Configuration

The Zsh configuration is organized into logical modules:

- **Core Settings**: `.zshrc` and `.zshenv`
- **Environment Variables**: `.config/zsh/env/`
- **Aliases**: `.config/zsh/aliases.zsh`
- **Functions**: `.config/zsh/functions.zsh`
- **Completions**: `.config/zsh/completions.zsh`
- **History**: `.config/zsh/history.zsh`
- **Plugins**: `.config/zsh/plugins.zsh`

### Git Configuration

Git is set up with context-aware configurations:

- **Main Config**: `.gitconfig` with conditional includes
- **Personal Profile**: `.config/git/config-personal`
- **Work Profile**: `.config/git/config-work`

### macOS Customization

The `setup/macos/` directory contains scripts for customizing macOS:

- **Dock**: Appearance, position, and applications
- **Finder**: Default behavior and preferences
- **Menu Bar**: Visibility and appearance
- **System Settings**: Various system preferences

### Package Management

Software installation is managed through Homebrew, with packages defined in `.config/homebrew/Brewfile`.

## Customization

### Machine-Specific Configuration

For settings specific to a single machine:

- `.zshrc.local`: Local shell settings
- `.zshenv.local`: Local environment variables
- `.gitconfig.local`: Local Git configuration

These files are automatically loaded if they exist but are not tracked in the repository.

### Adding New Configuration

To add configuration for a new tool:

1. Add the configuration to the appropriate directory in `home/`
2. If it contains sensitive information, create a template
3. Update the `.gitignore` file if needed

## License

MIT
