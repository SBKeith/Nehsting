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
    
    var red1: CGFloat = 255.0
    var green1: CGFloat = 113.0
    var blue1: CGFloat = 0.0
    
    var red2: CGFloat = 238.0
    var green2: CGFloat = 238.0
    var blue2: CGFloat = 238.0
    
    // 255, 200, 150
    
    @IBOutlet weak var gradientView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        value.text = "\(currentTemp)"
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let theTouch = touches.first {
            let touchLocation = theTouch.locationInView(self.view)
            let previousTouchLocation = theTouch.previousLocationInView(self.view)
            
            // ValueParser allows for Y coordinates to become manageable values, which simplifies data manipulation
            valueParser += 1
            
            // Check for touch-drag direction
            let directionValueDecrease = checkTouchDirection(touchLocation, previousTouch: previousTouchLocation)
            
            // Check for temperature limits
            let withinTempBounds = checkTempBounds()
            
            if valueParser % 5 == 0 {
                if !directionValueDecrease && withinTempBounds.0 {
                    currentTemp += 1
                    (currentTemp % 5 == 0) ? adjustGradient("HEAT") : print("")
                    
                } else if directionValueDecrease && withinTempBounds.1 {
                    currentTemp -= 1
                    (currentTemp % 5 == 0) ? adjustGradient("COOL") : print("")
                }
            }
            
            // Set temperatue value
            value.text = "\(currentTemp)"
        }
    }
    
    // Reset valueParser when user lifts finger
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        valueParser = 0
        
        // Set temperatue value
        value.text = "\(currentTemp)"
    }

    // MARK: - Helper Methods
    
    func checkTouchDirection(currentTouch: CGPoint, previousTouch: CGPoint) -> Bool {
        
        // If the current touch is > previous touch, user is dragging finger DOWN.
        return currentTouch.y > previousTouch.y
    }
    
    func checkTempBounds() -> (Bool, Bool) {
        
        return ((currentTemp < kMAXVALUE), (currentTemp > kMINVALUE))
    }
    
    func adjustGradient(value: String) {
        
        let rValue: CGFloat = red1
        let gValue: CGFloat = 10
        let bValue: CGFloat = 20
        
        switch(value) {
            case "HEAT":
                red1 = rValue
                green1 -= gValue
                blue1 -= bValue
            case "COOL":
                red1 = rValue
                green1 += gValue
                blue1 += bValue
            default: break
        }
        gradientView.updateGradientColor(UIColor(red: red1/255.0, green: green1/255.0, blue: blue1/255.0, alpha: 1), color2: UIColor(red: red2/255.0, green: green2/255.0, blue: blue2/255.0, alpha: 1))
    }
}