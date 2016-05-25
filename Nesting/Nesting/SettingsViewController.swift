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
    @IBOutlet weak var homeOrAwayLabel: UILabel!
    
    let sharedNetworkManager = NetworkingDataSingleton.sharedNetworkManager
    let sharedDataManager = SharedDataSingleton.sharedDataManager
    var imageName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        backgroundView.addSubview(UIImageView(image: UIImage(named: "loadingScreen")))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getHomeOrAwayStatusImage()
    }
    
    func getHomeOrAwayStatusImage() {
        if let homeOrAway = sharedDataManager.homeOrAwayStatus {
            switch(homeOrAway) {
                case 1:
                    imageName = "home"
                    homeOrAwayLabel.text = "HOME"
                case 2:
                    imageName = "away"
                    homeOrAwayLabel.text = "AWAY"
                default: break
            }
            homeOrAwayButton.setBackgroundImage(UIImage(named: imageName), forState: .Normal)
        }
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
        if(imageName == "home") {
            sharedDataManager.homeOrAwayStatus = 2
        } else {
            sharedDataManager.homeOrAwayStatus = 1
        }
        getHomeOrAwayStatusImage()
        sharedNetworkManager.structureHomeOrAwayStatusUpdate()
    }
}
