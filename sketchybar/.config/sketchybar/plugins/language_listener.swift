#!/usr/bin/swift

import Foundation
import Cocoa

class InputSourceMonitor {
    static func main() {
        let center = DistributedNotificationCenter.default()
        
        // Listen for input source change notifications
        center.addObserver(
            forName: NSNotification.Name("com.apple.Carbon.TISNotifySelectedKeyboardInputSourceChanged"),
            object: nil,
            queue: nil
        ) { _ in
            // Trigger sketchybar event
            let task = Process()
            task.launchPath = "/usr/bin/env"
            task.arguments = ["sketchybar", "--trigger", "input_source_changed"]
            task.launch()
        }
        
        // Also listen for the more general input source changes
        center.addObserver(
            forName: NSNotification.Name("com.apple.Carbon.TISNotifyEnabledKeyboardInputSourcesChanged"),
            object: nil,
            queue: nil
        ) { _ in
            let task = Process()
            task.launchPath = "/usr/bin/env"
            task.arguments = ["sketchybar", "--trigger", "input_source_changed"]
            task.launch()
        }
        
        print("Language input source monitor started...")
        
        // Keep the program running
        RunLoop.main.run()
    }
}

InputSourceMonitor.main()
