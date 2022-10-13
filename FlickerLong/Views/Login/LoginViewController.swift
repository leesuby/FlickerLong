//
//  LoginViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 11/10/2022.
//

import Foundation
import UIKit
import WebKit
import OAuthSwift

class LoginViewController : OAuthWebViewController{
    
    var targetURL: URL?
    var loginView : LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Loading..."
        self.loginView = LoginView(view: view.self)
        self.loginView.initView()
        self.loginView.initConstraint()
        self.loginView.webView.navigationDelegate = self
        loadAddressURL()
    }
    
    override func handle(_ url: URL) {
        targetURL = url
        
        super.handle(url)
        self.loadAddressURL()
    }
    
    func loadAddressURL() {
        guard let url = targetURL else {
            return
        }
        
        let req = URLRequest(url: url)
        
        DispatchQueue.main.async {
            self.loginView.webView.load(req)
        }
    }
    
}


extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //Change title of Screen
        title = loginView.webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //Handle URL
        if let url = navigationAction.request.url , url.scheme == "oauth-swift" {
            AppDelegate.sharedInstance.applicationHandle(url: url)
            decisionHandler(.cancel)
            self.dismissWebViewController()
            return
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //Error when WebView fail
        print("\(error)")
        self.dismissWebViewController()
    }
    
}
