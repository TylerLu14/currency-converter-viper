//
//  Themeable.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/10/21.
//

import UIKit

enum ThemeType: String, CaseIterable, Persistable {
    case light = "Light"
    case dark = "Dark"
}

struct ThemeManager {
    static let shared = ThemeManager()
    
    private let themeDictionary: [ThemeType:Theme] = [
        .light: LightTheme(),
        .dark: DarkTheme()
    ]
    
    private var themePersistent = Persistent<ThemeType>(key: "Theme", defaultValue: .light)
    
    var selectedThemeType: ThemeType {
        get { return themePersistent.value }
        set { themePersistent.value = newValue }
    }
    
    var currentTheme: Theme {
        return themeDictionary[selectedThemeType] ?? LightTheme()
    }
}

protocol Theme {
    var backgroundColor: UIColor { get }
    var accentColor: UIColor { get }
    
    var primaryTextColor: UIColor { get }
    var secondaryTextColor: UIColor { get }
    
    var textFieldBackgroundColor: UIColor { get }
    var textFieldTextColor: UIColor { get }
    var textFieldPlaceholderTextColor: UIColor { get }
}


struct LightTheme: Theme {
    let backgroundColor = Color.Gray.level_0
    let accentColor = Color.Yellow.level_600
    
    let primaryTextColor = Color.Gray.level_850
    let secondaryTextColor = Color.Yellow.level_400
    
    let textFieldBackgroundColor = Color.Gray.level_50
    let textFieldTextColor = Color.Gray.level_850
    let textFieldPlaceholderTextColor = Color.Gray.level_400.withAlphaComponent(0.5)
}

struct DarkTheme: Theme {
    let backgroundColor = Color.Gray.level_900
    let accentColor = Color.Yellow.level_600
    
    let primaryTextColor = Color.Gray.level_0
    let secondaryTextColor = Color.Yellow.level_300
    
    let textFieldBackgroundColor = Color.Gray.level_850
    let textFieldTextColor = Color.Gray.level_0
    let textFieldPlaceholderTextColor = Color.Gray.level_600.withAlphaComponent(0.5)
}

protocol Themeable {
    func refreshTheme(theme: Theme)
}
