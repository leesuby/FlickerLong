//
//  FlickerAPI.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.
//

import Foundation

//MARK: Method for get data from Flickr
enum FlickerMethod{
    case getRecent
    case getInfo
}

//MARK: Class to call API Flickr
class FlickerAPI<T : Codable>{
    static func getDataFlicker(method : FlickerMethod, completion :@escaping(T) -> ()){
        
        var baseURL : String = "https://www.flickr.com/services/rest/?"
        
        switch method{
        case .getRecent:
            baseURL.append("method=flickr.photos.getRecent&api_key=\(String(describing:ProcessInfo.processInfo.environment["API_KEY"]!))&format=json&nojsoncallback=1")
            
        case .getInfo:
            break
        }
        
        URLSession.shared.dataTask(with: URL(string: baseURL)!) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(T.self, from: data)
                completion(empData)
            }
        }.resume()
        
    }
}
