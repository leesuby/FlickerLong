//
//  OAuthAuthorization.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import Foundation
import OAuthSwift


//MARK: OAuth framework using for Flickr
class OAuthAuthorization {
    static var oauthSwift : OAuth1Swift!
    
    static func authorize(baseViewController : UIViewController, webViewController : OAuthWebViewController, completion: @escaping () -> ()){
        let oauthswift = OAuth1Swift(
            consumerKey:     ProcessInfo.processInfo.environment["API_KEY"]!,
            consumerSecret:  ProcessInfo.processInfo.environment["API_SECRET"]!,
            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
        )
        oauthSwift = oauthswift
        
        if(webViewController.parent == nil){
            baseViewController.addChild(webViewController)
        }
        
        oauthswift.authorizeURLHandler = webViewController
        oauthswift.authorize(
            withCallbackURL: "oauth-swift://oauth-callback/flickr") { result in
                switch result {
                case .success(let (credential, _, parameters)):
                    guard let userID = parameters["user_nsid"] as? String else{
                        return
                    }
                    UserDefaults.standard.set(userID, forKey: "userID")
                    UserDefaults.standard.set(credential.oauthToken, forKey: "userOAuthToken")
                    UserDefaults.standard.set(credential.oauthTokenSecret, forKey: "userOAuthSecret")
                    Constant.UserSession.userId = userID
                    Constant.UserSession.userOAuthToken = credential.oauthToken
                    Constant.UserSession.userOAuthSecret = credential.oauthTokenSecret
                    Constant.setContext()
                    print(credential.oauthToken)
                    print(credential.oauthTokenSecret)
                    print(parameters["user_nsid"]!)
                    completion()
        
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    
    }
}
