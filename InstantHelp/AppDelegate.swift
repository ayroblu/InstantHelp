//
//  AppDelegate.swift
//  InstantHelp
//
//  Created by Ben on 1/04/21.
//

import Cocoa
import SwiftUI
import Carbon.HIToolbox.Events

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        askPermission()
        Menubar.initialize()
        initMainPanel()
        monitorKeyStrokes()
        PreferencesWindow.setup()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func showPrefWindow() {
        prefWindow.makeKeyAndOrderFront(nil)
        prefWindow.orderFrontRegardless()
    }
}

var panel: NSPanel!

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
func initMainPanel() {
    panel = NSPanel(
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
}

func askPermission() {
    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
    let accessEnabled = AXIsProcessTrustedWithOptions(options)

    if !accessEnabled {
        print("Access Not Enabled")
    }
}

// HotKey is a copy of https://github.com/soffes/HotKey
// Need to make sure that HotKey is kept in scope, otherwise it will be deallocated
let hotKey = HotKey(key: .f19, modifiers: [.option])
func monitorKeyStrokes() {
    hotKey.keyDownHandler = {
        openPanel()
    }
    hotKey.keyUpHandler = {
        cancelOrClosePanel()
    }
}

fileprivate func openPanelWithDelay() {
    let myTask = DispatchWorkItem{
        openPanel()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: myTask)
    task = myTask
}

fileprivate func openPanel() {
    panel.setFrame(getContentRect(), display: true)
    panel.makeKeyAndOrderFront(nil)
    isOpen = true
    task = nil
}

fileprivate func cancelOrClosePanel() {
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

var prefWindow: PreferencesWindow!

