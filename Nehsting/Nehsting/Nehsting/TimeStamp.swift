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

    convenience init(time: NSDate, mode: UInt, temp: UInt, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("TimeStamp", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.time = time
            self.mode = mode
            self.temperature = temp
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}