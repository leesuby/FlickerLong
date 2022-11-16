//
//  HomeLoader.swift
//  FlickerLong
//
//  Created by LAP15335 on 10/11/2022.
//

import Foundation

enum TypeData{
    case offline
    case online
}
class HomeLoader{
    private let NUMBER_IMAGES_PER_PAGE = 20
    private var isInit : Bool = true
    private var widthHome: CGFloat
    init(widthHome: CGFloat) {
        self.widthHome = widthHome
    }
    
    func getData(listData: [PhotoSizeInfo],page: Int, completion : @escaping ([AnyObject], TypeData) -> (Void)){
        if(!NetworkStatus.shared.isConnected){
            fetchData(completion: completion)
        }
        else{
            Repository.getPopularDataUnsplash(page: page) { [self] result in
                let listSizedImage : [PhotoSizeInfo] = Helper.calculateDynamicLayout(sliceArray: result[0..<result.count], width: self.widthHome)
                if(self.isInit){
                    _ = self.convertToCoreData(listPhoto: listSizedImage)
                    deleteData(numberOfImage: listSizedImage.count)
                    saveData(numberOfImage: listSizedImage.count)
                }
                var finalList = listData
                finalList.append(contentsOf: listSizedImage)
                completion(finalList, .online)
                
            }
        }
    }
    
    func fetchData(completion : @escaping ([PhotoCore], TypeData) -> (Void)){
        Repository.coreDataManipulation(operation: .fetch, PhotoCore.self) { data in
            completion(data as! [PhotoCore], .offline)
        }
    }
    
    func deleteData(numberOfImage: Int){
        if(numberOfImage <= NUMBER_IMAGES_PER_PAGE){
            Repository.coreDataManipulation(operation: .delete, PhotoCore.self)
        }
       
    }
    
    func saveData(numberOfImage: Int){
        if(numberOfImage <= NUMBER_IMAGES_PER_PAGE){
            Repository.coreDataManipulation(operation: .save, PhotoCore.self)
        }
    }
    
    func convertToCoreData(listPhoto : [PhotoSizeInfo]) -> [PhotoCore]{
        var tmpArray : [PhotoCore] = []
        for picture in listPhoto{
            let photo = PhotoCore(context: CoreDatabase.context)
            
            photo.url = picture.url.string
            photo.scaleWidth = picture.scaleWidth ?? 0
            photo.scaleHeight = picture.scaleWidth ?? 0
            photo.field = "Popular"
            
            if(listPhoto.count <= NUMBER_IMAGES_PER_PAGE){
                do {
                    photo.data = try Data(contentsOf: picture.url)}
                catch{
                    photo.data = Data()
                }}
            
            tmpArray.append(photo)
            
        }
        isInit = false
        return tmpArray
    }
}
