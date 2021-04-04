//
//  HotKeyView.swift
//  InstantHelp
//
//  Created by Ben on 3/04/21.
//

import SwiftUI

struct HotKeyView: View {
    @Binding var hotkey: KeyCombo?
    @State private var isRecording = false
    @Environment(\.keyPublisher) var keyPublisher
    
    var body: some View {
        HStack {
            Text("HotKey:")
            if isRecording {
                Button("Press a shortcut...") {}
                .onReceive(keyPublisher) { event in
                    if let key = Key(carbonKeyCode: UInt32(event.keyCode)) {
                        hotkey = KeyCombo(key: key, modifiers: event.modifierFlags)
                        isRecording = false
                    }
                }
            } else if let hotkey = hotkey {
                Button(hotkey.description) {
                    isRecording = true
                }
            } else {
                Button("Record a shortcut") {
                    isRecording = true
                }
            }
        }
    }
}

