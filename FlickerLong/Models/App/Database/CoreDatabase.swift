//
//  CoreDatabase.swift
//  FlickerLong
//
//  Created by LAP15335 on 31/10/2022.
//

import Foundation
import UIKit
import CoreData

class CoreDatabase {
    static var context : NSManagedObjectContext!
    static var persistentStoreCoordinator : NSPersistentStoreCoordinator!
    
    static func getContext(){
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
    }
}
