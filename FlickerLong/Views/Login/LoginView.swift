//
//  LoginView.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import Foundation
import UIKit
import WebKit

class LoginView {
    private var view : UIView
    
    init(view: UIView) {
        self.view = view
    }
    
    var webView : WKWebView!
    
    func initView(){
        webView = WKWebView()
    }
    
    func initConstraint(){
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
