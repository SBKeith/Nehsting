//
//  MenuSelectionViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 3/30/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class MenuSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func returnMenuButtonTapped(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
