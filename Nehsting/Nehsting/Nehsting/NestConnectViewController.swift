//
//  NestConnectViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 4/21/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import NestSDK

class NestConnectViewController: UIViewController {
    
    let sharedNetworkManager = NetworkingDataSingleton.sharedNetworkManager
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // Check authorization
        if (NestSDKAccessToken.currentAccessToken() != nil) {
            sharedNetworkManager.observeStructures( { temp in
            })
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Main") as! MainViewController
            presentViewController(vc, animated: true, completion: nil)
            
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clean up
        sharedNetworkManager.removeObservers()
    }
    
    @IBAction func connectWithNestButtonTapped(sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            let authorizationManager = NestSDKAuthorizationManager()
            authorizationManager.authorizeWithNestAccountFromViewController(self, handler:{
                result, error in
                
                if (error == nil) {
                    print("Process error: \(error)")
                } else if (result.isCancelled) {
                    print("Cancelled")
                } else {
                    print("Authorized!")
                }
            })
        } else {
            print("Internet connection FAILED")
            let alertView = UIAlertController(title: "Server Error", message: "Internet connection FAILED", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
    }
}
