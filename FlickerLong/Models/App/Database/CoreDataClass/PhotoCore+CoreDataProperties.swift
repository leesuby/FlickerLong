//
//  PhotoCore+CoreDataProperties.swift
//  
//
//  Created by LAP15335 on 01/11/2022.
//
//

import Foundation
import CoreData


extension PhotoCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoCore> {
        return NSFetchRequest<PhotoCore>(entityName: "PhotoCore")
    }

    @NSManaged public var data: Data?
    @NSManaged public var field: String?
    @NSManaged public var height: Double
    @NSManaged public var width: Double
    @NSManaged public var url: String?
    @NSManaged public var scaleWidth: Double
    @NSManaged public var scaleHeight: Double

}
