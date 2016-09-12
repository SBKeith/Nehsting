//
//  HistoryTableViewController.swift
//  Nehsting
//
//  Created by Keith Kowalski on 9/9/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import NestSDK
import CoreData

class HistoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let getTimes = MainViewController()
    let sharedNetworkManager = NetworkingDataSingleton.sharedNetworkManager
    let sharedDataManager = SharedDataSingleton.sharedDataManager
    
    let fetchRequestTime = NSFetchRequest(entityName: "TimeStamp")
    
    var time: TimeStamp? = nil
    var timeStamps = [TimeStamp]()

    @IBAction func doneBarButtonItemTapped(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide unused rows
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        timeStamps = getTimes.dataFetchRequest()
    }
        
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return timeStamps.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, hh:mm a"
        
        let date = dateFormatter.stringFromDate(timeStamps[indexPath.row].time!)
        
        cell.detailTextLabel?.text = "\(timeStamps[indexPath.row].temperature!)"
        cell.textLabel?.text = date
        
        
        switch Int(timeStamps[indexPath.row].mode!) {
        case 1: // HEAT
            cell.backgroundColor = UIColor.orangeColor()
        case 2: // COOL
            cell.backgroundColor = UIColor.blueColor()
        case 4: // OFF
            cell.backgroundColor = UIColor.lightGrayColor()
        default: break
        }
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 10)
        
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 25)

        
        return cell
    }
}
