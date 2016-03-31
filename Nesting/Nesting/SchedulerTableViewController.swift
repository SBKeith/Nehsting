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
    var datesArray = [String]()
    var temperatureArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (key, value) in data.dataDictionary {
            datesArray.append(key)
            temperatureArray.append(value)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.dataDictionary.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        cell.textLabel?.text = datesArray[indexPath.row]
        cell.detailTextLabel?.text = "\(temperatureArray[indexPath.row])"
        
        return cell
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}