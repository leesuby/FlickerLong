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
            consumerKey:     ProcessInfo.processInfo.environment["API_KEY"] ?? "e3e9d23e495da9bf5c0f1a0a63d5be66" ,
            consumerSecret:  ProcessInfo.processInfo.environment["API_SECRET"] ?? "bc0b1e9d741c62d4",
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
                case .success(let (credential, response, parameters)):
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
                    print(parameters["user_nsid"]!)
                    completion()
        
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    
    }
}
