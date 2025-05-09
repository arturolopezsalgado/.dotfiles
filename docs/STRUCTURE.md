# Repository Structure

This document explains how the dotfiles repository is organized and the purpose of each file and directory.

## Directory Structure

```
.dotfiles/
├── docs/                  # Documentation
│   ├── INSTALLATION.md    # Installation instructions
│   ├── PERSONALIZATION.md # Personalization system guide
│   └── STRUCTURE.md       # This file
├── home/                  # Files that will be symlinked to home directory
│   ├── .config/           # XDG config directory
│   │   ├── ghostty/       # Ghostty terminal configuration
│   │   ├── git/           # Git configuration files
│   │   │   ├── .gitignore_global     # Global gitignore patterns
│   │   │   ├── config-personal       # Personal git identity (generated)
│   │   │   ├── config-personal.template # Template for personal identity
│   │   │   ├── config-work          # Work git identity (generated)
│   │   │   └── config-work.template # Template for work identity
│   │   ├── homebrew/      # Homebrew bundle file (packages)
│   │   │   └── Brewfile   # List of packages to install
│   │   ├── iterm2/        # iTerm2 configuration
│   │   │   ├── Profiles.json   # Terminal profiles
│   │   │   └── themes/         # Color schemes
│   │   ├── raycast/       # Raycast launcher configuration
│   │   ├── starship/      # Starship prompt configuration
│   │   │   └── starship.toml  # Prompt settings
│   │   ├── yazi/          # Yazi file manager configuration
│   │   └── zsh/           # Modular Zsh configuration
│   │       ├── aliases.zsh    # Command aliases
│   │       ├── completions.zsh # Tab completion settings
│   │       ├── env/            # Environment variables (loaded by .zshenv)
│   │       │   ├── editor.zsh  # Editor preferences
│   │       │   ├── locale.zsh  # Locale settings
│   │       │   ├── path.zsh    # Path declarations
│   │       │   └── xdg.zsh     # XDG Base Directory settings
│   │       ├── functions.zsh   # Shell utility functions
│   │       ├── history.zsh     # History configuration
│   │       ├── plugins.zsh     # Plugin management
│   │       └── profile/        # Profile-specific settings
│   │           ├── macos.zsh   # macOS-specific settings
│   │           ├── path.zsh    # Path configuration
│   │           └── system.zsh  # System-specific settings
│   ├── .gitconfig         # Git configuration (context-aware)
│   ├── .gitconfig.template # Template for the gitconfig file
│   ├── .zlogin            # Zsh login configuration
│   ├── .zprofile          # Zsh profile configuration
│   ├── .zshenv            # Zsh environment variables (all shells)
│   └── .zshrc             # Zsh configuration (interactive shells)
├── deprecated/            # Deprecated files and configurations
├── setup/                 # Setup and installation scripts
│   ├── install.sh         # Main installation script
│   ├── macos/             # macOS-specific customization scripts
│   │   ├── ai_prompt_requirement.md   # Requirements for AI prompts
│   │   ├── backup_macos_settings.sh   # Creates backups of settings
│   │   ├── control_center.sh          # Control Center settings
│   │   ├── dock.sh                    # Dock configuration
│   │   ├── finder.sh                  # Finder preferences
│   │   ├── macos_setup.md             # Documentation for macOS setup
│   │   ├── macos_setup.sh             # Main macOS setup script
│   │   ├── menu_bar.sh                # Menu bar configuration
│   │   ├── restore_macos_settings.sh  # Restores settings from backup
│   │   └── system_settings.sh         # System preferences
│   ├── scripts/           # Helper scripts for installation
│   │   ├── personalize.sh  # Personalization script
│   │   └── prerequisites.sh # Installs prerequisites
│   └── utils/             # Utility functions
│       ├── colors.sh      # Color output functions
│       └── steps.sh       # Installation step functions
├── claude_recommendations.md # Recommendations from Claude for improvements
└── README.md              # Main documentation file
```

## Key Components

### Configuration Files

The `home/` directory contains all files that will be symlinked to your home directory. It follows the exact structure of where files will be placed:

- **Shell Configuration**: `.zshenv`, `.zshrc`, and `.config/zsh/`
- **Git Configuration**: `.gitconfig` and `.config/git/`
- **Terminal Configuration**: `.config/ghostty/` and `.config/iterm2/`
- **Package Lists**: `.config/homebrew/Brewfile`

### Installation System

The `setup/` directory contains scripts for installing and configuring your environment:

- **install.sh**: The main entry point for installation
- **personalize.sh**: Creates personalized configuration files
- **macos/**: Scripts for configuring macOS settings
- **utils/**: Helper functions for installation

### Documentation

The `docs/` directory contains detailed documentation:

- **INSTALLATION.md**: Step-by-step installation guide
- **PERSONALIZATION.md**: Information about the personalization system
- **STRUCTURE.md**: This file explaining the repository structure

## Modularity

The dotfiles are organized in a modular fashion:

- **Zsh Configuration**: Split into logical modules like `aliases.zsh`, `completions.zsh`, etc.
- **Environment Variables**: Modular environment setup in `.config/zsh/env/`
- **macOS Settings**: Separate scripts for different aspects of macOS

This modularity makes it easy to:
- Understand what each component does
- Make targeted changes to specific parts
- Share only certain parts with others

## Extension Points

The dotfiles system includes several extension points for machine-specific customization:

- **Local Files**: `.zshrc.local`, `.zshenv.local`, and `.gitconfig.local`
- **Templates**: Files with the `.template` extension for personalization
- **Brewfile**: Easily editable package list for customizing software installation
