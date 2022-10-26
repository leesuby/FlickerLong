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
        var downloadedPicture : Int = 0
        var dataListPicture : [PhotoView] = []
        FlickerAPI<PublicPhoto>.getDataFlicker(on: .publicPhoto, with: RequestData()) { publicPhoto in
            guard let photos = publicPhoto.photos?.photo else{
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
    
    //get album
    static func getAlbum(completion: @escaping(([AlbumModel]) -> ())){
        var listAlbum : [AlbumModel] = []
        FlickerAPI<Album>.getDataFlicker(on: .albumList, with: RequestData()) { albums in
            print(albums)
            guard let galleries = albums.galleries else{
                return
            }
            for gallery in galleries.gallery{
                let id = gallery.gallery_id
                let coverURL = URL(string: (gallery.cover_photos!.photo?[0].url)!)!
                let title = gallery.title?.content
                let dateCreated = gallery.date_create!
                let numOfPhotos = gallery.count_photos
                let model = AlbumModel(id: id!, coverURL: coverURL, title: title!, dateCreated: dateCreated, numberOfPhotos: numOfPhotos!)
                listAlbum.append(model)
            }
            completion(listAlbum)
        }
    }
    
    //get detail album
    static func getDetailAlbum(albumId: String, completion: @escaping (([PhotoView]) -> ())){
        
        var dataListPicture : [PhotoView] = []
        FlickerAPI<PublicPhoto>.getDataFlicker(on: .albumPhotos, with: RequestData(albumId: albumId)) { publicPhoto in
            guard let photos = publicPhoto.photos?.photo else{
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
}
