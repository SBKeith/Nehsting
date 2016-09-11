//
//  MainViewController+CoreDataLoading.swift
//  Nehsting
//
//  Created by Keith Kowalski on 9/10/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation
import CoreData

extension MainViewController {
        
    func saveTimeStampData() {
        if let entity = NSEntityDescription.entityForName("TimeStamp", inManagedObjectContext: context) {
            let newTime = TimeStamp(entity: entity, insertIntoManagedObjectContext: context)
            newTime.time = sharedDataManager.timeStamp
        }
        
        do {
            try delegate.stack.saveContext()
        } catch {
            print("Error saving time stamp data")
        }
    }
    
    func dataFetchRequest() -> [TimeStamp] {
        
        print("Fetching Data...")
        
        // Get saved data...
        do {
            return try context.executeFetchRequest(fetchRequestTime) as! [TimeStamp]
        } catch {
            print("There was an error fetching the data")
            return [TimeStamp]()
        }
    }
    
    func checkIfTimeExists(time: NSDate) -> Bool {
        
        let checkTimeArray = dataFetchRequest()
        
        if checkTimeArray.count == 0 {
            return false
        } else {
            for stamp in checkTimeArray {
                if stamp.time! == time {
                    return true
                }
            }
        }
        return false
    }
}