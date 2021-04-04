//
//  Types.swift
//  InstantHelp
//
//  Created by Ben on 4/04/21.
//

import Cocoa
import SwiftUI
import Combine

struct HelpConfig: Codable, Identifiable {
    let id: UUID
    var hotKey: KeyCombo?
    var imageUrl: String?
    var isEnabled: Bool
}

struct HotKeyConfig: Identifiable {
    let id: UUID
    var hotKey: HotKey
    var imageUrl: String
}

// MARK: Adds all Codable structs to UserDefaults

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

// MARK: Sending environment events to views from NS

// Environment key to hold event publisher
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
