# MonitorSleeper

When the MacBook is connected to a TV-monitor that doesn't turn off when the MacBook screen turns off on idling.

Solved by plugging the TV into a Tapo Wi-Fi Smart Plug that can then be controlled by a python script on the MacBook.

This `monitorsleeper.swift` compiles into a lightweight executable that listens for the MacBook display sleeping/waking and triggers a pre-configured Shortcut that runs a python script.

## Usage

1. Compilation

   ```
   swiftc monitorsleeper.swift -o ~/monitor_sleeper
   ```

2. Create LaunchAgent to automatically run the binary at login

   `~/Library/LaunchAgents/com.user.monitorsleeper.plist`

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "[http://www.apple.com/DTDs/PropertyList-1.0.dtd](http://www.apple.com/DTDs/PropertyList-1.0.dtd)">
   <plist version="1.0">
   <dict>
   <key>Label</key>
   <string>com.user.monitorsleeper</string>
   <key>ProgramArguments</key>
   <array>
       <string>/Users/USERNAME/monitor_sleeper</string>
   </array>
       <key>KeepAlive</key>
   <true/>
   <key>RunAtLoad</key>
   <true/>
   </dict>
   </plist>

   ```

3. To activate immediately...
   ```
   launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.monitorsleeper.plist
   ```
