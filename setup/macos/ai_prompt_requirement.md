I am creating a full automated MacOS setup, the installation script calls other shell scripts to perform actions like installing Xcode, Homebrew, installing applications via brew, etc.

I want a new script called by the main installation script to personalize the macOS appearance.

The script basically should configure: the dock, the menu bar, the Finder settings

I am wondering what the best way to do it is, either a script, an application like dockutil (can be added to the brew installations), another programmatic app, or maybe you are able to create one or split scripts that can achieve the following tasks. Maybe not all configurations can be done programmatically, so let me know if a configuration must be done manually.

<ProgrammaticTasks>
# Configuring macOS

The script programmatically backup the current settings and customize your macOS experience.

## System Settings

### Desktop & Dock

#### Dock

The script configures the Dock to be more minimal and efficient by:

* Removes almost all default apps
* Keep some default apps to the dock: \[Finder, Launchpad, Mission Control, System Settings, Activity Monitor, Folder Downloads, Trash]
* Add personalized applications: \[1Password, Postman, DBeaver, Docker, VSCode, Ghostty, Slack, Google Chrome, Brave Browser, superwhisper, Claude]
* Reduce the Dock size by half
* Magnification: off
* Dock position on the screen = Left
* Minimize windows using scale effect
* Enable: minimize windowss into application icons
* Enable: automatically hide and show the dock
* Disable: opening animations
* Enable: indicators for open applications
* Disable: show recent applications in Dock

#### Menu bar

The script declutters the menu bar by:

* Hiding Wi-Fi icon (available in Control Center)
* Hiding Bluetooth icon (available in Control Center)
* Showing battery percentage
* Hiding Spotlight
* Hiding Siri

#### Windows & apps

* Set prefer tabs when opening documents to "Always"
* Disable: Ask to keep changes when closing documents
* Enable: Close windows when quittnig an application
* Disable stage manager
* Set default browser to Brave Browser

#### Mission Control

* Disable: Automatically rearange Spaces based on most recent use
* Enable: When switching to an application, switch to a Space with open window for the application
* Disable: Group windows by application
* Enable: Displays have separate Spaces

### Notifications

* Set Show previews to "When Unlocked"
* Disable: Allow notifications when the display is sleeping
* Disable: Allow notifications when the screen is locked
* Disable: Allow notifications when mirroring or sharing the display

### Control Center

#### Control Center Modules

* Wifi: Don't show in menu bar
* Bluetooth: Don't show in menu bar
* Airdrop: Don't show in menu bar
* Focus: Show when Active
* Stage Manager: Don't show in menu bar
* Screen Mirroring: Show when Active
* Display: Show when Active
* Sound: Show when Active
* Now Playing: Show when Active

#### Clock

**Date**

* Set: Show date to "When Space Allows"
* Enable: Show day of the week

**Time**

* Enable: Use a 24-hour clock

#### Menu Bar Only

* Spotlight: Don't show in menu bar
* Siri: Don't show in menu bar
* Time Machine: Don't show in menu bar

### Siri & Spotlight

#### Search resutls

* Disable: Fonts
* Disable: Images
* Disable: Mail & Messages
* Disable: Movies
* Disable: Music
* Disable: Other
* Disable: Presentations
* Disable: Spreadsheets
* Disable: Tips

### Energy saver

* Enable: Put hard diskt to sleep when possible
* Disable: Wake for network access
* Disable: Start up automatically after a power failure

### Lock Screen

* Set: Start screen saver when inactive to "Never"
* Set: Turn display off when inactive to: "For 10 minutes"
* Set: Require password after screen saver begins or display is turned off to "After 1 hour"

### Trackpad & Mouse Settings

* Set: Tracking speed to 80%
* Enable: tap to click
* Enable: all scroll and zoom options
* Enable: all gesture options

## Finder Settings

* Set view as list
* Show Path Bar
* Show Status Bar

### General

**Show these items on the desktop:**

* Disable: Hard disk
* Disable: CDs, DVDs, and iPods
* Disable: Connected servers

**New Finder windows show:**

* Set to: \$HOME/dev
* Disable: Open folders in tabs instead of new windows

### Tags

* Delete all tags

### Sidebar

**Favorites**

* Disable: recents
* Disable: On My Mac
* Disable: Movies
* Disable: Music
* Disable: Picture

**iCloud**

* Disable: Shared

### Advanced

* Enable: Show all filename extensions
* Disable: Show warning before changing an extension
* Disable: Show warning before removing from iCloud Drive
* Disable: Show warning before emptying the Trash
* Enable: Remove items from the Trash after 30 days

**Keep folders on top**

* Enable: In windows when sorting by name
* Enable: On Desktop

**When performing a search:**

* Set: Search the current folder

### Toolbar

* Add "Path"
* Remove "Tags"

</ProgrammaticTasks>
