//
//  PhotoCore+CoreDataClass.swift
//  
//
//  Created by LAP15335 on 01/11/2022.
//
//

import Foundation
import CoreData


public class PhotoCore: NSManagedObject {
    func setSize(url : String){
        self.url = url
        
        guard let urlImage : URL = URL(string: url) else{
            self.width = 0
            self.height = 0
            return
        }
        
        guard let sizeImage : CGSize = Helper.sizeOfImageAt(url: urlImage) else{
            self.width = 0
            self.height = 0
            return
        }
        self.width = sizeImage.width
        self.height = sizeImage.height
    }
}
