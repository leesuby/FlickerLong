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
}
