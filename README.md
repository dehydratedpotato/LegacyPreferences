<h1 align="center" style="">Legacy System Preferences</h1>
<p align="center">
An expiremental, jank, slightly reverse-engineered attempt to return the old System Preferences to MacOS Ventura. Work in progress!
</p>
<p align="center">
<a href="">
       <img alt="Silicon Support" src="https://img.shields.io/badge/Support-MacOS_Ventura_13.0+-orange.svg"/>
    </a>
        <a href="">
       <img alt="Silicon Support" src="https://img.shields.io/badge/Status-Jank-white.svg"/>
    </a>
    <a href="https://github.com/BitesPotatoBacks/LegacySystemPreferences/releases">
        <img alt="Releases" src="https://img.shields.io/github/release/BitesPotatoBacks/LegacySystemPreferences.svg"/>
    </a>
      <!--
    <a href="https://github.com/BitesPotatoBacks/LegacySystemPreferences/stargazers">
        <img alt="Stars" src="https://img.shields.io/github/stars/BitesPotatoBacks/LegacySystemPreferences.svg"/>
    </a>
    -->
</p>

<p align="center">
Example screenshot:
</p>


<p align="center">
<img src="https://user-images.githubusercontent.com/83843298/201423236-261cd319-a289-4ddd-8ed3-7f213dcc15a6.png" width="548" height="474">
</p>

# :wave: Wait! Functionality Warning
Due to the nature of the project, some panes may be unstable or have limited functionality (see [Pane Status Table](#pane-status-table)), and some crucial features are not yet implemented (see [Completion Checklist](#completion-checklist)).

Some panes may require different privacy privileges in order to work properly. For example, screen recording for **Appearance** (weird, right?) or input monitoring for the keyboard menu in **Accessibility**.

# Project Deets
### Wat it do?
In order restore the classic System Preferences (albeit in a pretty janky manner), we use the NSPreferencePane framework in order to interface with `.prefPane` files. New MacOS still contains the old `.prefPanes`, but most of the bundles are empty (as App Extensions are now used); so instead of using the newer empty files, we rip the completed old ones ([these](https://drive.google.com/drive/folders/1XXXov0TvGNJbwaqKJWsqp0x2cYOKh099?usp=share_link)) out of a previous release of MacOS.

(We don't use the new App Extension files because that would require manually recreating each classic Pane view) 

### Why it do?
Because some of us miss the ways of old (see new [System Settings](https://9to5mac.com/2022/06/06/macos-13-ventura-system-settings-first-look/)).

### Construction!
The project source code is constructed from a weird mismash of old-Swift NSApp lifecycle, SwiftUI, and Objective-C. This frankenstein is both necessary, convenient, and a horrible pain.

# Old Preference Pane Installation
1. Download the preference panes [from here](https://drive.google.com/drive/folders/1XXXov0TvGNJbwaqKJWsqp0x2cYOKh099?usp=share_link).
2. Unzip the download. Use Finder to **Rename > Add Text**. Then, append the extension `.prefPane` to all items in unzipped directory.
3. Make a folder `/Library/LegacyPrefPanes` and move the preference panes into it. 

**Note:** Just like classic System Preferences, this app will not function without `.prefPane` files. If `/Library/LegacyPrefPanes` is empty, you will have no panes available. 

4. Finally, open `/Library/LegacyPrefPanes` in Terminal, and run the `pane_stripper.sh` tool (located in source or [release DMG](https://github.com/BitesPotatoBacks/LegacySystemPreferences/releases)). Don't forget to chmod it first!
5. NOW, YOU ARE READY.

### Waitaminute! What does `pane_stripper.sh` do?
`pane_stripper.sh` removes the code signature of all pref panes (for compatibilty), and flags them as safe to the system (to stop the system from killing the pane for not having a signature).


___

# :warning: Halt! Misc Disclaimers and Warnings
- The app icon used by Legacy System Preferences was designed by Apple, not I, and belongs to the native System Preferences/Settings app.
- The classic preference panes used by this app ([these](https://drive.google.com/drive/folders/1XXXov0TvGNJbwaqKJWsqp0x2cYOKh099?usp=share_link)) were written and licensed by Apple, not I, and were ripped from a previous release of MacOS.
- The app is compiled for x86 due to compatability reasons, and must run under Rosetta for Apple Silicon machines.

If any preference pane (3rd party or distributed by me via old macOS) via this app decides to wig out and bricks your machine or nukes your filesystem, don't blame me for the catastrophe. This project is very much a jank experiment. **You've been warned!!!**

___

## Completion Checklist
This is a checklist of crucial features I need to add and are in development currently.
- [ ] User Avatar Setting
- [ ] Search with Spotlight Focus
- [ ] Backwards/Forwards Navigation
- [ ] Crossfade Transitions
- [ ] Alphabetical Pane Sorting
- [ ] Pane Enable/Disable
- [ ] 3rd Party Pane Support
- [X] ~~Pane Loading~~

## Pane Status Table
This is a report of old system prefs ([these](https://drive.google.com/drive/folders/1XXXov0TvGNJbwaqKJWsqp0x2cYOKh099?usp=share_link)) and their status. Note that the `Appearance` pane works but is slightly unstable.
| Status | Pane(s)
| ---- | ---- |
| Seemingly Working | General, Spotlight, Language & Region, Sound, Sidecar, Date & Time, Energy Saver, Sharing, Network, Mouse, Security & Privacy, Extensions, Users & Groups, Mission Control |
| Missing Crucial Funcs | Apple ID, Internet Accounts, Notifications, Destop & Screensaver, Software Update, Startup Disk |
| Failing | Fibre Channel, Dock, Family Sharing, Printer & Scanner, Siri, Blueooth, Keyboard, Trackpad, Displays, Classroom, Profiles, Screen Time, Time Machine, Wallet |
| Untested or Seemingly Working | Battery, CDs & DVDs |
