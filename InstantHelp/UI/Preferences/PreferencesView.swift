//
//  PreferencesView.swift
//  InstantHelp
//
//  Created by Ben on 3/04/21.
//

import SwiftUI

struct PreferencesView: View {
    @State private var flag = false

    var body: some View {
        Group {
            if !flag {
                Color.clear.onAppear { self.flag = true }
            } else {
                MainPreferencesView()
            }
        }
    }
}

struct MainPreferencesView: View {
    @State private var helpConfigs: [HelpConfig] = Preferences.HelpConfigs.value {
        didSet {
            Preferences.HelpConfigs.value = helpConfigs
            setHotKeyConfigs(helpConfigs: helpConfigs)
        }
    }
    @State private var helpConfigUuidToDelete: UUID? = nil
    
    var body: some View {
        let isShowingBinding: Binding<Bool> = Binding(
            get: { helpConfigUuidToDelete != nil },
            set: { _ in helpConfigUuidToDelete = nil }
        )
        
        ScrollView {
            VStack {
                ForEach(helpConfigs) { helpConfig in
                    let helpConfigBinding: Binding<HelpConfig> = Binding(
                        get: { helpConfig },
                        set: { newHelpConfig in
                            if let index = helpConfigs.firstIndex(where: {newHelpConfig.id == $0.id}) {
                                helpConfigs[index] = newHelpConfig
                            }
                        }
                    )
                    HelpConfigView(helpConfig: helpConfigBinding)
                    Button(action: {
                        helpConfigUuidToDelete = helpConfig.id
                    }) {
                        Text("Delete Help Config")
                    }
                    Divider()
                }
                Button(action: {
                    let newHelpConfig = HelpConfig(
                        id: UUID(),
                        hotKey: nil,
                        imageUrl: nil,
                        isEnabled: true
                    )
                    helpConfigs.append(newHelpConfig)
                }) {
                    Text("Add Help Config")
                }
            }
            .alert(isPresented: isShowingBinding) {
                Alert(
                    title: Text("Are you sure you want to delete this?"),
                    message: Text("This action cannot be undone"),
                    primaryButton: .destructive(Text("Delete")) {
                        helpConfigs.removeAll(where: {helpConfigUuidToDelete == $0.id})
                        helpConfigUuidToDelete = nil
                    },
                    secondaryButton: .cancel()
                )
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}



struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
