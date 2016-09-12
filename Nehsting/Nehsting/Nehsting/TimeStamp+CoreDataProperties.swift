//
//  TimeStamp+CoreDataProperties.swift
//  Nehsting
//
//  Created by Keith Kowalski on 9/11/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TimeStamp {

    @NSManaged var time: NSDate?
    @NSManaged var mode: NSNumber?
    @NSManaged var temperature: NSNumber?

}
