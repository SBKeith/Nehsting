//
//  ViewController.swift
//  SwipeGestures
//
//  Created by Keith Kowalski on 3/31/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayValue: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    
    let value = Values()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayValue.text = "\(value.currentTemp)"   // Set initial temp
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let theTouch = touches.first {
            let touchLocation = theTouch.locationInView(self.view)
            let previousTouchLocation = theTouch.previousLocationInView(self.view)
            
            // ValueParser allows for Y coordinates to become manageable values, which simplifies data manipulation
            value.valueParser += 1
            
            // Check for touch-drag direction
            let directionValueDecrease = checkTouchDirection(touchLocation, previousTouch: previousTouchLocation)
            
            // Check for temperature limits
            let withinTempBounds = checkTempBounds()
            
            if value.valueParser % 5 == 0 {
                if !directionValueDecrease && withinTempBounds.0 {
                    value.currentTemp += 1
                    
                    if value.currentTemp % 5 == 0 {
                        adjustGradient("HEAT")
                    }
                } else if directionValueDecrease && withinTempBounds.1 {
                    value.currentTemp -= 1
                    
                    if value.currentTemp % 5 == 0 {
                        adjustGradient("COOL")
                    }
                }
            }
            // Set temperatue value
            displayValue.text = "\(value.currentTemp)"
        }
    }
    
    // Reset valueParser when user lifts finger
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        value.valueParser = 0
        
        // Set temperatue value
        displayValue.text = "\(value.currentTemp)"
    }

    // MARK: - Helper Methods
    
    func checkTouchDirection(currentTouch: CGPoint, previousTouch: CGPoint) -> Bool {
        
        // If the current touch is > previous touch, user is dragging finger DOWN.
        return currentTouch.y > previousTouch.y
    }
    
    func checkTempBounds() -> (Bool, Bool) {
        
        return ((value.currentTemp < value.kMAXTEMP), (value.currentTemp > value.kMINTEMP))
    }
    
    func adjustGradient(setting: String) {
        
        let rValue: CGFloat = value.red1
        let gValue: CGFloat = 10
        let bValue: CGFloat = 20
        let rgb2 = value.kLOWERGRADIENT
        
        switch(setting) {
            case "HEAT":
                value.red1 = rValue
                value.green1 -= gValue
                value.blue1 -= bValue
            case "COOL":
                value.red1 = rValue
                value.green1 += gValue
                value.blue1 += bValue
            default: break
        }
        gradientView.updateGradientColor(UIColor(red: value.red1/255.0, green: value.green1/255.0, blue: value.blue1/255.0, alpha: 1), color2: UIColor(red: rgb2, green: rgb2, blue: rgb2, alpha: 1))
    }
}