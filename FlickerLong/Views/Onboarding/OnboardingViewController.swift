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
    
    //Get for WebView
    lazy var loginViewController: LoginViewController = {
        let controller = LoginViewController()
        controller.delegate = self
        controller.viewDidLoad()
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.backgroundColor = .white
        
        //Set VIEW
        onboardingView = OnboardingView(view: self.view)
        onboardingView.delegate = self
        onboardingView.initView()
        onboardingView.initConstraint()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
}


extension OnboardingViewController : OnboardingViewDelegate{
    func getStartTapped() {
        navigationController?.isNavigationBarHidden = false
        OAuthAuthorization.authorize(baseViewController: self, webViewController: loginViewController) {
            self.present(Holder.create(type: .tab) as! UITabBarController, animated: true)
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
        OAuthAuthorization.oauthSwift.cancel()
    }
    
    
}
