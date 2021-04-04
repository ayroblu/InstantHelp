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
    private static let helpConfigsKey: String = "HelpConfigs"
    @State private var helpConfigs: [HelpConfig] = getHelpConfigs() {
        didSet {
            UserDefaults.standard.set(value: helpConfigs, forKey: MainPreferencesView.helpConfigsKey)
        }
    }
    @State private var helpConfigUuidToDelete: UUID? = nil
    
    var body: some View {
        let isShowingBinding: Binding<Bool> = Binding(
            get: { helpConfigUuidToDelete != nil },
            set: { _ in helpConfigUuidToDelete = nil }
        )
        
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
            }
            Button(action: {
                let newHelpConfig = HelpConfig(
                    id: UUID(),
                    hotKey: KeyCombo(key: .a, modifiers: [.command]),
                    imageUrl: "",
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private static func getHelpConfigs() -> [HelpConfig] {
        let helpConfigs: [HelpConfig]? = UserDefaults.standard.codable(forKey: helpConfigsKey)
        return helpConfigs ?? []
    }
}

struct HelpConfig: Codable, Identifiable {
    let id: UUID
    var hotKey: KeyCombo
    var imageUrl: String
    var isEnabled: Bool
}

// https://itnext.io/adding-codable-support-to-userdefaults-with-swift-26a799bf00e1
extension UserDefaults {
    func set<Element: Codable>(value: Element, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        UserDefaults.standard.setValue(data, forKey: key)
    }
    func codable<Element: Codable>(forKey key: String) -> Element? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let element = try? JSONDecoder().decode(Element.self, from: data)
        return element
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
