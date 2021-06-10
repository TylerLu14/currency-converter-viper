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

class ThemeManager {
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
    var lineColor: UIColor { get }
    
    var primaryTextColor: UIColor { get }
    var secondaryTextColor: UIColor { get }
    var disabledTextColor: UIColor { get }
    
    var textFieldBackgroundColor: UIColor { get }
    var textFieldTextColor: UIColor { get }
    var textFieldPlaceholderTextColor: UIColor { get }
    
    var textOnYellowColor: UIColor { get }
    
    var buttonBackgroundColor: UIColor { get }
    var highlightedNuttonBackgroundColor: UIColor { get }
    var disabledbuttonBackgroundColor: UIColor { get }
}


struct LightTheme: Theme {
    let backgroundColor = Color.Gray.level_0
    let accentColor = Color.Yellow.level_600
    let lineColor = Color.Gray.level_50
    
    let primaryTextColor = Color.Gray.level_850
    let secondaryTextColor = Color.Yellow.level_400
    let disabledTextColor = Color.Gray.level_200
    
    let textFieldBackgroundColor = Color.Gray.level_10
    let textFieldTextColor = Color.Gray.level_850
    let textFieldPlaceholderTextColor = Color.Gray.level_400
    
    let textOnYellowColor = Color.Gray.level_850
    
    let buttonBackgroundColor = Color.Yellow.level_400
    let highlightedNuttonBackgroundColor = Color.Yellow.level_500
    let disabledbuttonBackgroundColor = Color.Yellow.level_100
}

struct DarkTheme: Theme {
    let backgroundColor = Color.Gray.level_900
    let accentColor = Color.Yellow.level_600
    let lineColor = Color.Gray.level_700
    
    let primaryTextColor = Color.Gray.level_0
    let secondaryTextColor = Color.Yellow.level_300
    let disabledTextColor = Color.Gray.level_400
    
    let textFieldBackgroundColor = Color.Gray.level_850
    let textFieldTextColor = Color.Gray.level_0
    let textFieldPlaceholderTextColor = Color.Gray.level_400
    
    let textOnYellowColor = Color.Gray.level_850
    
    let buttonBackgroundColor = Color.Yellow.level_400
    let highlightedNuttonBackgroundColor = Color.Yellow.level_500
    let disabledbuttonBackgroundColor = Color.Yellow.level_600
}

protocol Themeable {
    func refreshTheme(theme: Theme)
}
