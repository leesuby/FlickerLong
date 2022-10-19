//
//  Constant.swift
//  FlickerLong
//
//  Created by LAP15335 on 11/10/2022.
//

import Foundation
import UIKit

class Constant{
    
    class UserStatus{
        enum Tab : Int {
            case home = 0
            case upload = 1
            case profile = 2
        }
        static var currentTab : Tab = .home
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
