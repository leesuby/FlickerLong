//
//  FlickerAPI.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.
//

import Foundation

//MARK: Method for get data from Flickr

enum EndPoint: String{
    
    case recent
    case profile
    case recentUnsplash
    
    func getPath (request : RequestData) -> String{
        var apiKey : String = String(describing:ProcessInfo.processInfo.environment["API_KEY"]!)
        var apiKeyUnplash : String = String(describing:ProcessInfo.processInfo.environment["API_KEY_UNSPLASH"]!)
        switch self{
        case .recent:
            return "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(apiKey)&format=json&nojsoncallback=1"
        case .profile:
            return "https://www.flickr.com/services/rest/?method=flickr.people.getInfo&api_key=\(apiKey)&user_id=\(request.userId)&format=json&nojsoncallback=1"
        case .recentUnsplash:
            return "https://api.unsplash.com/photos/?client_id=\(apiKeyUnplash)&page=\(request.page)&per_page=20"
        }
    }
}



//MARK: Class to call API Flickr
class FlickerAPI<T : Codable>{
    static func getDataFlicker(on endPoint : EndPoint, with request: RequestData, completion :@escaping(T) -> ()){
        
        var baseURL : String = endPoint.getPath(request: request)
        
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
        print(baseURL)
        
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
