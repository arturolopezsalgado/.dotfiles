
# Personalize macOS Setup Guide

This guide will walk you through the process of personalizing your macOS environment using a set of modular scripts. The goal is to automate macOS setup and system optimizations while ensuring that key steps are manually handled by the user for full control and reliability.

---

## 🚀 Overview

This project includes a series of scripts designed to personalize the **appearance and functionality** of your macOS setup. By running these scripts, you will:

* Configure the **Dock** to be more minimal and efficient.
* Declutter and organize the **Menu Bar**.
* Tweak essential **Finder** settings.
* Optimize **System Settings** for a streamlined experience.
* Ensure macOS is **ready for development** with customized defaults.

---

## 🧑‍💻 Script Breakdown

The following scripts are part of this setup:

### 0. **`backup_macos_settings.sh` (Optional)**

**Purpose**: Backup your current macOS settings before applying any changes.

**Key Changes**:

* Creates a backup of your current macOS preferences (Dock, Finder, Menu Bar, etc.)
* Saves the backup in a timestamped `.plist` file in your `macos_backups` directory.

**Manual Steps**: Run this script before starting any personalization process. It’s recommended to back up your settings, especially if you’re unsure or if the machine is mission-critical.

**How to Use**:

```zsh
zsh scripts/backup_macos_settings.sh
```

### 1. **`dock.sh`**

**Purpose**: Customize the **Dock**'s behavior, size, appearance, and applications.

**Key Changes**:

* Remove default apps
* Set Dock position and behavior
* Add preferred apps to Dock
* Reduce size and disable magnification

**Manual Steps**: None — Fully automated!

---

### 2. **`menu_bar.sh`**

**Purpose**: Customize the **Menu Bar** by hiding/unhiding icons, adjusting clock settings, and simplifying Control Center.

**Key Changes**:

* Hide Wi-Fi, Bluetooth, and unnecessary icons
* Show battery percentage
* Configure 24-hour time and day of the week display

**Manual Steps**:

* System Settings → Control Center: Adjust visibility for items like Airdrop, Stage Manager, and Screen Mirroring.
* System Settings → Clock Options: Enable date to show "When space allows".

---

### 3. **`finder.sh`**

**Purpose**: Configure **Finder** settings for efficiency and a tidy workspace.

**Key Changes**:

* Set view as list
* Show path and status bars
* Adjust default folder settings
* Remove unnecessary tags from Finder

**Manual Steps**:

* Finder → Preferences → Sidebar: Uncheck Recents, Movies, Music, Pictures, Shared.
* Finder → Toolbar: Remove "Tags", add "Path".

---

### 4. **`control_center.sh`**

**Purpose**: Tidy up the **Control Center** by hiding unnecessary icons and configuring visibility for active modules.

**Key Changes**:

* Hide Wi-Fi, Bluetooth, and Stage Manager from menu bar
* Show modules like Sound, Now Playing, Screen Mirroring when active

**Manual Steps**:

* System Settings → Control Center: Ensure modules are only visible when active (Airdrop, Stage Manager, etc.).

---

### 5. **`system_settings.sh`**

**Purpose**: Apply key system-level settings for **Mission Control**, **Notifications**, **Energy Saver**, and **Trackpad/Mouse** configuration.

**Key Changes**:

* Configure Mission Control behavior (Spaces, window grouping)
* Set energy saver preferences (disksleep, displaysleep)
* Trackpad and Mouse settings for optimal performance

**Manual Steps**:

* System Settings → Notifications: Set "Show Previews" to "When Unlocked".
* System Settings → Trackpad & Mouse: Enable all scroll/zoom/gesture options manually.

---

### 2. **Restore Script** (`restore_macos_settings.sh`)

This script will allow you to restore the settings from the backup. It can be run manually if anything goes wrong during the personalization process.

This script:

* Asks the user to provide the path to a previous backup file.
* Restores the settings from that backup.

---

## ⚙️ How to Use the Scripts

### Step 1: Clone or Download the Repository

Clone the repository to your machine using:

```bash
git clone https://github.com/your-repo/personalize-macos.git
```

Alternatively, you can download the scripts as `.zip` and extract them to your desired directory.

### Step 1: Backup Your Settings (Optional, but recommended)

Before you proceed with personalizing macOS, run the **backup script** to save your current settings. This ensures you can restore your system to its original state if needed.

1. Open your **Terminal**.
2. Navigate to the directory where the scripts are located.
3. Run the **backup** script:

```bash
bash scripts/backup_macos_settings.sh
```


### Step 2: Run the Scripts

The main installation script (`install.sh`) will guide you through the entire process. This script will call the `macos_setup.sh` script, which in turn will execute each modular script. Follow the steps below:

1. Open your **Terminal**.
2. Navigate to the directory where the scripts are located.
3. Execute the main installation script:

```zsh
zsh setup/install.sh
```

### Step 3: Follow Manual Prompts

During the execution, you will be prompted to **complete manual tasks** between each personalization script. Once the tasks are completed, **press any key** to continue to the next script.

---

## 📝 Important Notes

* **Restoring Settings**: If anything goes wrong, you can restore your previous settings by running the `restore_macos_settings.sh` script with the backup file path.
* **macOS Version**: These scripts are designed for **macOS Ventura+**. If you're using an older version, some features might not work as expected.
* **Admin Access**: Some commands may require **administrator privileges** (for example, changing energy saver settings). Ensure you have **sudo** access.
* **Revert Changes**: To revert any specific setting, you can manually edit `defaults` or use the System Settings app to adjust preferences.

---

## **Restore Your macOS Settings**

If you need to revert your macOS settings to their previous state, you can run the **restore script**:

```zsh
zsh setup/macos/restore_macos_settings.sh
```

You will be prompted to enter the path to the backup file that you created earlier. The script will then restore your macOS preferences from the backup.

## 🔧 Troubleshooting

* **Missing Settings or Features**: If you notice that some settings aren't applied or appear different, they might require a **macOS restart** to take full effect.
* **Permission Issues**: If a script fails to execute due to permissions, try running the script with elevated privileges:

  ```zsh
  sudo zsh setup/install.sh
  ```

---

## 🚀 Final Thoughts

By running these scripts, you'll have a fully personalized macOS environment tailored for development and a cleaner, more efficient workspace.

---

## 📚 Additional Resources

* [Apple Documentation on `defaults`](https://developer.apple.com/library/archive/technotes/tn2083/_index.html)
* [macOS System Preferences](https://support.apple.com/guide/mac-help/change-system-preferences-on-mac-mchlp2591/mac)

---

### That's it! You're all set to personalize your macOS setup for a smoother and more productive experience.

---

Let me know if you'd like further updates or additions!
