//
//  Remote.swift
//  FlickerLong
//
//  Created by LAP15335 on 14/10/2022.
//

import Foundation
import UIKit
import objectiveflickr
import Network
import CoreData

enum CRUDCoreData{
    case fetch
    case delete
    case save
}

class Repository : NSObject, OFFlickrAPIRequestDelegate {
    
    //MARK: CoreData
    static func coreDataManipulation<T: NSManagedObject>(operation: CRUDCoreData, _ type: T.Type, completion: ((_ data: Any) -> ())? = nil){
        let fetchRequest : NSFetchRequest = T.fetchRequest()
        switch operation{
        case .fetch:
            do {
                let result = try CoreDatabase.context.fetch(fetchRequest)
                completion!(result)
            } catch let e{
                print(e.localizedDescription)
            }
            
        case .delete:
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try CoreDatabase.persistentStoreCoordinator.execute(deleteRequest, with: CoreDatabase.context)
            } catch let e {
                print(e.localizedDescription)
            }
            
        case .save:
            do{
                try CoreDatabase.context.save()}
            catch let e {
                print(e.localizedDescription)
            }
        }
    }

    
    //MARK: GET
    // Call to get 100 Popular Images
    static func getPopularDataUnsplash(page: Int ,completion : @escaping ([PhotoSizeInfo]) -> ()){
        FlickerAPI<ImageElement>.getDataUnsplash(on: .recentUnsplash, with: RequestData(page: page), completion: {
            imageElement in
            var dataListPicture : [PhotoSizeInfo] = []
            
            for photo in imageElement{
                
                guard let url = photo.urls.regular else{
                    continue
                }
                let photoView = PhotoSizeInfo(url: URL(string: url)!, width: CGFloat(photo.width!), height: CGFloat(photo.height!))
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
    static func getPublicPhoto(completion: @escaping(([PhotoSizeInfo]) -> ())){
       
        FlickerAPI<PublicPhoto>.getDataFlicker(on: .publicPhoto, with: RequestData()) { publicPhoto in
            guard let photos = publicPhoto.photos?.photo else{
                return
            }
            
            var downloadedPicture : Int = 0
            var dataListPicture : [PhotoSizeInfo] = []
            
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
                    
                    let photoView = PhotoSizeInfo(url: urlImage)
                    
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
    static func getDetailAlbum(albumId: String, completion: @escaping (([PhotoSizeInfo]) -> ())){
        FlickerAPI<PhotosetData>.getDataFlicker(on: .albumPhotos, with: RequestData(albumId: albumId)) { photosetData in
            var dataListPicture : [PhotoSizeInfo] = []
            guard let photos = photosetData.photoset?.photo else{
                return
            }
            
            for photo in photos{
                guard let urlImage = URL( string:"https://live.staticflickr.com/\(String(describing: photo.server!))/\(String(describing: photo.id!))_\(String(describing: photo.secret!))_b.jpg") else{
                    return
                }
                let photoView = PhotoSizeInfo(url: urlImage, width: 0, height: 0)
                dataListPicture.append(photoView)
            }
            completion(dataListPicture)
        }
    }
    
    static func getPhotoId(ticketId: String, completion: @escaping ((String) -> ())){
        FlickerAPI<TicketChecker>.getDataFlicker(on: .checkTicketId, with: RequestData(ticketId: ticketId)) { ticketChecker in
            
        }
    }
    
    //MARK: POST
    var listRequest : [OFFlickrAPIRequest] = []
    var albumId : String!
    func uploadImage(listImage: [UIImage], title : String, description : String){
        for image in listImage{
            let request : OFFlickrAPIRequest = OFFlickrAPIRequest.init(apiContext: Constant.ObjCContext)
            request.delegate = self
            
            let inputStream : InputStream = InputStream.init(data: image.jpegData(compressionQuality: 0.1)!)
            request.uploadImageStream(inputStream, suggestedFilename: "foo.jpg", mimeType: "image/jpeg", arguments: [
                "is_public" : "1",
                "title" : title,
                "description" : description
            ])
            listRequest.append(request)
        }
    }
    
    func flickrAPIRequest(_ inRequest: OFFlickrAPIRequest!, didCompleteWithResponse inResponseDictionary: [AnyHashable : Any]!) {
        guard let photoId = inResponseDictionary["photoid"] else{
            return
        }
        
        let id : String = (photoId as! [String : String])["_text"]!
        let request : OFFlickrAPIRequest = OFFlickrAPIRequest.init(apiContext: Constant.ObjCContext)
        request.delegate = self
        
        request.callAPIMethod(withPOST: "flickr.photosets.addPhoto", arguments: ["api_key" : "e3e9d23e495da9bf5c0f1a0a63d5be66", "photoset_id" : albumId!, "photo_id" : "\(id)"])
        listRequest.append(request)
        
        
    }
    
    func flickrAPIRequest(_ inRequest: OFFlickrAPIRequest!, didFailWithError inError: Error!) {
        print(inError!)
    }
    
    func flickrAPIRequest(_ inRequest: OFFlickrAPIRequest!, imageUploadSentBytes inSentBytes: UInt, totalBytes inTotalBytes: UInt) {
    }
    
    public func uploadPhotosURLs1(lobjImageToUpload:UIImage)
    {
        let secret =  Constant.UserSession.userOAuthSecret
        //where secret is 7e5cfde9b0023627
        let api_key = ProcessInfo.processInfo.environment["API_KEY"]!
        let auth_token = Constant.UserSession.userOAuthToken
        
        let imageData = lobjImageToUpload.jpegData(compressionQuality: 1)
        
        let uploadSig = "\(secret)_key\(api_key)_token\(auth_token)"
        let request = NSMutableURLRequest()
        let url = "https://up.flickr.com/services/upload/"
        request.url = URL(string: url)!
        request.httpMethod = "POST"
        
        
        let boundary = String("---------------------------7d44e178b0434")
        request.addValue(" multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body:NSMutableData = NSMutableData()
        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"api_key\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(api_key)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"auth_token\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(auth_token)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"api_sig\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(uploadSig)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append(String("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n").data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
        
        body.append(imageData!)
        body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = Data(body.subdata(with: NSRange(location: 0, length: body.length)))
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest,
                                    completionHandler: {(data, response, error) in
            if let error = error {
                print(error)
            }
            if let data = data{
                print("data =\(data)")
            }
            if let response = response {
                print("url = \(response.url!)")
                print("response = \(response)")
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
                print("DATA = \(String(describing: data))")
                //if you response is json do the following
                do{
                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                    let arrayJSON = resultJSON as! NSArray
                    for value in arrayJSON{
                        let dicValue = value as! NSDictionary
                        for (key, value) in dicValue {
                            print("key = \(key)")
                            print("value = \(value)")
                        }
                    }
                    
                }catch _{
                    print("Received not-well-formatted JSON")
                }
            }
        })
        task.resume()
    }
    
}
