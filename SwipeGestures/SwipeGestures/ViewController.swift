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
    
    var red1: CGFloat = 205
    var green1: CGFloat = 122
    var blue1: CGFloat = 42
    
    var red2: CGFloat = 238
    var green2: CGFloat = 238
    var blue2: CGFloat = 238

    
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
    
    // GRADIENT SET METHODS
    
//    func setGradientColors() {
//        
//        let topColor = UIColor(red: red1/255.0, green: green1/255.0, blue: blue1/255.0, alpha: 1)
//        let bottomColor = UIColor(red: red2/255.0, green: green2/255.0, blue: blue2/255.0, alpha: 1)
//        
//        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
//        let gradientLocations: [Float] = [0.0, 1.0]
//        
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        gradientLayer.colors = gradientColors
//        gradientLayer.locations = gradientLocations
//        
//        gradientLayer.frame = self.view.bounds
//        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
//    }
}