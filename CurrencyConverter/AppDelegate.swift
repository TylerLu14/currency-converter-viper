//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/5/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            //do nothing we will have a code in SceneceDelegate for this
        } else {
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.rootViewController = NavigationController(
//                rootViewController: ConverterRouter.createModule(exchangeService: CurrencyLayerService.shared, fileService: FileService.shared)
//            )
//            window?.makeKeyAndVisible()
        }
        
        ThemeManager.shared.onThemeUpdated(theme: ThemeManager.shared.currentTheme)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

