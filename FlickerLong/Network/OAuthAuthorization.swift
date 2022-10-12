//
//  OAuthAuthorization.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import Foundation
import OAuthSwift


class OAuthAuthorization {
    static var oauthswift = OAuth1Swift(
        consumerKey:    "e3e9d23e495da9bf5c0f1a0a63d5be66",
        consumerSecret: "bc0b1e9d741c62d4",
        requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
        authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
        accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
    )
    
    // authorize
    static func authorize(baseViewController : UIViewController, webViewController : OAuthWebViewController, completion: @escaping () -> ()){
        
        if(webViewController.parent == nil){
            baseViewController.addChild(webViewController)
        }
        
        oauthswift.authorizeURLHandler = webViewController
        oauthswift.authorize(
            withCallbackURL: "oauth-swift://oauth-callback/flickr") { result in
                switch result {
                case .success(let (credential, _, parameters)):
                    print(credential.oauthToken)
                    print(credential.oauthTokenSecret)
                    print(parameters["user_nsid"]!)
                    completion()
                    // Do your request
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    
    }
}
