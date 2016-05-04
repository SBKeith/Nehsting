//
//  ViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 3/30/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import NestSDK

class MainViewController: UIViewController {
    
    @IBOutlet weak var displayValue: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var mainButton: UIButton!
    
    // Singleton Values
    
    // USED
    let sharedValues = ValuesSingleton.sharedValues
    
    var sharedButtonImages = ValuesSingleton.mainButtonStruct()
    
    var networkDataSingleton = NetworkingDataSingleton.sharedDataManager
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        displayValuesUpdate()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        NetworkingDataSingleton.sharedDataManager.removeObservers()
    }
    
    // MARK: -SET VALUES
    
    // Update display values
    func displayValuesUpdate() {
        
        
        
        NetworkingDataSingleton.sharedDataManager.observeStructures( { (temp, hvacMode) in
            self.sharedValues.tempSettings?.hvacMode = hvacMode!
            self.sharedValues.tempSettings?.displayCurrentTemp = temp!
            self.setMainButton()
            self.setDisplayTemp()
        })
    }
    
    // Set image for main button
    func setMainButton() {
        if let hvacMode = ValuesSingleton.sharedValues.tempSettings?.hvacMode {
            
            let sharedTempStruct = ValuesSingleton.sharedValues.tempSettings!
            
            switch(Int(hvacMode)) {
                case 1: // HEAT
                    mainButton.setBackgroundImage(sharedButtonImages.mainButtonArray[0], forState: .Normal)
                    // Set Gradient
                    gradientView.updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbHeat.0, green: sharedTempStruct.rgbHeat.1, blue: sharedTempStruct.rgbHeat.2))
                case 2: // COOL
                    mainButton.setBackgroundImage(sharedButtonImages.mainButtonArray[1], forState: .Normal)
                    gradientView.updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbCool.0, green: sharedTempStruct.rgbCool.1, blue: sharedTempStruct.rgbCool.2))

                case 4: // OFF
                    mainButton.setBackgroundImage(sharedButtonImages.mainButtonArray[2], forState: .Normal)
                default:
                    break
            }
        }
    }
    
    // Set display temperature
    func setDisplayTemp() {
        
        if let displayTemp = ValuesSingleton.sharedValues.tempSettings?.displayCurrentTemp {
            
            let sharedTempStruct = ValuesSingleton.sharedValues.tempSettings!
            
            switch(sharedTempStruct.hvacMode) {
                case 1, 2:
                    displayValue.text = "\(displayTemp)"
                case 4:
                    displayValue.text = ""
                default:
                    break
            }
        }
    }
    
    // Update thermostat changes
    func networkValuesUpdate() {
        
        let sharedTempStruct = ValuesSingleton.sharedValues.tempSettings!
        
        networkDataSingleton.thermostat!.hvacMode = NestSDKThermostatHVACMode(rawValue: sharedTempStruct.hvacMode)!
        
        networkDataSingleton.dataManager.setThermostat(networkDataSingleton.thermostat, block: { (thermostat, error) in
            if error != nil {
                print("ERROR")
            } else {
                print("SUCCESS")
            }
        })
    }
    
    // MARK: USER INTERACTION FUNCTIONS
    
    // Main button tapped
    @IBAction func mainButtonTapped(sender: UIButton) {
        
        // Set hvacMode
        if let hvacMode = ValuesSingleton.sharedValues.tempSettings?.hvacMode {
            
            var sharedTempStruct = ValuesSingleton.sharedValues.tempSettings!
            
            switch(hvacMode) {
                case 1:
                    sharedTempStruct.hvacMode = 2
                case 2:
                    sharedTempStruct.hvacMode = 4
                case 4:
                    sharedTempStruct.hvacMode = 1
                default:
                    break
            }
            networkValuesUpdate()
            displayValuesUpdate()
        }
    }
    
    // MARK: USER TOUCH INPUT / DRAG DETECTION
    
    // Check for finger dragging input
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let theTouch = touches.first {
            let touchLocation = theTouch.locationInView(self.view)
            let previousTouchLocation = theTouch.previousLocationInView(self.view)

            // ValueParser allows for Y coordinates to become manageable values, which simplifies data manipulation
            sharedValues.valueParser += 1
            
            // Check for touch-drag direction
            let directionValueDecrease = checkTouchDirection(touchLocation, previousTouch: previousTouchLocation)
            
            // Check for temperature limits
            let withinTempBounds = checkTempBounds()
            
            var sharedTempStruct = ValuesSingleton.sharedValues.tempSettings!
            
            if sharedValues.valueParser % 5 == 0 {
                if !directionValueDecrease && withinTempBounds.0 {
                    sharedTempStruct.displayCurrentTemp += 1
                    
                    if sharedTempStruct.displayCurrentTemp % 5 == 0 {
                        gradientView.adjustGradient("INCREASE")
                    }
                } else if directionValueDecrease && withinTempBounds.1 {
                    sharedTempStruct.displayCurrentTemp -= 1
                    
                    if sharedTempStruct.displayCurrentTemp % 5 == 0 {
                        gradientView.adjustGradient("DECREASE")
                    }
                }
            }
            // Set temperatue value
            displayValue.text = "\(sharedTempStruct.displayCurrentTemp)"
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let sharedTempStruct = ValuesSingleton.sharedValues.tempSettings!
        
        // Reset valueParser when user lifts finger
            sharedValues.valueParser = 0
        
        // Set thermostat temperature on screen
        displayValue.text = "\(sharedTempStruct.displayCurrentTemp)"
        
        // Set thermostat temperature via network to NEST
        
    }
    
    // Determine finger drag direction (up or down)
    func checkTouchDirection(currentTouch: CGPoint, previousTouch: CGPoint) -> Bool {
        
        // If the current touch is > previous touch, user is dragging finger DOWN.
        return currentTouch.y > previousTouch.y
    }
    
    // MARK: HELPER METHODS
    // Determine if temperature value is within set bounds
    func checkTempBounds() -> (Bool, Bool) {
        
        let sharedTempStruct = ValuesSingleton.sharedValues.tempSettings!
        
        return ((Int(sharedTempStruct.displayCurrentTemp) < sharedValues.kMAXTEMP), (Int(sharedTempStruct.displayCurrentTemp) > sharedValues.kMINTEMP))
    }
}