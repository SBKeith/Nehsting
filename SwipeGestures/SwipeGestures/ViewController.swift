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
    
    let kMAXVALUE = 90
    let kMINVALUE = 50
    
    var currentTemp = 75
    var valueParser = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        value.text = "\(currentTemp)"
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let theTouch = touches.first {
            let touchLocation = theTouch.locationInView(self.view)
            let previousTouchLocation = theTouch.previousLocationInView(self.view)
            
            // ValueParser makes Y coordinates become manageable values, which simplifies data manipulation
            valueParser += 1
            
            // Check for touch-drag direction
            let directionValue = checkTouchDirection(touchLocation, previousTouch: previousTouchLocation)
            
            // Check for temperature limits
            let withinTempBounds = checkTempBounds()
            
            if valueParser % 10 == 0 {
                if !directionValue && withinTempBounds.0 {
                    currentTemp += 1
                } else if directionValue && withinTempBounds.1 {
                    currentTemp -= 1
                }
            }
            
            // Set temperatue value
            value.text = "\(currentTemp)"
        }
    }
    
    // Reset valueParser when user lifts finger
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        valueParser = 0
    }

    // MARK: - Helper Methods
    
    func checkTouchDirection(currentTouch: CGPoint, previousTouch: CGPoint) -> Bool {
        
        return currentTouch.y > previousTouch.y
    }
    
    func checkTempBounds() -> (Bool, Bool) {
        
        return ((currentTemp < kMAXVALUE), (currentTemp > kMINVALUE))
    }
}



