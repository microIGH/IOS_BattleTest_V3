//
//  SceneDelegate.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 20/08/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        NetworkMonitor.shared.startMonitoring()
        
        checkFirstTimeAndSetRootViewController()
        
        window?.makeKeyAndVisible()
    }

    private func checkFirstTimeAndSetRootViewController() {
        if UserProgressManager.shared.isFirstTime() {
            let registrationVC = RegistrationViewController()
            window?.rootViewController = registrationVC
        } else {
            let tabBarVC = MainTabBarController()
            window?.rootViewController = tabBarVC
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
