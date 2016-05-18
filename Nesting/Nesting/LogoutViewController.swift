//
//  LogoutViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 5/17/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import NestSDK

class LogoutViewController: UIViewController {
    
    let sharedNetworkManager = NetworkingDataSingleton.sharedNetworkManager

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(sender: UIButton) {
        
        NestSDKAccessToken.setCurrentAccessToken(nil)
        
        let vc = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewControllerWithIdentifier("SignIn") as! NestConnectViewController
        presentViewController(vc, animated: true, completion: nil)
    }
}
