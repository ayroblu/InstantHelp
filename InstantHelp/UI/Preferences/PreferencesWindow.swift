//
//  PreferencesWindow.swift
//  InstantHelp
//
//  Created by Ben on 4/04/21.
//

import Cocoa
import SwiftUI
import Combine

class PreferencesWindow: NSWindow {
    static func setup() {
        let preferencesToolbarView = PreferencesToolbarView()
        let titlebarAccessory = NSTitlebarAccessoryViewController()
        titlebarAccessory.view = NSHostingView(rootView: preferencesToolbarView)
        
        prefWindow = PreferencesWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 500),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        prefWindow.setFrameAutosaveName("Instant Help Preferences")
        
        let preferencesView = PreferencesView()
            .environment(\.keyPublisher, prefWindow.keyEventPublisher)
        prefWindow.contentView = NSHostingView(rootView: preferencesView)
        prefWindow.addTitlebarAccessoryViewController(titlebarAccessory)
        prefWindow.title = "Preferences"
        prefWindow.center()
        prefWindow.isReleasedWhenClosed = false
    }
    
    private let publisher = PassthroughSubject<NSEvent, Never>()

    var keyEventPublisher: AnyPublisher<NSEvent, Never> {
        publisher.eraseToAnyPublisher()
    }

    override func keyDown(with event: NSEvent) {
        publisher.send(event)
    }
    
    @objc func show() {
        makeKeyAndOrderFront(nil)
        orderFrontRegardless()
    }
}

