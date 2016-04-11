//
//  ViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 3/30/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var displayValue: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var segmentedMenuBar: UISegmentedControl!
    
    let value = Values()
    var tempSetting = Values.temperature()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayValue.text = "\(value.currentTemp)"   // Set initial temp
        setSegmentedMenuBarValues()
    }
    
    func setSegmentedMenuBarValues() {
        
        segmentedMenuBar.setTitle("ON", forSegmentAtIndex: 0)
        segmentedMenuBar.setTitle("HEAT", forSegmentAtIndex: 1)
        segmentedMenuBar.setTitle("HISTORY", forSegmentAtIndex: 2)
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
                        adjustGradient("INCREASE")
                    }
                } else if directionValueDecrease && withinTempBounds.1 {
                    value.currentTemp -= 1
                    
                    if value.currentTemp % 5 == 0 {
                        adjustGradient("DECREASE")
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

    
    @IBAction func segmentBarTouched(sender: UISegmentedControl) {
        
        getSegmentedMenuBarTouch()
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
        
        switch(value.settings.stringForKey("temp")!) {
            case "heat":
                switch(setting) {
                case "INCREASE":
                    tempSetting.hRed = value.hRed
                    tempSetting.hGreen -= value.tempDifferential_1
                    tempSetting.hBlue -= value.tempDifferential_2
                    gradientView.updateGradientColor(tempSetting.heat, cgColor2: tempSetting.neutral)
                    
                case "DECREASE":
                    tempSetting.hRed = value.hRed
                    tempSetting.hGreen += value.tempDifferential_1
                    tempSetting.hBlue += value.tempDifferential_2
                    gradientView.updateGradientColor(tempSetting.heat, cgColor2: tempSetting.neutral)
                    
                default: break
            }
            
            case "cool":
                switch(setting) {
                case "INCREASE":
                    tempSetting.cBlue = value.cBlue
                    tempSetting.cGreen += value.tempDifferential_1
                    tempSetting.cRed += value.tempDifferential_2
                    gradientView.updateGradientColor(tempSetting.cool, cgColor2: tempSetting.neutral)
                    
                case "DECREASE":
                    tempSetting.cBlue = value.cBlue
                    tempSetting.cGreen -= value.tempDifferential_1
                    tempSetting.cRed -= value.tempDifferential_2
                    gradientView.updateGradientColor(tempSetting.cool, cgColor2: tempSetting.neutral)
                    
                default: break
            }
            
            default: break
        }
    }
    
    func getSegmentedMenuBarTouch() {
        
        let selectedIndex = segmentedMenuBar.selectedSegmentIndex
        
        switch(selectedIndex) {
            case 0:
                segmentedMenuBar.titleForSegmentAtIndex(0) == "ON" ?
                    segmentedMenuBar.setTitle("OFF", forSegmentAtIndex: 0) : segmentedMenuBar.setTitle("ON", forSegmentAtIndex: 0)
            
            case 1:
                segmentedMenuBar.titleForSegmentAtIndex(1) == "COOL" ?
                    segmentedMenuBar.setTitle("HEAT", forSegmentAtIndex: 1) : segmentedMenuBar.setTitle("COOL", forSegmentAtIndex: 1)
            
                if segmentedMenuBar.titleForSegmentAtIndex(1) == "COOL" {
                    value.settings.setValue("cool", forKey: "temp")
                    value.settings.synchronize()
                    gradientView.updateGradientColor(tempSetting.cool, cgColor2: tempSetting.neutral)
                } else {
                    value.settings.setValue("heat", forKey: "temp")
                    value.settings.synchronize()
                    gradientView.updateGradientColor(tempSetting.heat, cgColor2: tempSetting.neutral)
                }
            
            case 2:
                // Insert segue code here...
                break
            
            default: break
        }
    }
}

