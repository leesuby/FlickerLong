//
//  AlbumView.swift
//  FlickerLong
//
//  Created by LAP15335 on 26/10/2022.
//

import Foundation

class AlbumModel{
    var id : String!
    var coverURL : URL!
    var title : String!
    var dateCreated : String!
    var numberOfPhotos : Int!
    
    init(id : String, coverURL: URL, title: String, dateCreated: String, numberOfPhotos: Int) {
        self.id = id
        self.coverURL = coverURL
        self.title = title
        self.dateCreated = dateCreated
        self.numberOfPhotos = numberOfPhotos
    }
    
    init(id : String, title: String, dateCreated: String, numberOfPhotos: Int) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.numberOfPhotos = numberOfPhotos
    }
    
    init(){
        
    }
    
}
