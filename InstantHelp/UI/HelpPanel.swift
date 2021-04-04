//
//  HelpPanel.swift
//  InstantHelp
//
//  Created by Ben on 4/04/21.
//

import Cocoa
import SwiftUI

// Consider adding: https://stackoverflow.com/questions/42806005/how-can-my-cocoa-application-be-notified-of-nsscreen-resolution-changes/42807363
func getContentRect() -> NSRect {
    let screenRect: CGRect = NSScreen.main!.frame
    let width = screenRect.width
    let height = screenRect.height
    return NSRect(
        x: screenRect.width/2 - width/2,
        y: screenRect.height/2 - height/2,
        width:  width,
        height: height
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
//    panel.contentView = NSHostingView(rootView: ContentView())
    panel.contentView = helpPanelImageView
    panel.isFloatingPanel = true
    panel.orderOut(nil)
}
var helpPanelImageView: NSImageView = NSImageView()
var lastImageUrl: String? = nil

func askPermission() {
    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
    let accessEnabled = AXIsProcessTrustedWithOptions(options)

    if !accessEnabled {
        print("Access Not Enabled")
    }
}

func monitorKeyStrokes() {
    hotKeyConfigs.forEach { hotKeyConfig in
        hotKeyConfig.hotKey.keyDownHandler = {
            openPanel(hotKeyConfig: hotKeyConfig)
        }
        hotKeyConfig.hotKey.keyUpHandler = {
            cancelOrClosePanel()
        }
    }
}

//fileprivate func openPanelWithDelay() {
//    let myTask = DispatchWorkItem{
//        openPanel()
//    }
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: myTask)
//    task = myTask
//}

fileprivate func openPanel(hotKeyConfig: HotKeyConfig) {
    panel.setFrame(getContentRect(), display: true)
    panel.makeKeyAndOrderFront(nil)
    if lastImageUrl != hotKeyConfig.imageUrl {
        helpPanelImageView.image = NSImage(contentsOfFile: hotKeyConfig.imageUrl)
        lastImageUrl = hotKeyConfig.imageUrl
    }
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
