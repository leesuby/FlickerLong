//
//  ViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 11/10/2022.
//

import UIKit
import OAuthSwift

class OnboardingViewController: UIViewController {
    
    private var onboardingView : OnboardingView!
    
    //Getfor WebView
    lazy var loginViewController: LoginViewController = {
        let controller = LoginViewController()
        controller.delegate = self
        controller.viewDidLoad()
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set VIEW
        onboardingView = OnboardingView(view: self.view)
        onboardingView.delegate = self
        onboardingView.initView()
        onboardingView.initConstraint()
    }
}


extension OnboardingViewController : OnboardingViewDelegate{
    func getStartTapped() {
        OAuthAuthorization.authorize(baseViewController: self, webViewController: loginViewController) {
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
            self.present(tabBarVC, animated: true)
        }
    }
}

extension OnboardingViewController : OAuthWebViewControllerDelegate{
    func oauthWebViewControllerDidPresent() {
        
    }
    
    func oauthWebViewControllerDidDismiss() {
    
    }
    
    func oauthWebViewControllerWillAppear() {
    
    }
    
    func oauthWebViewControllerDidAppear() {
    
    }
    
    func oauthWebViewControllerWillDisappear() {
    
    }
    
    //Make sure OAuth stop when webview disappear
    func oauthWebViewControllerDidDisappear() {
        OAuthAuthorization.oauthswift.cancel()
    }
    
    
}
