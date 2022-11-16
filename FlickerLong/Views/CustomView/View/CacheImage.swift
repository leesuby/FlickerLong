//
//  CacheImage.swift
//  FlickerLong
//
//  Created by LAP15335 on 15/10/2022.
//

import Foundation
import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()

class CacheImage: UIImageView {

    var imageURL: URL?

    let activityIndicator = UIActivityIndicatorView()
    
    func loadImageWithUrl(_ url: URL) {
        self.layoutIfNeeded()
        isSkeletonLoading = true
    
        imageURL = url

        image = nil
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {

            self.image = imageFromCache
            isSkeletonLoading = false
            return
        }
        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.isSkeletonLoading = false
                })
                return
            }

            DispatchQueue.main.async(execute: {

                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    self.isSkeletonLoading = false
                }
                
            })
        }).resume()
    }

}

