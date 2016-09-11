//
//  TimeStamp.swift
//  Nehsting
//
//  Created by Keith Kowalski on 9/10/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation
import CoreData


class TimeStamp: NSManagedObject {

    convenience init(time: NSDate, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("TimeStamp", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.time = time
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
