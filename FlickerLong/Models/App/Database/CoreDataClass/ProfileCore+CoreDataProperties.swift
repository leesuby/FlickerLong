//
//  ProfileCore+CoreDataProperties.swift
//  
//
//  Created by LAP15335 on 01/11/2022.
//
//

import Foundation
import CoreData


extension ProfileCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileCore> {
        return NSFetchRequest<ProfileCore>(entityName: "ProfileCore")
    }

    @NSManaged public var name: String?
    @NSManaged public var uploadedPhoto: Int64

}
