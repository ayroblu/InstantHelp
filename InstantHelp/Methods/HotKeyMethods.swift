//
//  HotKeyMethods.swift
//  InstantHelp
//
//  Created by Ben on 4/04/21.
//

import Foundation

func disableHotKeyConfigs() {
    hotKeyConfigs.forEach { hotKeyConfig in
        hotKeyConfig.hotKey.keyDownHandler = nil
        hotKeyConfig.hotKey.keyUpHandler = nil
        hotKeyConfig.hotKey.isPaused = true
    }
}
func setHotKeyConfigs(helpConfigs: [HelpConfig]) {
    disableHotKeyConfigs()
    hotKeyConfigs = helpConfigs.filter { helpConfig in
        if helpConfig.hotKey != nil, helpConfig.imageUrl != nil {
            return true
        }
        return false
    }.map { helpConfig in
        HotKeyConfig(id: helpConfig.id, hotKey: HotKey(keyCombo: helpConfig.hotKey!), imageUrl: helpConfig.imageUrl!)
    }
    monitorKeyStrokes()
}
