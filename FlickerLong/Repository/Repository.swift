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
        
        FlickerAPI<RecentData>.getDataFlicker(on: .recentFlickr, with: RequestData()) { recentData in
            guard let photos = recentData.photos?.photo else{
                
                return
            }
            
            var downloadedPicture : Int = 0
            var dataListPicture : [PhotoView] = []
            
            downloadedPicture = photos.count
            for photo in photos{
                
                DispatchQueue.global().async {
                    
                    guard let urlImage = URL( string:"https://live.staticflickr.com/\(String(describing: photo.server!))/\(String(describing: photo.id!))_\(String(describing: photo.secret!))_b.jpg") else{
                        
                        downloadedPicture -= 1
              
                        if(downloadedPicture == 0){
                            completion(dataListPicture)
                        }
                        return
                    }
                    
                    let photoView = PhotoView(url: urlImage)
                    
                    dataListPicture.append(photoView)
                    
                    downloadedPicture -= 1
              
                    if(downloadedPicture == 0){
                        completion(dataListPicture)
                    }
                }
            }
        }
    }
    
    // Call to get 100 Popular Images
    static func getPopularDataUnsplash(page: Int ,completion : @escaping ([PhotoView]) -> ()){
        FlickerAPI<ImageElement>.getDataUnsplash(on: .recentUnsplash, with: RequestData(page: page), completion: {
            imageElement in
            var dataListPicture : [PhotoView] = []
            
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
    
    // Get profile data
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
    
    // Get public photo
    static func getPublicPhoto(completion: @escaping(([PhotoView]) -> ())){
       
        FlickerAPI<PublicPhoto>.getDataFlicker(on: .publicPhoto, with: RequestData()) { publicPhoto in
            guard let photos = publicPhoto.photos?.photo else{
                return
            }
            
            var downloadedPicture : Int = 0
            var dataListPicture : [PhotoView] = []
            
            downloadedPicture = photos.count
            for photo in photos{
                
                DispatchQueue.global().async {
                    
                    guard let urlImage = URL( string:"https://live.staticflickr.com/\(String(describing: photo.server!))/\(String(describing: photo.id!))_\(String(describing: photo.secret!))_b.jpg") else{
                        
                        downloadedPicture -= 1
                        
                        if(downloadedPicture == 0){
                            completion(dataListPicture)
                        }
                        return
                    }
                    
                    let photoView = PhotoView(url: urlImage)
                    
                    dataListPicture.append(photoView)
                    
                    downloadedPicture -= 1
                   
                    if(downloadedPicture == 0){
                        completion(dataListPicture)
                    }
                }
            }
        }
    }
    
    //get album
    static func getAlbum(completion: @escaping(([AlbumModel]) -> ())){
        var listAlbum : [AlbumModel] = []
        FlickerAPI<Album>.getDataFlicker(on: .albumList, with: RequestData()) { albums in
        
            guard let photosets = albums.photosets else{
                return
            }
            for photoset in photosets.photoset!{
                let id = photoset.id
                let title = photoset.title?.content
                let dateCreated = photoset.date_create
                let numOfPhotos = photoset.count_photos
                let model = AlbumModel(id: id!, title: title!, dateCreated: dateCreated!, numberOfPhotos: Int(exactly: numOfPhotos!)!)
                listAlbum.append(model)
            
            }
            completion(listAlbum)
        }
    }
    
    //get detail album
    static func getDetailAlbum(albumId: String, completion: @escaping (([PhotoView]) -> ())){
        FlickerAPI<PhotosetData>.getDataFlicker(on: .albumPhotos, with: RequestData(albumId: albumId)) { photosetData in
            var dataListPicture : [PhotoView] = []
            guard let photos = photosetData.photoset?.photo else{
                return
            }
            
            for photo in photos{
                guard let urlImage = URL( string:"https://live.staticflickr.com/\(String(describing: photo.server!))/\(String(describing: photo.id!))_\(String(describing: photo.secret!))_b.jpg") else{
                    return
                }
                let photoView = PhotoView(url: urlImage, width: 0, height: 0)
                dataListPicture.append(photoView)
            }
            completion(dataListPicture)
        }
    }
    
    static func getPhotoId(ticketId: String, completion: @escaping ((String) -> ())){
        FlickerAPI<TicketChecker>.getDataFlicker(on: .checkTicketId, with: RequestData(ticketId: ticketId)) { ticketChecker in
            
//            completion((ticketChecker.uploader?.ticket![0].photoid)!)
        }
    }
}
