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
//    var containerPanel: ContainerPanel!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        self.containerPanel = ContainerPanel()
        // Create the status item
//        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        askPermission()
        Menubar.initialize()
        initPrefWindow()
        let panel = getMainPanel()
        monitorKeyStrokes(with: panel)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func showPrefWindow() {
        prefWindow.makeKeyAndOrderFront(nil)
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

// HotKey is a copy of https://github.com/soffes/HotKey
// Need to make sure that HotKey is kept in scope, otherwise it will be deallocated
let hotKey = HotKey(key: .f19, modifiers: [.option])
func monitorKeyStrokes(with panel: NSPanel) {
    hotKey.keyDownHandler = {
        openPanel(panel)
    }
    hotKey.keyUpHandler = {
        cancelOrClosePanel(panel)
    }
}

fileprivate func openPanelWithDelay(_ panel: NSPanel) {
    let myTask = DispatchWorkItem{
        openPanel(panel)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: myTask)
    task = myTask
}

fileprivate func openPanel(_ panel: NSPanel) {
    panel.setFrame(getContentRect(), display: true)
    panel.makeKeyAndOrderFront(nil)
    isOpen = true
    task = nil
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

var prefWindow: NSWindow!

func initPrefWindow() {
    // Create the SwiftUI view that provides the window contents.
    let contentView = ContentView()

    // Create the window and set the content view.
    prefWindow = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    prefWindow.center()
    prefWindow.setFrameAutosaveName("Instant Help")
    prefWindow.contentView = NSHostingView(rootView: contentView)
    prefWindow.makeKeyAndOrderFront(nil)
}
