//
//  SceneDelegate.swift
//  AbKey
//
//  Created by Divyanah on 10/01/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // This method is called when the app is launched
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Check if the app was launched via a URL scheme
        if let urlContext = connectionOptions.urlContexts.first {
            handleIncomingURL(urlContext.url)
        }

        // Ensure the window is properly set up
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    // This method is called when the app is already running in the background and opened via a URL scheme
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            handleIncomingURL(url)
        }
    }

    // Helper method to handle the URL and open the appropriate view controller
    private func handleIncomingURL(_ url: URL) {
        let host = url.host ?? ""
        
        // Pop to root view controller if necessary
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: false)
            
            // Get the premium value from UserDefaults
            let premium = UserDefaults(suiteName: Constants.AppGroupSuiteName)?.integer(forKey: Constants.PremiumUserKey) ?? 0
            let storyboard = UIStoryboard(name: Constants.MainAppStoryboardIdentifier, bundle: nil)
            
            // Handle the URL and navigate to the appropriate view controller
            if host == Constants.FirstKeyboardHost || host == Constants.ThirdKeyboardHost {
                if let vc = storyboard.instantiateViewController(withIdentifier: Constants.SettingVCIdentifier) as? SettingViewController {
                    vc.premiumValueFromRTPlusManager = premium
                    navigationController.pushViewController(vc, animated: true)
                }
            } else if host == Constants.SecondKeyboardHost {
                if let vc = storyboard.instantiateViewController(withIdentifier: Constants.AbKeySettingVCIdentifier) as? AbKeySettingVC {
                    vc.premiumValueFromHomePageVC = premium
                    navigationController.pushViewController(vc, animated: true)
                }
            }
        }
    }

    // Other scene life cycle methods
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene moves from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }
}
