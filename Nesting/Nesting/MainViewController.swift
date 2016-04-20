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
    
    let sharedValues = Values.sharedValues
    var sharedStruct = Values.sharedStruct
    
    var sharedTempStruct = Values.sharedTempStruct
    
    
    let value = Values()
    var tempSetting = Values.temperature()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Track pList for NSUserDefaults
//                let path = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
//                let folder = path[0]
//                NSLog("Your NSUserDefaults are stored in this folder: \(folder)/preferences")
        
        
        displayValue.text = "\(sharedTempStruct.currentTemperature)"  // Set initial temp
        
        
        
        setSegmentedMenuBarValues()
    }
    
    // Set Segmented Bar Values
    func setSegmentedMenuBarValues() {
        
        segmentedMenuBar.setTitle("ON", forSegmentAtIndex: 0)
        segmentedMenuBar.setTitle("HEAT", forSegmentAtIndex: 1)
        segmentedMenuBar.setTitle("HISTORY", forSegmentAtIndex: 2)
    }
    
    // Check for finger dragging input
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
                        gradientView.adjustGradient("INCREASE")
                    }
                } else if directionValueDecrease && withinTempBounds.1 {
                    value.currentTemp -= 1
                    
                    if value.currentTemp % 5 == 0 {
                        gradientView.adjustGradient("DECREASE")
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
        displayValue.text = "\(sharedTempStruct.currentTemperature)"    // FIX Current Running Temp (based on cool / heat)
        
        // Set NSUserDefaults
        setNSUserDefaults()
    }
    
    func setNSUserDefaults() {
        
        
    }
    
    @IBAction func segmentBarTouched(sender: UISegmentedControl) {
        
        getSegmentedMenuBarTouch()
    }
    
    // MARK: - Helper Methods
    
    // Get user input from segmented menu bar
    func getSegmentedMenuBarTouch() {
        
        let selectedIndex = segmentedMenuBar.selectedSegmentIndex
        
        switch(selectedIndex) {
        case 0:
            // Toggle Segmented Menu Bar Power Value
            segmentedMenuBar.titleForSegmentAtIndex(0) == "ON" ?
                segmentedMenuBar.setTitle("OFF", forSegmentAtIndex: 0) : segmentedMenuBar.setTitle("ON", forSegmentAtIndex: 0)
            
            // Set NSUserDefaults ON or OFF
            if segmentedMenuBar.titleForSegmentAtIndex(0) == "ON" {
                sharedTempStruct.power = .on
            } else {
                sharedTempStruct.power = .off
            }
            sharedValues.settings.setValue(sharedTempStruct.power?.rawValue, forKey: "power")
            
            
        case 1:
            // Toggle Segmented Menu Bar Temperature Setting
            if segmentedMenuBar.titleForSegmentAtIndex(1) == "COOL" {
                segmentedMenuBar.setTitle("HEAT", forSegmentAtIndex: 1)
                sharedTempStruct.settingTitle = .heat
                
                // Set Gradient
                gradientView.updateGradientColor(tempSetting.heat, cgColor2: tempSetting.neutral)
            } else {
                segmentedMenuBar.setTitle("COOL", forSegmentAtIndex: 1)
                sharedTempStruct.settingTitle = .cool
                
                // Set Gradient
                gradientView.updateGradientColor(tempSetting.cool, cgColor2: tempSetting.neutral)
            }
            
            sharedValues.settings.setValue(sharedTempStruct.settingTitle!.rawValue, forKey: "temperature")
            sharedValues.settings.synchronize()
            
        case 2:
            let historyVC = UIStoryboard(name: "History", bundle: nil).instantiateViewControllerWithIdentifier("HistoryVC_ID")
            presentViewController(historyVC, animated: true, completion: nil)
            
        default: break
        }
    }
    
    // Determine finger drag direction (up or down)
    func checkTouchDirection(currentTouch: CGPoint, previousTouch: CGPoint) -> Bool {
        
        // If the current touch is > previous touch, user is dragging finger DOWN.
        return currentTouch.y > previousTouch.y
    }
    
    // Determine if temperature value is within set bounds
    func checkTempBounds() -> (Bool, Bool) {
        return ((value.currentTemp < value.kMAXTEMP), (value.currentTemp > value.kMINTEMP))
    }    
}

