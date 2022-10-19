//
//  Helper.swift
//  FlickerLong
//
//  Created by LAP15335 on 14/10/2022.
//

import Foundation
import UIKit

class Helper{
    static func sizeOfImageAt(url: URL) -> CGSize? {
           // with CGImageSource we avoid loading the whole image into memory
           guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
               return nil
           }

           let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
           guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
               return nil
           }

           if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
               let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
               return CGSize(width: width, height: height)
           } else {
               return nil
           }
       }
    
    enum Edge{
        case top
        case bottom
        case left
        case right
    }
    
    static func getBorderOneCorner(size: CGSize,edge : Edge ) -> CALayer{
        let line = CALayer()
        switch edge{
        case .bottom:
            line.frame = CGRect(x: 0.0, y: size.height - 1, width: size.width, height: 1.0)
        case .top:
            line.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: 1.0)
        case .left:
            line.frame = CGRect(x: 0.0, y: size.height - 1, width: 1.0, height: size.height)
        case .right:
            line.frame = CGRect(x: size.width, y: size.height - 1, width: 1.0, height: size.height)
        }
        line.backgroundColor = UIColor.darkGray.cgColor
        line.borderColor = UIColor.darkGray.cgColor
        return line
    }
    
}
