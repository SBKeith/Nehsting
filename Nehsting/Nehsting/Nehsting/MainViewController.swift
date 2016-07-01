//
//  ViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 3/30/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import NestSDK

let indicator: UIActivityIndicatorView = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

class MainViewController: UIViewController {
    
    @IBOutlet weak var displayValue: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var leafImageView: UIImageView!

    let container: UIView = UIView()
    let loadingView: UIView = UIView()

    // Singleton Values
    var sharedDataManager = SharedDataSingleton.sharedDataManager
    var sharedNetworkManager = NetworkingDataSingleton.sharedNetworkManager
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        showLoadingScreen(self.view)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(launchAlertViewServerError), name: "displayErrorAlert", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(hideLoadingScreen), name: "hideLoadingScreen", object: nil)
        displayValuesUpdate()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // Remove observers
        sharedNetworkManager.removeObservers()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: -HELPER METHODS
    
    // Show loading screen function
    func showLoadingScreen(uiView: UIView) {
        
        // Add background
        container.frame = uiView.frame
        container.center = uiView.center
        container.addSubview(UIImageView(image: UIImage(named: "loadingScreen")))
        uiView.addSubview(container)
        
        // Add transparent box overlay
        loadingView.frame = CGRectMake(0, 0, 150, 150)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let label = UILabel(frame: CGRectMake(0, 0, 125, 20))
        label.text = "Connecting to Server..."
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.whiteColor()
        loadingView.addSubview(label)
        label.center = CGPointMake(loadingView.frame.size.width / 2, 20)
        
        container.addSubview(loadingView)
        
        // Add spinner animation
        indicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)
        loadingView.addSubview(indicator)
        indicator.startAnimating()
    }
    
    // Fade out of loading screen function
    func hideLoadingScreen(notification: NSNotification) {
        
        UIView.animateWithDuration(1.5, animations: {
            indicator.alpha = 0
            self.loadingView.alpha = 0
            self.container.alpha = 0
        }) { complete in
            indicator.stopAnimating()
            indicator.hidden = true
            self.container.hidden = true
            self.loadingView.hidden = true
        }
    }
    
    // MARK: -SET VALUES
    
    // Update display values
    func displayValuesUpdate() {

        sharedNetworkManager.observeStructures( { (temp, hvacMode) in
            if let hvacMode = hvacMode, temp = temp {
                self.sharedDataManager.hvacMode = hvacMode
                self.sharedDataManager.temperature = temp
                self.setMainButton()
                self.setDisplayTemp()
                self.showOrHideLeafImage()
            }
        })
    }
    
    // Set image for main button
    func setMainButton() {
        
        if let hvacMode: UInt = sharedDataManager.hvacMode {
            switch(Int(hvacMode)) {
                case 1: // HEAT
                    // Set Image Values
                    mainButton.setBackgroundImage(sharedDataManager.mainButtonImagesArray[0], forState: .Normal)
                    mainButton.setTitle("HEAT", forState: .Normal)
                    // Set Gradient
                    gradientView.updateGradientColor(sharedDataManager.gradientValue(sharedDataManager.rgbHeat.0, green: sharedDataManager.rgbHeat.1, blue: sharedDataManager.rgbHeat.2))
                
                case 2: // COOL
                    // Set Image Values
                    mainButton.setBackgroundImage(sharedDataManager.mainButtonImagesArray[1], forState: .Normal)
                    mainButton.setTitle("COOL", forState: .Normal)
                    // Set Gradient
                    gradientView.updateGradientColor(sharedDataManager.gradientValue(sharedDataManager.rgbCool.0, green: sharedDataManager.rgbCool.1, blue: sharedDataManager.rgbCool.2))
                
                case 4: // OFF
                    // Set Image Values
                    mainButton.setBackgroundImage(sharedDataManager.mainButtonImagesArray[2], forState: .Normal)
                    mainButton.setTitle("OFF", forState: .Normal)
                    
                    // Set Gradient
                    gradientView.updateGradientColor(sharedDataManager.gradientValue(sharedDataManager.rgbOff.0, green: sharedDataManager.rgbOff.1, blue: sharedDataManager.rgbOff.2))
                default:
                    break
            }
        }
    }

    // Set display temperature
    func setDisplayTemp() {
        
        if let displayTemp: UInt =  sharedDataManager.temperature {
            switch(sharedDataManager.hvacMode) {
                case 1, 2:
                    displayValue.text = "\(displayTemp)"
                case 4:
                    displayValue.text = ""
                default:
                    break
            }
        }
    }
    
    func showOrHideLeafImage() {
        
        sharedDataManager.leafHidden! == true ? (leafImageView.hidden = false) : (leafImageView.hidden = true)
    }
    
    // MARK: USER INTERACTION FUNCTIONS
    
    // Main button tapped
    @IBAction func mainButtonTapped(sender: UIButton) {
        
        // Set hvacMode
        if let hvacMode: UInt =  sharedDataManager.hvacMode {
            switch(hvacMode) {
                case 1:
                    sharedDataManager.hvacMode = 2
                case 2:
                    sharedDataManager.hvacMode = 4
                case 4:
                    sharedDataManager.hvacMode = 1
                default:
                    break
            }
            sharedNetworkManager.networkHVACUpdate()
            displayValuesUpdate()
        }
    }
    
    // MARK: USER TOUCH INPUT / DRAG DETECTION
    
    // Check for finger dragging input
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if sharedDataManager.hvacMode != 4 {    // Check that system is NOT off
            if let theTouch = touches.first {
                let touchLocation = theTouch.locationInView(self.view)
                let previousTouchLocation = theTouch.previousLocationInView(self.view)

                // ValueParser allows for Y coordinates to become manageable values, which simplifies data manipulation
                sharedDataManager.valueParser += 1
                
                // Check for touch-drag direction
                let directionValueDecrease = checkTouchDirection(touchLocation, previousTouch: previousTouchLocation)
                
                // Check for temperature limits
                let withinTempBounds = checkTempBounds()
                
                if sharedDataManager.valueParser % 10 == 0 {
                    if !directionValueDecrease && withinTempBounds.0 {
                        sharedDataManager.temperature += 1
                        
                        if sharedDataManager.temperature % 1 == 0 {
                            gradientView.adjustGradient("INCREASE")
                        }
                    } else if directionValueDecrease && withinTempBounds.1 {
                        sharedDataManager.temperature -= 1
                        
                        if sharedDataManager.temperature % 1 == 0 {
                            gradientView.adjustGradient("DECREASE")
                        }
                    }
                }
                // Set temperatue value
                displayValue.text = "\(sharedDataManager.temperature)"
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Reset valueParser when user lifts finger
            sharedDataManager.valueParser = 0
        
        if sharedDataManager.hvacMode != 4 {    // Check that system is NOT off
            // Set thermostat temperature on screen
            displayValue.text = "\(sharedDataManager.temperature)"
            
            // Set thermostat temperature via network to NEST
            sharedNetworkManager.networkTemperatureUpdate()
        }
    }
    
    // Determine finger drag direction (up or down)
    func checkTouchDirection(currentTouch: CGPoint, previousTouch: CGPoint) -> Bool {
        
        // If the current touch is > previous touch, user is dragging finger DOWN.
        return currentTouch.y > previousTouch.y
    }
    
    // MARK: HELPER METHODS
    // Determine if temperature value is within set bounds
    func checkTempBounds() -> (Bool, Bool) {
        
        return ((Int(sharedDataManager.temperature) < sharedDataManager.kMAXTEMP), (Int(sharedDataManager.temperature) > sharedDataManager.kMINTEMP))
    }
    
    func launchAlertViewServerError(notification: NSNotification) {
        
        let alertView = UIAlertController(title: "Server Error", message: "Nest server has blocked your request, due to too many calls.  Please try again after a few minutes.", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
}