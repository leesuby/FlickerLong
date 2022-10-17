//
//  FlickerAPI.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.
//

import Foundation

//MARK: Method for get data from Flickr
enum FlickerEndPoint: String{
    case recent
    case info
    
    func getPath () -> String{
        switch self{
        case .recent:
            return "method=flickr.photos.getRecent&api_key=\(String(describing:ProcessInfo.processInfo.environment["API_KEY"]!))&format=json&nojsoncallback=1"
        case .info:
            return ""
        }
    }
}



//MARK: Class to call API Flickr
class FlickerAPI<T : Codable>{
    static func getDataFlicker(on endPoint : FlickerEndPoint, completion :@escaping(T) -> ()){
        
        var baseURL : String = "https://www.flickr.com/services/rest/?"
        
        baseURL.append(endPoint.getPath())
        
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
}
