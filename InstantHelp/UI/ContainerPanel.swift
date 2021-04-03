//
//  ContainerPanel.swift
//  InstantHelp
//
//  Created by Ben on 1/04/21.
//

import Cocoa

class ContainerPanel: NSPanel {
    var myContentView = MyContentView()
    override var canBecomeKey: Bool { true }

    convenience init() {
        self.init(contentRect: .zero, styleMask: .nonactivatingPanel, backing: .buffered, defer: false)
        isFloatingPanel = true
        hidesOnDeactivate = false
        hasShadow = false
        titleVisibility = .hidden
        backgroundColor = .clear
        contentView!.addSubview(myContentView)
        preservesContentDuringLiveResize = false
        disableSnapshotRestoration()
        // triggering AltTab before or during Space transition animation brings the window on the Space post-transition
        collectionBehavior = .canJoinAllSpaces
        // 2nd highest level possible; this allows the app to go on top of context menus
        // highest level is .screenSaver but makes drag and drop on top the main window impossible
        level = .popUpMenu
        // helps filter out this window from the thumbnails
        setAccessibilitySubrole(.unknown)
    }

    func show() {
        makeKeyAndOrderFront(nil)
//        MouseEvents.toggle(true)
    }
}
