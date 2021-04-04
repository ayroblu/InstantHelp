//
//  HotKeyView.swift
//  InstantHelp
//
//  Created by Ben on 3/04/21.
//

import SwiftUI

struct HotKeyView: View {
    @Binding var hotkey: KeyCombo
    @State private var isRecording = false
    @Environment(\.keyPublisher) var keyPublisher
    
    var body: some View {
        HStack {
            Text("HotKey:")
            if isRecording {
                Button("press a shortcut") {
                    print("pressed")
                }
                .onReceive(keyPublisher) { event in
                    if let key = Key(carbonKeyCode: UInt32(event.keyCode)) {
                        hotkey = KeyCombo(key: key, modifiers: event.modifierFlags)
                        isRecording = false
                    }
                }
            } else {
                Button(hotkey.description) {
                    print("pressed")
                    isRecording = true
                }
            }
        }
    }
}

