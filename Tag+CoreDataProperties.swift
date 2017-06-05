//
//  Tag+CoreDataProperties.swift
//  Filterer
//
//  Created by Administrator on 05.06.17.
//  Copyright © 2017 Administrator. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData


/* Class that maps to the entity in CD */

extension Tag {

    @NSManaged var tagTitle: String?
    @NSManaged var images: NSSet?

}
