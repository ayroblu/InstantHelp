//
//  Preferences.swift
//  InstantHelp
//
//  Created by Ben on 4/04/21.
//

import Foundation

struct Preferences {
    struct HelpConfigs: Preference {
        static let key = "HelpConfigs"
        static var value: [HelpConfig] {
            get {
                let helpConfigs: [HelpConfig]? = UserDefaults.standard.codable(forKey: key)
                return helpConfigs ?? []
            }
            set {
                UserDefaults.standard.set(value: newValue, forKey: key)
            }
        }
    }
}

protocol Preference {
    associatedtype Value
    static var key: String { get }
    static var value: Value { get set }
}
