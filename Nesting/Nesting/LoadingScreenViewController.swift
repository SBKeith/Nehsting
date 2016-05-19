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
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        loadingSpinner.stopAnimating()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
}
