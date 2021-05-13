//
//  Menubar.swift
//  InstantHelp
//
//  Created by Ben on 3/04/21.
//

import Cocoa

class Menubar {
    static var statusItem: NSStatusItem!

    static func initialize() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.menu = NSMenu()
        statusItem.menu!.title = "Menubar"
        statusItem.menu!.addItem(
            withTitle: NSLocalizedString("Preferences…", comment: "Menubar option"),
            action: #selector(prefWindow.show),
            keyEquivalent: ",").target = prefWindow
        statusItem.menu!.addItem(NSMenuItem.separator())
        statusItem.menu!.addItem(
            withTitle: String(format: NSLocalizedString("Quit", comment: "Menubar option")),
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q")
        loadPreferredIcon()
    }

    static private func loadPreferredIcon() {
        let image = NSImage(named: "menubar-icon")!
        image.isTemplate = true
        statusItem.button!.image = image
        statusItem.isVisible = true
        statusItem.button!.imageScaling = .scaleProportionallyUpOrDown
    }
}

