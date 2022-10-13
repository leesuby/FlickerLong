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
    static var oauthswift = OAuth1Swift(
        consumerKey:     ProcessInfo.processInfo.environment["API_KEY"]!,
        consumerSecret:  ProcessInfo.processInfo.environment["API_SECRET"]!,
        requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
        authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
        accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
    )
    
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
