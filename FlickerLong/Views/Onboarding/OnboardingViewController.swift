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
    
    lazy var loginViewController: LoginViewController = {
        let controller = LoginViewController()
        controller.delegate = self
        controller.viewDidLoad()
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting View
        onboardingView = OnboardingView(view: self.view)
        onboardingView.delegate = self
        onboardingView.initViewConstraint()
    }
}


extension OnboardingViewController : OnboardingViewDelegate{
    func getStartTapped() {
        OAuthAuthorization.authorize(baseViewController: self, webViewController: loginViewController) {
            let vc = HomeViewController()
            
            let navigation = UINavigationController(rootViewController: vc)
            navigation.modalPresentationStyle = .fullScreen
            
            self.present(navigation, animated: true)
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
    
    func oauthWebViewControllerDidDisappear() {
        OAuthAuthorization.oauthswift.cancel()
    }
    
    
}
