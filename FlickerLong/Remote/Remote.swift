//
//  Remote.swift
//  FlickerLong
//
//  Created by LAP15335 on 14/10/2022.
//

import Foundation
import UIKit

class Remote{
    
    
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
                    let data = try? Data(contentsOf: URL( string:"https://live.staticflickr.com/\(String(describing: photo.server!))/\(String(describing: photo.id!))_\(String(describing: photo.secret!))_b.jpg")!)
                    
                    if(data != nil){
                        let photoView = PhotoView()
                        photoView.image = UIImage(data: data!)!
                        
                        photoView.width =  photoView.image.size.width * photoView.image.scale
                        photoView.height =  photoView.image.size.height * photoView.image.scale
                
                        dataListPicture.append(photoView)
                    }
                
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
