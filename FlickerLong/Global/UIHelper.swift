//
//  UIHelper.swift
//  FlickerLong
//
//  Created by LAP15335 on 11/10/2022.
//

import Foundation
import UIKit

extension UIFont {
    static func NunitoMedium(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-Medium", size: size)
    }
    
    static func NunitoExtraBoldItalic(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-ExtraBoldItalic", size: size)
    }
    
    static func NunitoExtraBold(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-ExtraBold", size: size)
    }
    
    static func NunitoExtraLightItalic(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-ExtraLightItalic", size: size)
    }
    
    static func NunitoLight(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-Light", size: size)
    }
    
    static func NunitoRegular(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-Regular", size: size)
    }
    
    static func NunitoSemiBold(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-SemiBold", size: size)
    }
    
    static func NunitoBold(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-Bold", size: size)
    }
    
    static func NunitoBoldItalic(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-BoldItalic", size: size)
    }
    
    static func NunitoBlack(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-Black", size: size)
    }
    
    static func NunitoExtraLight(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-ExtraLight", size: size)
    }
    
    static func NunitoSemiBoldItalic(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-SemiBoldItalic", size: size)
    }
    
    static func NunitoBlackItalic(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-BlackItalic", size: size)
    }
    
    static func NunitoItalic(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-Italic", size: size)
    }
    
    static func NunitoLightItalic(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-LightItalic", size: size)
    }
    
    static func NunitoMediumItalic(size: CGFloat) -> UIFont?{
        return UIFont(name: "Nunito-MediumItalic", size: size)
    }
}

extension UIColor{
    static func hexStringToUIColor (hex:String , alpha: Float) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    static var white80a = hexStringToUIColor(hex: "FFFFFF", alpha: 0.8)
    
}

extension UIButton{
    func textCenterImageRightAlignment(){
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth / 2)
    }
}
