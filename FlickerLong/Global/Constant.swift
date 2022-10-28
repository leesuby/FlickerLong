//
//  Constant.swift
//  FlickerLong
//
//  Created by LAP15335 on 11/10/2022.
//

import Foundation
import UIKit
import objectiveflickr

class Constant{
    static var ObjCContext : OFFlickrAPIContext = OFFlickrAPIContext.init(apiKey: ProcessInfo.processInfo.environment["API_KEY"] ?? "e3e9d23e495da9bf5c0f1a0a63d5be66" , sharedSecret: ProcessInfo.processInfo.environment["API_SECRET"] ?? "bc0b1e9d741c62d4")
    
    static func setContext(){
        ObjCContext.oAuthToken = Constant.UserSession.userOAuthToken
        ObjCContext.oAuthTokenSecret = Constant.UserSession.userOAuthSecret
    }
   
    class UserSession{
        enum Tab : Int {
            case home = 0
            case upload = 1
            case profile = 2
        }
        static var currentTab : Tab = .home
        static var userId : String = ""
        static var userOAuthToken : String = ""
        static var userOAuthSecret : String = ""
    }
    
    
    class DynamicLayout{
        static var heightDynamic: CGFloat = 200
        static var minimumWidth: CGFloat = 60
        static var spacing: CGFloat = 6
    }
    class Logo {
        static var imageName = "LogoNoBackground"
        static var logoRotate : CGFloat = .pi / 42
    }
    
    class BackgroundOnboarding {
        static var imageName = "BackgroundOnboarding"
    }
    
    class Description {
        static var font : UIFont = .NunitoSemiBold(size: 18)!
        static var color : UIColor = .white
        static var textAlightment : NSTextAlignment = NSTextAlignment.center
    }
    
    class Title{
        static var font : UIFont = .NunitoBold(size: 16)!
        static var color: UIColor = .darkText
        static var textAlightment : NSTextAlignment = NSTextAlignment.center
    }
    
    class SubTitle{
        static var font : UIFont = .NunitoRegular(size: 14)!
        static var color: UIColor = .darkText
        static var textAlightment : NSTextAlignment = NSTextAlignment.center
    }
    
    class TextBox{
        static var font : UIFont = .NunitoRegular(size: 14)!
        static var color: UIColor = .gray
    }
    
    static var padding : CGFloat = 15
}
