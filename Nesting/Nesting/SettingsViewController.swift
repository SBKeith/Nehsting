//
//  LogoutViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 5/17/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import NestSDK

class SettingsViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var homeOrAwayButton: UIButton!
    
    let sharedNetworkManager = NetworkingDataSingleton.sharedNetworkManager
    let sharedDataManager = SharedDataSingleton.sharedDataManager

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        backgroundView.addSubview(UIImageView(image: UIImage(named: "loadingScreen")))
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        homeOrAwayButton.setTitle("\(sharedDataManager.homeOrAwayStatus!)", forState: .Normal)
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func logoutButtonTapped(sender: UIButton) {
        
        NestSDKAccessToken.setCurrentAccessToken(nil)
        
        let vc = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewControllerWithIdentifier("SignIn") as! NestConnectViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func homeOrAwayButtonTapped(sender: UIButton) {
        
        if(homeOrAwayButton.titleLabel!.text == "1") {
            homeOrAwayButton.setTitle("2", forState: .Normal)
            sharedDataManager.homeOrAwayStatus = 2
        } else {
            homeOrAwayButton.setTitle("1", forState: .Normal)
            sharedDataManager.homeOrAwayStatus = 1
        }
        
        sharedNetworkManager.structureHomeOrAwayStatusUpdate()
    }
}
