//
//  UIHelper.swift
//  FlickerLong
//
//  Created by LAP15335 on 11/10/2022.
//

import Foundation
import UIKit


//MARK: Font
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


//MARK: Color
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

//MARK: Button
extension UIButton{
    func textCenterImageRightAlignment(){
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth / 2)
    }
}

//MARK: Image
extension UIImage{
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


//MARK: TextField
extension UITextField{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 50 characters
        return updatedText.count <= 50
    }
}

//MARK: TextView
extension UITextView{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 50 characters
        return updatedText.count <= 50
    }
}



extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

enum HolderType{
    case tab
    case navigation
}

class Holder{
    static func create(type : HolderType) -> Any{
        switch type{
        case .tab:
            let tabBarVC = UITabBarController()
            //ViewController
            if #available(iOS 13.0, *) {
                let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                tabBarAppearance.backgroundColor = UIColor.white
                UITabBar.appearance().standardAppearance = tabBarAppearance

                if #available(iOS 15.0, *) {
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                }
            }
            
            let homeVC = HomeViewController()
            let uploadVC = UploadViewController()
            let profileVC = ProfileViewController()
            
            homeVC.title = "Home"
            uploadVC.title = "Upload"
            profileVC.title = "Profile"
            
            //Navigation Controller
            let navHome = UINavigationController(rootViewController: homeVC)
            let navUpload = UINavigationController(rootViewController: uploadVC)
            let navProfile = UINavigationController(rootViewController: profileVC)
            
            tabBarVC.setViewControllers([navHome, navUpload, navProfile], animated: true)
            
            guard let items = tabBarVC.tabBar.items else{
                return UITabBarController()
            }
            
            let imagesTabBar = ["HomeSymbol","UploadSymbol","ProfileSymbol"]
            
            for i in 0..<items.count {
                items[i].image = UIImage(named: imagesTabBar[i])
            }
            
            tabBarVC.modalPresentationStyle = .fullScreen
            tabBarVC.tabBar.backgroundColor = .white80a
            
            return tabBarVC
            
        case .navigation:
            let vc = OnboardingViewController()
            
            let loginNavigation = UINavigationController(rootViewController:  vc)
            loginNavigation.modalPresentationStyle = .fullScreen
            return loginNavigation
            
        }
        

    }
}
