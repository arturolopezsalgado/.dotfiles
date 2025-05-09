# macOS Setup Guide

This document provides detailed information about how the macOS configuration scripts work and what settings they customize.

## Overview

The macOS setup scripts allow you to quickly configure your macOS environment with recommended settings. The process is designed to be:

- **Safe**: Always creates a backup of your current settings
- **Modular**: Organized into logical components
- **Interactive**: Lets you choose which components to apply
- **Reversible**: Can restore your previous settings if needed

## How It Works

The macOS setup process is controlled by the `macos_setup.sh` script, which coordinates the execution of several specialized configuration scripts.

### Main Components

1. **Backup**: Before making any changes, your current settings are backed up
2. **Dock Configuration**: Appearance, position, and applications
3. **Menu Bar Configuration**: Visibility and customization
4. **Finder Preferences**: File viewing and behavior settings
5. **Control Center**: Organization and settings
6. **System Settings**: General system preferences

### Running the Setup

The setup is typically executed as part of the main installation process but can be run separately with:

```zsh
zsh ~/.dotfiles/setup/macos/macos_setup.sh
```

## Configuration Details

### Dock Configuration (`dock.sh`)

Customizes how the Dock looks and behaves:

- **Position**: Set to bottom (configurable)
- **Auto-hide**: Enabled for more screen space
- **Animation Speed**: Faster than default
- **Minimize Effect**: Scale effect
- **App Icons**: Configured with useful default applications
- **Recent Items**: Shows recently used applications

### Menu Bar Configuration (`menu_bar.sh`)

Configures the menu bar appearance and functionality:

- **Clock Format**: 24-hour time with date
- **Battery Percentage**: Displayed
- **Icon Visibility**: Controls which status icons appear
- **Spotlight**: Shortcut configured

### Finder Preferences (`finder.sh`)

Sets up Finder for efficiency:

- **Default View**: Column view for better navigation
- **Show Path Bar**: Enabled for context
- **Show Status Bar**: Enabled for file information
- **Show Hidden Files**: Configurable option
- **File Extensions**: Always shown
- **Search Scope**: Current folder by default
- **Default Location**: Home directory

### Control Center (`control_center.sh`)

Customizes the Control Center layout and items:

- **Quick Access Items**: Configure which items appear
- **Menu Bar Items**: Control which icons appear in the menu bar
- **Notification Center**: Configure how notifications appear

### System Settings (`system_settings.sh`)

Configures general system preferences:

- **Keyboard**: Key repeat rate and delay
- **Trackpad**: Tracking speed and gestures
- **Sound**: Alert volume and effects
- **Energy Saver**: Sleep settings
- **Software Update**: Automatic check preferences
- **Security**: Basic security settings

## Restoring Previous Settings

If you're not satisfied with the changes, you can restore your previous settings with:

```zsh
zsh ~/.dotfiles/setup/macos/restore_macos_settings.sh
```

This will restore the backup created before the changes were applied.

## Customization

You can customize the macOS settings by editing the individual scripts:

1. Open the relevant script (e.g., `dock.sh` for Dock settings)
2. Modify the settings as desired
3. Save the file
4. Run the setup script again

Each setting is documented with comments explaining what it does.

## Troubleshooting

Common issues and solutions:

- **Changes Not Applied**: Some settings may require logging out and back in
- **Backup Not Found**: Make sure you ran the setup script first
- **Permission Issues**: Ensure you have administrative privileges

If you encounter issues, you can:
1. Check the terminal output for error messages
2. Try running specific component scripts directly
3. Reset specific settings manually through System Preferences
