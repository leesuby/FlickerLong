//
//  PhotoView.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.
//

import Foundation
import UIKit

class PhotoView {
    var url : URL
    var width : CGFloat!
    var height: CGFloat!
    var scaleWidth: CGFloat!
    var scaleHeight: CGFloat!
    
    init(url : URL){
        self.url = url
        
        guard let sizeImage : CGSize = Helper.sizeOfImageAt(url: url) else{
            self.width = 0
            self.height = 0
            return
        }
        self.width = sizeImage.width
        self.height = sizeImage.height
    }

    init(url: URL, width : CGFloat, height: CGFloat){
        self.url = url
        self.width = width
        self.height = height
    }
}
