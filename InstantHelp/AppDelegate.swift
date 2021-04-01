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

    var window: NSWindow!
    var containerPanel: ContainerPanel!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        self.containerPanel = ContainerPanel()

        // Create the window and set the content view.
//        window = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
//            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
//            backing: .buffered, defer: false)
//        window.isReleasedWhenClosed = false
//        window.center()
//        window.setFrameAutosaveName("Main Window")
//        window.contentView = NSHostingView(rootView: contentView)
//        window.makeKeyAndOrderFront(nil)
//        containerPanel.makeKeyAndOrderFront(nil)
        
        let screenRect: CGRect = NSScreen.main!.frame
        let panel = NSPanel(
            contentRect: NSRect(
                x: screenRect.width/4,
                y: screenRect.height/4,
                width:  screenRect.width/2,
                height: screenRect.height/2
            ),
            styleMask: .nonactivatingPanel,
            backing: .buffered,
            defer: false
        )
        panel.collectionBehavior = .canJoinAllSpaces
//        panel.alphaValue = 0.5
        panel.backgroundColor = NSColor.black
        panel.level = .popUpMenu
        panel.contentView = NSHostingView(rootView: contentView)
        panel.makeKeyAndOrderFront(nil)
        panel.isFloatingPanel = true
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

