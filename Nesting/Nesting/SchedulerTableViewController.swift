//
//  SchedulerTableViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 3/30/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

struct data {
    
    let dataArray = [["date":"September 4, 2016", "temp": 75],
                          ["date":"October 8, 2016",  "temp": 70],
                          ["date":"November 7, 2016", "temp": 73]
    ]
}

class SchedulerTableViewController: UITableViewController {

    let sampleData = data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sampleData.dataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
    
        let data = sampleData.dataArray[indexPath.row]
        
        cell.textLabel?.text = data["date"] as? String
        cell.detailTextLabel?.text = "\(data["temp"]!)"
        
        return cell
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}