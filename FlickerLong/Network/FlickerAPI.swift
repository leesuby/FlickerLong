//
//  FlickerAPI.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.
//

import Foundation

//MARK: Method for get data from Flickr

enum EndPoint: String{
    
    case recentFlickr
    case profileFlickr
    case recentUnsplash
    case publicPhoto
    case albumList
    case albumPhotos
    case galleryList
    case galleryPhotos
    case checkTicketId

    
    func getPath (request : RequestData) -> String{
        let apiKey : String =  "e3e9d23e495da9bf5c0f1a0a63d5be66"
        let apiKeyUnplash : String = "o_sOLV3yJuJNBFJ9cUIr3ZrBGMzkYmdKwyrO_qVknBg"
        switch self{
        case .recentFlickr:
            return "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(apiKey)&format=json&nojsoncallback=1"
        case .profileFlickr:
            return "https://www.flickr.com/services/rest/?method=flickr.people.getInfo&api_key=\(apiKey)&user_id=\(Constant.UserSession.userId)&format=json&nojsoncallback=1"
        case .recentUnsplash:
            return "https://api.unsplash.com/photos/?client_id=\(apiKeyUnplash)&page=\(request.page)&per_page=20"
        case .publicPhoto:
            return "https://www.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=\(apiKey)&user_id=\(Constant.UserSession.userId)&format=json&nojsoncallback=1"
        case .galleryList:
            return "https://www.flickr.com/services/rest/?method=flickr.galleries.getList&api_key=\(apiKey)&user_id=\(Constant.UserSession.userId)&cover_photos=1&format=json&nojsoncallback=1"
        case .galleryPhotos:
            return "https://www.flickr.com/services/rest/?method=flickr.galleries.getPhotos&api_key=\(apiKey)&gallery_id=\(request.albumId)&format=json&nojsoncallback=1"
        case .albumList:
            return "https://www.flickr.com/services/rest/?method=flickr.photosets.getList&api_key=\(apiKey)&user_id=\(Constant.UserSession.userId)&format=json&nojsoncallback=1"
        case .albumPhotos:
            return "https://www.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=\(apiKey)&photoset_id=\(request.albumId)&user_id=\(Constant.UserSession.userId)&format=json&nojsoncallback=1"
        case .checkTicketId:
            return "https://www.flickr.com/services/rest/?method=flickr.photos.upload.checkTickets&api_key=\(apiKey)&tickets=\(request.ticketId)&format=json&nojsoncallback=1"
        }
    }
}



//MARK: Class to call API Flickr
class FlickerAPI<T : Codable>{
    static func getDataFlicker(on endPoint : EndPoint, with request: RequestData, completion :@escaping(T) -> ()){
        
        let baseURL : String = endPoint.getPath(request: request)
        
        URLSession.shared.dataTask(with: URL(string: baseURL)!) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do{
                    let empData = try jsonDecoder.decode(T.self, from: data)
                    completion(empData)
                }catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }.resume()
        
    }
    
    static func getDataUnsplash(on endPoint : EndPoint, with request: RequestData, completion :@escaping([T]) -> ()){
        
        let baseURL : String = endPoint.getPath(request: request)
        
        URLSession.shared.dataTask(with: URL(string: baseURL)!) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do{
                    let empData = try jsonDecoder.decode([T].self, from: data)
                    completion(empData)
                }catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }.resume()
        
    }
    
    
}
