//
//  HomeViewModels.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.
//

import Foundation
import UIKit

class HomeViewModel : ViewModel{
    typealias Item = RecentData
    var model: RecentData?
    
    var listPicture : [PhotoSizeInfo]! = [] {
        didSet{
            self.bindToView()
        }
    }
    var bindToView :  (() -> ()) = {}

    func convertToUnsplashLayout(listPhoto: [PhotoSizeInfo],width: CGFloat, completion : @escaping ([PhotoSizeInfo]) -> ()){
        completion(Helper.calculateUnsplashLayout(sliceArray: listPhoto[0..<listPhoto.count], width: width))
    }
}
