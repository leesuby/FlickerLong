//
//  Remote.swift
//  FlickerLong
//
//  Created by LAP15335 on 14/10/2022.
//

import Foundation
import UIKit

class Repository{
    
    
    // Call to get 100 Popular Images
    static func getPopularData(completion : @escaping ([PhotoView]) -> ()){
        var downloadedPicture : Int = 0
        var dataListPicture : [PhotoView] = []
        
        FlickerAPI<RecentData>.getDataFlicker(method: .getRecent) { recentData in
            guard let photos = recentData.photos?.photo else{
                return
            }
            
            downloadedPicture = photos.count
            for photo in photos{
                
                DispatchQueue.global().async {
                    
                    guard let urlImage = URL( string:"https://live.staticflickr.com/\(String(describing: photo.server!))/\(String(describing: photo.id!))_\(String(describing: photo.secret!))_b.jpg") else{

                        downloadedPicture -= 1
                        print(downloadedPicture)
                        if(downloadedPicture == 0){
                            completion(dataListPicture)
                        }
                        return
                    }
                    
                    let photoView = PhotoView(url: urlImage)
                    
                    dataListPicture.append(photoView)
                    
                    downloadedPicture -= 1
                    print(downloadedPicture)
                    if(downloadedPicture == 0){
                        completion(dataListPicture)
                    }
                    
                }
                
            }
            
        }
    }
}
