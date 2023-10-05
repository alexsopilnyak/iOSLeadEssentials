//
//  AppDelegate.swift
//  EssentialApp
//
//  Created by Oleksandr Sopilniak on 04.10.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let config = UISceneConfiguration(name: "Default Config", sessionRole: connectingSceneSession.role)
        
        #if DEBUG
        config.delegateClass = DebuggingSceneDelegate.self
        #endif
        
        return config
    }
}

