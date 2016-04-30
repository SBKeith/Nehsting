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
    
    let sharedValues = ValuesSingleton.sharedValues
    var sharedTempStruct = ValuesSingleton.sharedTempStruct
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplayTemp()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        updateDisplayTemp()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NetworkingDataSingleton.sharedDataManager.removeObservers()
    }
    
    // MARK: -SET INITIAL VALUES
    func updateDisplayTemp() {
        
        NetworkingDataSingleton.sharedDataManager.observeStructures( { (temp, hvacMode) in
            if let temp = temp {
                self.sharedTempStruct.displayCurrentTemp = temp
                
                print("DISPLAY TEMP: \(self.sharedTempStruct.displayCurrentTemp)")
            }
            
            if let hvacMode = hvacMode {
                self.sharedTempStruct.hvacMode = hvacMode
                print("DISPLAY hvacMode: \(self.sharedTempStruct.hvacMode)")
            }
        })
        
    }
        

        

    // Set Segmented Bar Values
//    func setSegmentedMenuBarValues() {
//        
//        segmentedMenuBar.setTitle("ON", forSegmentAtIndex: 0)
//        segmentedMenuBar.setTitle("HEAT", forSegmentAtIndex: 1)
//        segmentedMenuBar.setTitle("HISTORY", forSegmentAtIndex: 2)
//    }
    
    // MARK: USER TOUCH INPUT / DRAG DETECTION
    
    // Check for finger dragging input
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        if let theTouch = touches.first {
//            let touchLocation = theTouch.locationInView(self.view)
//            let previousTouchLocation = theTouch.previousLocationInView(self.view)
//            
//            // ValueParser allows for Y coordinates to become manageable values, which simplifies data manipulation
//            sharedValues.valueParser += 1
//            
//            // Check for touch-drag direction
//            let directionValueDecrease = checkTouchDirection(touchLocation, previousTouch: previousTouchLocation)
//            
//            // Check for temperature limits
//            let withinTempBounds = checkTempBounds()
//            
//            if sharedValues.valueParser % 5 == 0 {
//                if !directionValueDecrease && withinTempBounds.0 {
//                    sharedTempStruct.displayCurrentTemp! += 1
//                    
//                    if sharedTempStruct.displayCurrentTemp! % 5 == 0 {
//                        gradientView.adjustGradient("INCREASE")
//                    }
//                } else if directionValueDecrease && withinTempBounds.1 {
//                    sharedTempStruct.displayCurrentTemp! -= 1
//                    
//                    if sharedTempStruct.displayCurrentTemp! % 5 == 0 {
//                        gradientView.adjustGradient("DECREASE")
//                    }
//                }
//            }
//            // Set temperatue value
//            displayValue.text = "\(sharedTempStruct.displayCurrentTemp!)"
//        }
//    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Reset valueParser when user lifts finger
//        sharedValues.valueParser = 0
        
        // Set NSUserDefaults for temperature value changes
//        setNSUserDefaults()
        
        // Set thermostat temperature
        
//        if sharedValues.settings.stringForKey("temperature") == "Heat" {
//            NetworkingDataSingleton.sharedDataManager.targetTemp = UInt(sharedValues.settings.integerForKey("tempHeat"))
//        } else {
//            NetworkingDataSingleton.sharedDataManager.targetTemp = UInt(sharedValues.settings.integerForKey("tempCool"))
//        }
        
//        NetworkingDataSingleton.sharedDataManager.setThermostatTemperature(NetworkingDataSingleton.sharedDataManager.targetTemp!)
//    }
    
    // Determine finger drag direction (up or down)
//    func checkTouchDirection(currentTouch: CGPoint, previousTouch: CGPoint) -> Bool {
//        
//        // If the current touch is > previous touch, user is dragging finger DOWN.
//        return currentTouch.y > previousTouch.y
//    }
//    
//    // MARK: SEGMENTED BAR TOUCH RECOGNITION AND SETTINGS
//    
//    @IBAction func segmentBarTouched(sender: UISegmentedControl) {
//        
//        getSegmentedMenuBarTouch()
//    }
//    
//    // Get user input from segmented menu bar
//    func getSegmentedMenuBarTouch() {
//        
//        let selectedIndex = segmentedMenuBar.selectedSegmentIndex
//        
//        switch(selectedIndex) {
//            case 0:
//                break
                // Toggle Segmented Menu Bar Power Value
//                segmentedMenuBar.titleForSegmentAtIndex(0) == "ON" ?
//                    segmentedMenuBar.setTitle("OFF", forSegmentAtIndex: 0) : segmentedMenuBar.setTitle("ON", forSegmentAtIndex: 0)
            
                // Set NSUserDefaults ON or OFF
//                if segmentedMenuBar.titleForSegmentAtIndex(0) == "ON" {
//                    sharedTempStruct.power = .on
//                } else {
//                    sharedTempStruct.power = .off
//                }
//                sharedValues.settings.setValue(sharedTempStruct.power?.rawValue, forKey: "power")
//                
//                
//            case 1:
//            break
//                // Toggle Segmented Menu Bar Temperature Setting
//                if segmentedMenuBar.titleForSegmentAtIndex(1) == "COOL" {
//                    segmentedMenuBar.setTitle("HEAT", forSegmentAtIndex: 1)
//                    sharedTempStruct.settingTitle = .heat
//                    sharedTempStruct.displayCurrentTemp! = sharedValues.settings.integerForKey("tempHeat")
//                    
//                    // Set Gradient
//                    gradientView.updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbHeat.0, green: sharedTempStruct.rgbHeat.1, blue: sharedTempStruct.rgbHeat.2))
//                } else {
//                    segmentedMenuBar.setTitle("COOL", forSegmentAtIndex: 1)
//                    sharedTempStruct.settingTitle = .cool
//                    sharedTempStruct.displayCurrentTemp = sharedValues.settings.integerForKey("tempCool")
//                    
//                    // Set Gradient
//                    gradientView.updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbCool.0, green: sharedTempStruct.rgbCool.1, blue: sharedTempStruct.rgbCool.2))
//                }
//                
//                sharedValues.settings.setValue(sharedTempStruct.settingTitle!.rawValue, forKey: "temperature")
//                sharedValues.settings.synchronize()
//                
//                displayValue.text = "\(sharedTempStruct.displayCurrentTemp!)"
            
//            case 2:
//                let historyVC = UIStoryboard(name: "History", bundle: nil).instantiateViewControllerWithIdentifier("HistoryVC_ID")
//                presentViewController(historyVC, animated: true, completion: nil)
//                
//            default: break
//            }
//    }
    
    // MARK: HELPER METHODS
    // Determine if temperature value is within set bounds
//    func checkTempBounds() -> (Bool, Bool) {
//        return ((sharedTempStruct.displayCurrentTemp! < sharedValues.kMAXTEMP), (sharedTempStruct.displayCurrentTemp! > sharedValues.kMINTEMP))
//}
}