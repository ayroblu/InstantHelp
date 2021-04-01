//
//  MyContentView.swift
//  InstantHelp
//
//  Created by Ben on 1/04/21.
//

import Cocoa

class MyContentView: NSVisualEffectView {
    let scrollView = ScrollView()

    convenience init() {
        self.init(frame: .zero)
//        material = Preferences.windowMaterial
        state = .active
        wantsLayer = true
        addSubview(scrollView)
    }
}

class ScrollView: NSScrollView {
    // overriding scrollWheel() turns this false; we force it to be true to enable responsive scrolling
    override class var isCompatibleWithResponsiveScrolling: Bool { true }

    var isCurrentlyScrolling = false

    convenience init() {
        self.init(frame: .zero)
        drawsBackground = false
        hasVerticalScroller = true
        scrollerStyle = .overlay
        scrollerKnobStyle = .light
        horizontalScrollElasticity = .none
        usesPredominantAxisScrolling = true
        observeScrollingEvents()
    }

    private func observeScrollingEvents() {
        NotificationCenter.default.addObserver(forName: NSScrollView.didEndLiveScrollNotification, object: nil, queue: nil) { [weak self] _ in
            self?.isCurrentlyScrolling = false
        }
        NotificationCenter.default.addObserver(forName: NSScrollView.willStartLiveScrollNotification, object: nil, queue: nil) { [weak self] _ in
            self?.isCurrentlyScrolling = true
        }
    }
}
