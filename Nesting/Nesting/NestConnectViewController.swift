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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check authorization
        if (NestSDKAccessToken.currentAccessToken() != nil) {
            
            sharedDataManager.observeStructures()
            
//            print("Structure Found: \(sharedDataManager.structure!.name)")

        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // Check authorization
//        if (NestSDKAccessToken.currentAccessToken() != nil) {
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Main") as! MainViewController
//            presentViewController(vc, animated: true, completion: nil)
//        }
    }
    
    @IBAction func connectWithNestButtonTapped(sender: UIButton) {
        
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
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clean up
        sharedDataManager.removeObservers()
    }
}
