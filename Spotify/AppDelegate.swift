//
//  AppDelegate.swift
//  Spotify
//
//  Created by Zardasht on 11/23/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .spotifyBlack
        window?.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: TitleViewController())
        window?.rootViewController = navigationController
    
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .spotifyBlack
        return true
    }
}

