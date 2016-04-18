//
//  ViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 3/30/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var displayTemperatureValue: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var segmentedMenuBar: UISegmentedControl!
    
    // RGB Values for heat (h) and cool (c)
    var red_H:CGFloat = 255.0, green_H:CGFloat = 113.0, blue_H:CGFloat = 0.0
    var red_C:CGFloat = 0.0,   green_C:CGFloat = 30.0,  blue_C:CGFloat = 140.0
    
    // Values for heating and cooling
    var temperatureSettings = Values.temperatureSettings()
    let value = Values()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Set whether heat / cool is set (will need to pull data later)
        temperatureSettings.settingTitle = .heat

        // Setup NSUserDefaults temperature value under the key 'Heat' or 'Cool'
        value.settings.setValue(temperatureSettings.currentTemperature, forKey: temperatureSettings.settingTitle!.rawValue)
        value.settings.synchronize()

        // Set Initial Display Temperature
        displayTemperatureValue.text = "\(value.settings.valueForKey(temperatureSettings.settingTitle!.rawValue)!)"
        value.settings.synchronize()

        // Set Initial Power Value
        value.power = .off

        // Set Values for the segmentedMenuBar
        setSegmentedMenuBarValues()

        
        // Track pList for NSUserDefaults
        let path = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        let folder = path[0]
        NSLog("Your NSUserDefaults are stored in this folder: \(folder)/preferences")
    }
    
    func setSegmentedMenuBarValues() {
        segmentedMenuBar.setTitle(value.power!.rawValue, forSegmentAtIndex: 0)
        segmentedMenuBar.setTitle(temperatureSettings.settingTitle!.rawValue, forSegmentAtIndex: 1)
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
            
            // Determine value increases, based on distance touch has been dragged
            if value.valueParser % 5 == 0 {
                if !directionValueDecrease && withinTempBounds.0 {
                    temperatureSettings.currentTemperature += 1
                    
                    if temperatureSettings.currentTemperature % 5 == 0 {
                        adjustGradient("INCREASE")
                    }
                } else if directionValueDecrease && withinTempBounds.1 {
                    temperatureSettings.currentTemperature -= 1
                    
                    if temperatureSettings.currentTemperature % 5 == 0 {
                        adjustGradient("DECREASE")
                    }
                }
            }
            
            // Set temperatue value
            displayTemperatureValue.text = "\(temperatureSettings.currentTemperature)"
        }
    }
    
    // Reset valueParser when user lifts finger
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        value.valueParser = 0
        
        // Set temperatue value on display
        displayTemperatureValue.text = "\(temperatureSettings.currentTemperature)"
        
        // Set current temperature (for "heat" or "cool" in NSUserDefaults
        value.settings.setValue(temperatureSettings.currentTemperature, forKey: temperatureSettings.settingTitle!.rawValue)
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
        return ((temperatureSettings.currentTemperature < value.kMAXTEMP), (temperatureSettings.currentTemperature > value.kMINTEMP))
    }
    
    func getSegmentedMenuBarTouch() {
        
        let selectedIndex = segmentedMenuBar.selectedSegmentIndex
        
        switch(selectedIndex) {
            case 0:
                // Toggle Segmented Menu Bar Power Value
                segmentedMenuBar.titleForSegmentAtIndex(0) == "ON" ?
                    segmentedMenuBar.setTitle("OFF", forSegmentAtIndex: 0) : segmentedMenuBar.setTitle("ON", forSegmentAtIndex: 0)
            
                // Set NSUserDefaults ON or OFF
                if segmentedMenuBar.titleForSegmentAtIndex(0) == "ON" {
                    value.power = .on
                    value.settings.setValue(value.power?.rawValue, forKey: "power")
                } else {
                    value.power = .off
                    value.settings.setValue(value.power?.rawValue, forKey: "power")
                }
            
            case 1:
                // Toggle Segmented Menu Bar Temperature Value and set NSUserDefaults
                if segmentedMenuBar.titleForSegmentAtIndex(1) == "COOL" {
                    segmentedMenuBar.setTitle("HEAT", forSegmentAtIndex: 1)
                    temperatureSettings.settingTitle = .heat
                } else {
                    segmentedMenuBar.setTitle("COOL", forSegmentAtIndex: 1)
                    temperatureSettings.settingTitle = .cool
                }
                
                // Update temperature title
                value.settings.setValue(temperatureSettings.settingTitle!.rawValue, forKey: "temp")
                value.settings.synchronize()
            
                // Update temperature value
                temperatureSettings.currentTemperature = value.settings.integerForKey(temperatureSettings.settingTitle!.rawValue)
                displayTemperatureValue.text = "\(temperatureSettings.currentTemperature)"
                
                // Update gradient color when temp changed from heat / cool
//                gradientView.updateGradientColor()
            
            case 2:
                // Segue to history view controller
                let historyVC = UIStoryboard(name: "History", bundle: nil).instantiateViewControllerWithIdentifier("HistoryVC_ID")
                presentViewController(historyVC, animated: true, completion: nil)
            
            default: break
        }
    }
    
    func setCGColor(temp: String) {
        
        temp == "Heat" ? value.settings.setValue(value.gradientValue(red_H, green: green_H, blue: blue_H), forKey: "cgColor_Heat") : value.settings.setValue(value.gradientValue(red_H, green: green_H, blue: blue_H), forKey: "cgColor_Cool")
        
        value.settings.synchronize()
    }
    
    func adjustGradient(setting: String) {
        
        switch(value.settings.stringForKey("temp")!) {
        case "Heat":
            switch(setting) {
            case "INCREASE":
                green_H -= value.tempDifferential_1
                blue_H -= value.tempDifferential_2
                setCGColor("Heat")
                
            case "DECREASE":
                green_H += value.tempDifferential_1
                blue_H += value.tempDifferential_2
                setCGColor("Heat")
                
            default: break
            }
            
        case "Cool":
            switch(setting) {
            case "INCREASE":
                green_C += value.tempDifferential_1
                red_C += value.tempDifferential_2
                setCGColor("Cool")
                
            case "DECREASE":
                green_C -= value.tempDifferential_1
                red_C -= value.tempDifferential_2
                setCGColor("Cool")
                
            default: break
            }
            
        default: break
        }
    }

}

