//
//  SchedulerTableViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 3/30/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class SchedulerTableViewController: UITableViewController {

    let data = PlaceHolderData.data()
    
    let date: String!
    let temp: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var objectArray = [data]
        
        for (key, value) in data.dataDictionary {
            objectArray.append(PlaceHolderData.data(date: key, temp: value))
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        let dictionary = data.dataArray.index
        
        for (key, value) in data.dataArray[1] {
//            print("\(key), \(value)")
            cell.textLabel!.text = ("\(key), \(value)")
        }
        
        return cell
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}