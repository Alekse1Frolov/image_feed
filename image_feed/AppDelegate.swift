//
//  AppDelegate.swift
//  image_feed
//
//  Created by Aleksei Frolov on 13.2.24..
//

import UIKit
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ProgressHUD.colorHUD = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        ProgressHUD.colorAnimation = UIColor(named: "YP_black_color") ?? .lightGray
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.mediaSize = 51
        ProgressHUD.marginSize = 13
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(
            name: "Main",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

