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
    
    var listPicture : [PhotoView]! = [] {
        didSet{
            self.bindToView()
        }
    }
    var bindToView :  (() -> ()) = {}
    
    init(){
        getRecentImage()
    }
    
    func getRecentImage(){
        Repository.getPopularData { result in
            self.listPicture = result
        }
    }
}
