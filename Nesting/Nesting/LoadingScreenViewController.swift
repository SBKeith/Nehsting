//
//  LoadingScreenViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 5/18/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(hideLoadingScreen), name: "hideLoadingScreen", object: nil)
        
        loadingSpinner.startAnimating()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        loadingSpinner.stopAnimating()
    }
    
    func hideLoadingScreen(notification: NSNotification) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Main") as! MainViewController
        presentViewController(vc, animated: true, completion: nil)
    }
}
