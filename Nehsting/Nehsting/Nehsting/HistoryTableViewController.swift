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
        
//        fetchRequestState.predicate = NSPredicate(format: "state == %@", self.hvacState!)
//        fetchRequestTime.predicate = NSPredicate(format: "TimeStamp == %@", self.time!)
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
        dateFormatter.dateFormat = "hh:mm"
        
        let date = dateFormatter.stringFromDate(timeStamps[indexPath.row].time!)
        
        cell.detailTextLabel?.text = date
        
        return cell
    }
}
