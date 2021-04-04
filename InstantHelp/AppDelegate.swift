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
        setHotKeyConfigs(helpConfigs: Preferences.HelpConfigs.value)
        PreferencesWindow.setup()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc static func showPrefWindow() {
        prefWindow.makeKeyAndOrderFront(nil)
        prefWindow.orderFrontRegardless()
    }
}

var panel: NSPanel!

var prefWindow: PreferencesWindow!

// HotKey is a copy of https://github.com/soffes/HotKey
// When hotkeys are removed from scope (this array) they will be deallocated, i.e. stop listening
var hotKeyConfigs: [HotKeyConfig] = []
