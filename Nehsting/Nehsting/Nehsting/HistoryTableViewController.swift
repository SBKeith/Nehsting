//
//  HistoryTableViewController.swift
//  Nehsting
//
//  Created by Keith Kowalski on 9/9/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import NestSDK

class HistoryTableViewController: UITableViewController {
    
    let sharedNetworkManager = NetworkingDataSingleton.sharedNetworkManager
    let sharedDataManager = SharedDataSingleton.sharedDataManager

    @IBAction func doneBarButtonItemTapped(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("HVAC STATE: ", self.sharedDataManager.hvacState?.rawValue)
        print("Last Connection: ", self.sharedDataManager.timeStamp)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        return cell
    }
}
