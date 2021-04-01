//
//  AppDelegate.swift
//  InstantHelp
//
//  Created by Ben on 1/04/21.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
//    var containerPanel: ContainerPanel!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        self.containerPanel = ContainerPanel()
        // Create the status item
//        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        askPermission()
        
        let panel = getMainPanel()
        monitorKeyStrokes(with: panel)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

// Consider adding: https://stackoverflow.com/questions/42806005/how-can-my-cocoa-application-be-notified-of-nsscreen-resolution-changes/42807363
func getContentRect() -> NSRect {
    let screenRect: CGRect = NSScreen.main!.frame
    return NSRect(
        x: screenRect.width/4,
        y: screenRect.height/4,
        width:  screenRect.width/2,
        height: screenRect.height/2
    )
}
func getMainPanel() -> NSPanel {
    let panel = NSPanel(
        contentRect: getContentRect(),
        styleMask: .nonactivatingPanel,
        backing: .buffered,
        defer: false
    )
    panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    panel.backgroundColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
    panel.level = .popUpMenu
    panel.contentView = NSHostingView(rootView: ContentView())
    panel.isFloatingPanel = true
    panel.orderOut(nil)
    return panel
}

func askPermission() {
    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
    let accessEnabled = AXIsProcessTrustedWithOptions(options)

    if !accessEnabled {
        print("Access Not Enabled")
    }
}

func monitorKeyStrokes(with panel: NSPanel) {
    NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) {
        switch $0.modifierFlags.intersection(.deviceIndependentFlagsMask) {
            case [.command]:
                openPanelWithDelay(panel)
            default:
                cancelOrClosePanel(panel)
        }
    }
}

fileprivate func openPanelWithDelay(_ panel: NSPanel) {
    let myTask = DispatchWorkItem {
        panel.setFrame(getContentRect(), display: true)
        panel.makeKeyAndOrderFront(nil)
        isOpen = true
        task = nil
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: myTask)
    task = myTask
}

fileprivate func cancelOrClosePanel(_ panel: NSPanel) {
    if let myTask = task {
        myTask.cancel()
        task = nil
    }
    if isOpen == true {
        panel.orderOut(nil)
        isOpen = false
    }
}

fileprivate var isOpen = false
fileprivate var task: DispatchWorkItem?

