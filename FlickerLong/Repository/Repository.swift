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
        FlickerAPI<RecentData>.getDataFlicker(on: .recentFlickr, with: RequestData()) { recentData in
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
    
    // Call to get 100 Popular Images
    static func getPopularDataUnsplash(page: Int ,completion : @escaping ([PhotoView]) -> ()){
        var dataListPicture : [PhotoView] = []
        
        FlickerAPI<ImageElement>.getDataUnsplash(on: .recentUnsplash, with: RequestData(page: page), completion: {
            imageElement in
           
            for photo in imageElement{
                
                guard let url = photo.urls.regular else{
                    continue
                }
                let photoView = PhotoView(url: URL(string: url)!, width: CGFloat(photo.width), height: CGFloat(photo.height))
                dataListPicture.append(photoView)
            }
            
            completion(dataListPicture)
        })
    }
    
    static func getProfileUser(completion: @escaping((ProfileModel) -> ())){
        
        FlickerAPI<Profile>.getDataFlicker(on: .profileFlickr, with: RequestData()) { result in
            
            let info = result.person
            var urlAvatar : String
            if(Int(info.iconserver!) == 0){
                urlAvatar = "https://www.flickr.com/images/buddyicon.gif"
            }else{
                urlAvatar = "http://farm\(info.iconfarm).staticflickr.com/\(info.iconserver!)/buddyicons/\(Constant.UserSession.userId).jpg"
            }
            print(urlAvatar)
            
            let profileModel = ProfileModel(avatarURL: urlAvatar, userName: info.username.content, photosUpload: info.photos.count.content)
            completion(profileModel)
        }
        
    }
    
}
