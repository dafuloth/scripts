import AppKit
import Foundation

final class MonitorSleeper {
    private var observers: [NSObjectProtocol] = []

    init() {
        let nc = NSWorkspace.shared.notificationCenter

        observers.append(
            nc.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: .main) { _ in
                print("Display(s) went to sleep...")
                self.runShortcut(name: "Monitor Off")
            }
        )

        observers.append(
            nc.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: .main) { _ in
                print("Display(s) woke up...")
                self.runShortcut(name: "Monitor On")
            }
        )
    }

    deinit {
        let nc = NSWorkspace.shared.notificationCenter
        observers.forEach { nc.removeObserver($0) }
    }

    private func runShortcut(name: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
        process.arguments = ["run", name]
        do {
            try process.run()
        } catch {
            print("Failed to run shortcut: \(name), error: \(error)")
        }
    }
}

_ = NSApplication.shared
NSApp.setActivationPolicy(.prohibited)

let sleeper = MonitorSleeper()
NSApp.run()