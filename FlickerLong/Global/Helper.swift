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
    
    //Function to calculate size for each cell in Dynamic Layout
    static func calculateDynamicLayout(sliceArray : ArraySlice<PhotoSizeInfo>, width: CGFloat) -> [PhotoSizeInfo]{
        
        var data: [PhotoSizeInfo] = Array(sliceArray)
        
        var result: [PhotoSizeInfo] = []
        var tmpArray : [PhotoSizeInfo] = []
        
        let widthView : CGFloat = width
        var i : Int = 0
        while(i < data.count){
            let photo = data[i]
            var ratio : CGFloat = 0
            var totalWidth : CGFloat = 0
            var totalWidthPrev : CGFloat = 0
            
            var j : Int = 0
            while(j < tmpArray.count){
                let tmpPhoto = tmpArray[j]
                ratio += CGFloat(tmpPhoto.width/tmpPhoto.height)
                
                let trueScaleWidth = Constant.DynamicLayout.heightDynamic * tmpPhoto.width / tmpPhoto.height
                if(j + 1 == tmpArray.count){
                    
                    tmpPhoto.scaleWidth = widthView - totalWidth
                    if(tmpPhoto.scaleWidth <= Constant.DynamicLayout.minimumWidth || (tmpPhoto.scaleWidth < (0.8 * trueScaleWidth) && trueScaleWidth < widthView)){
                        tmpArray.removeLast()
                        tmpArray[tmpArray.count - 1].scaleWidth = widthView - totalWidthPrev
                    }
                }
                else{
                    tmpPhoto.scaleWidth = trueScaleWidth
                    totalWidthPrev = totalWidth
                    if(tmpPhoto.scaleWidth <= Constant.DynamicLayout.minimumWidth){
                        tmpPhoto.scaleWidth = Constant.DynamicLayout.minimumWidth
                        totalWidth = Constant.DynamicLayout.minimumWidth + totalWidth
                    }
                    else{
                        totalWidth = tmpPhoto.scaleWidth + totalWidth}
                }
                tmpPhoto.scaleHeight = Constant.DynamicLayout.heightDynamic
                j+=1
                
            }
            
            let totalHeight : CGFloat = widthView / (ratio == 0 ? 1 : ratio);
            
            if(totalHeight <= CGFloat(Constant.DynamicLayout.heightDynamic)){
                data.removeFirst(tmpArray.count)
                result.append(contentsOf: tmpArray)
                tmpArray = []
                i = 0
                
            }
            else{
                tmpArray.append(photo)
                i+=1
            }
        }
        
        return result
    }
    
    static func getDateStringFromUTC(time: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_NZ")
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
}


public extension CGFloat {
    /// Returns the value, scaled-and-shifted to the targetRange.
    /// If no target range is provided, we assume the unit range (0, 1)
    static func scaleAndShift(
        value: CGFloat,
        inRange: (min: CGFloat, max: CGFloat),
        toRange: (min: CGFloat, max: CGFloat) = (min: 0.0, max: 1.0)
        ) -> CGFloat {
        assert(inRange.max > inRange.min)
        assert(toRange.max > toRange.min)

        if value < inRange.min {
            return toRange.min
        } else if value > inRange.max {
            return toRange.max
        } else {
            let ratio = (value - inRange.min) / (inRange.max - inRange.min)
            return toRange.min + ratio * (toRange.max - toRange.min)
        }
    }
}


public extension CGRect {
    /// Kinda like AVFoundation.AVMakeRect, but handles tall-skinny aspect ratios differently.
    /// Returns a rectangle of the same aspect ratio, but scaleAspectFit inside the other rectangle.
    static func makeRect(aspectRatio: CGSize, insideRect rect: CGRect) -> CGRect {
        let viewRatio = rect.width / rect.height
        let imageRatio = aspectRatio.width / aspectRatio.height
        let touchesHorizontalSides = (imageRatio > viewRatio)

        let result: CGRect
        if touchesHorizontalSides {
            let height = rect.width / imageRatio
            let yPoint = rect.minY + (rect.height - height) / 2
            result = CGRect(x: 0, y: yPoint, width: rect.width, height: height)
        } else {
            let width = rect.height * imageRatio
            let xPoint = rect.minX + (rect.width - width) / 2
            result = CGRect(x: xPoint, y: 0, width: width, height: rect.height)
        }
        return result
    }
}
