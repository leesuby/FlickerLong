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
    var listPictures : [PhotoSizeInfo] = []
    var listCorePicture : [PhotoCore] = []
    let blockQueue = DispatchQueue(label: "blockQueue",attributes: .concurrent)
    init(widthHome: CGFloat) {
        self.widthHome = widthHome
    }
    
    func getData(page: Int, completion : @escaping (TypeData) -> (Void)){
        if(!NetworkStatus.shared.isConnected){
            fetchData(completion: completion)
        }
        else{
            Repository.getPopularDataUnsplash(page: page) { [self] result in
                blockQueue.async {
                    let listSizedImage : [PhotoSizeInfo] = Helper.calculateDynamicLayout(sliceArray: result[0..<result.count], width: self.widthHome)
                    
                    if(self.isInit){
                        let listPhotoCore = self.convertToCoreData(listPhoto: listSizedImage)
                        self.deleteData(numberOfImage: listPhotoCore.count)
                        self.saveData(numberOfImage: listPhotoCore.count)
                    }
                    
                    self.blockQueue.async(flags: .barrier) {
                        self.listPictures.append(contentsOf: listSizedImage)
                        completion(.online)
                    }
                }
                
            }
        }
    }
    
    func fetchData(completion : @escaping (TypeData) -> (Void)){
        Repository.coreDataManipulation(operation: .fetch, PhotoCore.self) { data in
            self.listCorePicture = data as! [PhotoCore]
            completion(.offline)
            
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
            photo.scaleWidth = picture.scaleWidth
            photo.scaleHeight = picture.scaleWidth
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
