//
//  ViewController.swift
//  SwipeGestures
//
//  Created by Keith Kowalski on 3/31/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var value: UILabel!
    
    var valueInt = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    @IBAction func panGestureUp(recognizer: UIPanGestureRecognizer) {
////        valueInt++
////        value.text = "\(valueInt)"
//        
//    }
    
    // Capture initial starting point
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let theTouch = touches.first {
            let startPoint = theTouch.locationInView(self.view)
            
            let x = startPoint.x
            let y = startPoint.y
            
            print("START POINT:\nx = \(x)\ny = \(y)")
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let theTouch = touches.first {
            let touchLocation = theTouch.locationInView(self.view)
            
            let x = touchLocation.x
            let y = touchLocation.y
            
            print("x = \(x)\ny = \(y)")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let theTouch = touches.first {
            let touchLocation = theTouch.locationInView(self.view)
            
            let x = touchLocation.x
            let y = touchLocation.y
            
            print("END POINT:\nx = \(x)\ny = \(y)")
        }
    }
}



