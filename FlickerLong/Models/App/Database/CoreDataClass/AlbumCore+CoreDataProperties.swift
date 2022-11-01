//
//  AlbumCore+CoreDataProperties.swift
//  
//
//  Created by LAP15335 on 01/11/2022.
//
//

import Foundation
import CoreData


extension AlbumCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumCore> {
        return NSFetchRequest<AlbumCore>(entityName: "AlbumCore")
    }

    @NSManaged public var dateCreated: String?
    @NSManaged public var title: String?
    @NSManaged public var numberOfPhotos: Int64
    @NSManaged public var id: String?
    @NSManaged public var coverURL: String?

}
