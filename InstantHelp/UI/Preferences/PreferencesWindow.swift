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
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
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
        prefWindow.makeKeyAndOrderFront(nil)
        prefWindow.orderFrontRegardless()
    }
    
    private let publisher = PassthroughSubject<NSEvent, Never>() // private

    var keyEventPublisher: AnyPublisher<NSEvent, Never> { // public
        publisher.eraseToAnyPublisher()
    }

    override func keyDown(with event: NSEvent) {
        publisher.send(event)
    }
}

// Environment key to hold even publisher
struct WindowEventPublisherKey: EnvironmentKey {
    static let defaultValue: AnyPublisher<NSEvent, Never> =
        Just(NSEvent()).eraseToAnyPublisher() // just default stub
}


// Environment value for keyPublisher access
extension EnvironmentValues {
    var keyPublisher: AnyPublisher<NSEvent, Never> {
        get { self[WindowEventPublisherKey.self] }
        set { self[WindowEventPublisherKey.self] = newValue }
    }
}
