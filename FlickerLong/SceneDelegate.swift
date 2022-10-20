//
//  SceneDelegate.swift
//  FlickerLong
//
//  Created by LAP15335 on 11/10/2022.
//

import UIKit
import OAuthSwift

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        checkUser(windowScene: windowScene)
        
    }
    
    
    func checkUser(windowScene : UIWindowScene){
        if(UserDefaults.standard.value(forKey: "userID")) != nil{
            Constant.UserSession.userId = UserDefaults.standard.value(forKey: "userID") as! String
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let tabBarVC = UITabBarController()
            //ViewController
            let homeVC = HomeViewController()
            let uploadVC = UploadViewController()
            let profileVC = ProfileViewController()
            
            homeVC.title = "Home"
            uploadVC.title = "Upload"
            profileVC.title = "Profile"
            
            //Navigation Controller
            let navUpload = UINavigationController(rootViewController: uploadVC)
            
            tabBarVC.setViewControllers([homeVC, navUpload, profileVC], animated: true)
            
            guard let items = tabBarVC.tabBar.items else{
                return
            }
            
            let imagesTabBar = ["HomeSymbol","UploadSymbol","ProfileSymbol"]
            
            for i in 0..<items.count {
                items[i].image = UIImage(named: imagesTabBar[i])
            }
            
            tabBarVC.modalPresentationStyle = .fullScreen
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = tabBarVC
            window.makeKeyAndVisible()
            self.window = window
            
        }else{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let vc = OnboardingViewController()
            
            let loginNavigation = UINavigationController(rootViewController:  vc)
            loginNavigation.modalPresentationStyle = .fullScreen
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = loginNavigation
            window.makeKeyAndVisible()
            self.window = window
        }
    }
    //HANDLE URL
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        if url.host == "oauth-callback" {
            OAuthSwift.handle(url: url)
        }
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

