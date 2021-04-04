//
//  HelpConfigView.swift
//  InstantHelp
//
//  Created by Ben on 3/04/21.
//

import SwiftUI

struct HelpConfigView: View {
    @Binding var helpConfig: HelpConfig
    
    var body: some View {
        VStack {
            HotKeyView(hotkey: $helpConfig.hotKey)
            ImagePickerView(helpConfig: $helpConfig)
            Toggle("Is Enabled", isOn: $helpConfig.isEnabled)
                .toggleStyle(SwitchToggleStyle())
        }
    }
}

struct ImagePickerView: View {
    @Binding var helpConfig: HelpConfig
    
    var body: some View {
        if let imageUrl = helpConfig.imageUrl, FileManager.default.fileExists(atPath: imageUrl) {
            Button(action: {
                openImagePicker(initialUrlPath: URL(fileURLWithPath: imageUrl))
            }) {
                Image(nsImage: getImage(filePath: imageUrl)!)
                    .resizable()
//                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            Button("Add an image") {
                openImagePicker()
            }
        }
    }
    
    private func openImagePicker(initialUrlPath: URL? = nil) {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Select Image"
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["png", "jpg", "jpeg"]
        if let initialUrlPath = initialUrlPath {
            openPanel.directoryURL = initialUrlPath
        }
        openPanel.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {
                if let selectedPath = openPanel.url?.path {
                    helpConfig.imageUrl = selectedPath
                }
            }
        }
    }
}

fileprivate func getImage(filePath: String) -> NSImage? {
    let url = URL(fileURLWithPath: filePath)
    let data = try? Data(contentsOf: url)
    if let data = data {
        return NSImage(data: data)
    }
    return nil
}
