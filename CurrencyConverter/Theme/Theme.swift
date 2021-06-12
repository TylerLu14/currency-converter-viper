//
//  Themeable.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/10/21.
//

import UIKit

enum ThemeType: Int, CaseIterable, Persistable {
    case light = 0
    case dark = 1
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
        set {
            themePersistent.value = newValue
            onThemeUpdated(theme: currentTheme)
        }
    }
    
    var currentTheme: Theme {
        return themeDictionary[selectedThemeType] ?? LightTheme()
    }
    
    func onThemeUpdated(theme: Theme) {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: theme.primaryTextColor]
        UINavigationBar.appearance().tintColor = theme.primaryTextColor
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        
        UITextField.appearance().keyboardAppearance = theme.keyboardAppearance
        
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        window?.findViewElement(ofType: Themeable.self).forEach{ themeable in
            themeable.refreshTheme(theme: theme)
        }
        
        window?.findElement(ofType: UITextField.self).forEach{ textField in
            textField.keyboardAppearance = theme.keyboardAppearance
        }
    }
}

protocol Theme {
    var statusBarStyle: UIStatusBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    
    var backgroundColor: UIColor { get }
    var selectedBackgroundColor: UIColor { get }
    var accentColor: UIColor { get }
    var lineColor: UIColor { get }
    
    var primaryTextColor: UIColor { get }
    var secondaryTextColor: UIColor { get }
    var disabledTextColor: UIColor { get }
    var errorTextColor: UIColor { get }
    
    var textFieldBackgroundColor: UIColor { get }
    var textFieldTextColor: UIColor { get }
    var textFieldPlaceholderTextColor: UIColor { get }
    
    var textOnYellowColor: UIColor { get }
    
    var buttonBackgroundColor: UIColor { get }
    var highlightedNuttonBackgroundColor: UIColor { get }
    var disabledbuttonBackgroundColor: UIColor { get }
}


struct LightTheme: Theme {
    let keyboardAppearance = UIKeyboardAppearance.light
    var statusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    let backgroundColor = Color.Gray.level_0
    let selectedBackgroundColor = Color.Gray.level_100
    let accentColor = Color.Yellow.level_600
    let lineColor = Color.Gray.level_50
    
    let primaryTextColor = Color.Gray.level_850
    let secondaryTextColor = Color.Gray.level_400
    let disabledTextColor = Color.Gray.level_200
    
    let textFieldBackgroundColor = Color.Gray.level_10
    let textFieldTextColor = Color.Gray.level_850
    let textFieldPlaceholderTextColor = Color.Gray.level_400
    let errorTextColor = Color.Red.level_500
    
    let textOnYellowColor = Color.Gray.level_850
    
    let buttonBackgroundColor = Color.Yellow.level_400
    let highlightedNuttonBackgroundColor = Color.Yellow.level_500
    let disabledbuttonBackgroundColor = Color.Gray.level_100
}

struct DarkTheme: Theme {
    let statusBarStyle = UIStatusBarStyle.lightContent
    let keyboardAppearance = UIKeyboardAppearance.dark
    
    let backgroundColor = Color.Gray.level_900
    let selectedBackgroundColor = Color.Gray.level_800
    let accentColor = Color.Yellow.level_600
    let lineColor = Color.Gray.level_700
    
    let primaryTextColor = Color.Gray.level_0
    let secondaryTextColor = Color.Gray.level_300
    let disabledTextColor = Color.Gray.level_400
    let errorTextColor = Color.Red.level_500
    
    let textFieldBackgroundColor = Color.Gray.level_850
    let textFieldTextColor = Color.Gray.level_0
    let textFieldPlaceholderTextColor = Color.Gray.level_400
    
    let textOnYellowColor = Color.Gray.level_850
    
    let buttonBackgroundColor = Color.Yellow.level_400
    let highlightedNuttonBackgroundColor = Color.Yellow.level_500
    let disabledbuttonBackgroundColor = Color.Gray.level_600
}

protocol Themeable {
    func refreshTheme(theme: Theme)
}
