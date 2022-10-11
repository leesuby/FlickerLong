//
//  Constant.swift
//  FlickerLong
//
//  Created by LAP15335 on 11/10/2022.
//

import Foundation
import UIKit

class Constant{
    
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
}
