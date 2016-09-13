//
//  ViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 3/30/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import NestSDK
import CoreData

let indicator: UIActivityIndicatorView = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

class MainViewController: UIViewController {
    
    @IBOutlet weak var displayValue: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var leafImageView: UIImageView!
    @IBOutlet weak var menuButtons: UIView!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var coolButton: UIButton!
    @IBOutlet weak var heatButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!

    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    
    var menuButtonIsActive = false

    // Singleton Values
    var sharedDataManager = SharedDataSingleton.sharedDataManager
    var sharedNetworkManager = NetworkingDataSingleton.sharedNetworkManager
    let fetchRequestTime = NSFetchRequest(entityName: "TimeStamp")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        showLoadingScreen(self.view)
        
        offButton.addTarget(self, action: #selector(self.setHVACMode), forControlEvents: .TouchUpInside)
        coolButton.addTarget(self, action: #selector(self.setHVACMode), forControlEvents: .TouchUpInside)
        heatButton.addTarget(self, action: #selector(self.setHVACMode), forControlEvents: .TouchUpInside)
        downButton.addTarget(self, action: #selector(self.setTempWithButton), forControlEvents: .TouchUpInside)
        upButton.addTarget(self, action: #selector(self.setTempWithButton), forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
        temperatureControlOnOff(!sharedDataManager.temperatureControls)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(launchAlertViewServerError), name: "displayErrorAlert", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(hideLoadingScreen), name: "hideLoadingScreen", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(displayNoThermostat), name: "displayNoThermostat", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(noInternetConnection), name: "noInternetConnection", object: nil)
        displayValuesUpdate()
        }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // Remove observers
        sharedNetworkManager.removeObservers()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func temperatureControlOnOff(setBool: Bool) {
        
        downButton.hidden = setBool
        upButton.hidden = setBool
    }
    
    func setTempWithButton(sender: UIButton) {
        
        switch(sender.tag) {
        case 0: // Increase Temp
            sharedDataManager.temperature += 1
            
            if sharedDataManager.temperature % 1 == 0 {
                gradientView.adjustGradient("INCREASE")
            }
        case 1: // Decrease Temp
            sharedDataManager.temperature -= 1
            
            if sharedDataManager.temperature % 1 == 0 {
                gradientView.adjustGradient("DECREASE")
            }
        default: break
        }
        
        // Set display temperature reading
        displayValue.text = "\(sharedDataManager.temperature)"
        
        // Set thermostat temperature via network to NEST
        sharedNetworkManager.networkTemperatureUpdate()
        
        // Save user data
        saveData()
    }
    
    // MARK: -HELPER METHODS
    
    // Save data to coredata
    func saveData() {
        
        // If time does not exist in coredata; save it along with hvac mode and temp
        if !checkIfTimeExists(sharedDataManager.timeStamp!, temp: sharedDataManager.temperature, mode: sharedDataManager.hvacMode) {
            print("Saving new time stamp...")
            saveTimeStampData()
        }
    }
    
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
    
    func setHVACMode(sender: UIButton) {
        
        // Set hvacMode
        switch(sender.tag) {
        case 1: // HEAT
            sharedDataManager.hvacMode = 1
        case 2: // COOL
            sharedDataManager.hvacMode = 2
        case 4: // OFF
            sharedDataManager.hvacMode = 4
        default:
            break
        }
        // Hide Buttons
        self.menuButtonIsActive = true
        mainButtonTapped(sender)
        
        // Update HVAC
        sharedNetworkManager.networkHVACUpdate()
        
        // Update Display
        displayValuesUpdate()
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
                self.setGradient()
                self.setDisplayTemp()
                self.showOrHideLeafImage()
            }
        })
    }
    
    // Set image for main button
    func setGradient() {
        
        if let hvacMode: UInt = sharedDataManager.hvacMode {
            switch(Int(hvacMode)) {
                case 1: // HEAT
                    gradientView.updateGradientColor(sharedDataManager.gradientValue(sharedDataManager.rgbHeat.0, green: sharedDataManager.rgbHeat.1, blue: sharedDataManager.rgbHeat.2))
                case 2: // COOL
                    gradientView.updateGradientColor(sharedDataManager.gradientValue(sharedDataManager.rgbCool.0, green: sharedDataManager.rgbCool.1, blue: sharedDataManager.rgbCool.2))
                case 4: // OFF
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
            saveData()
        }
    }
    
    func showOrHideLeafImage() {
        
        sharedDataManager.leafHidden! == true ? (leafImageView.hidden = false) : (leafImageView.hidden = true)
    }
    
    // MARK: USER INTERACTION FUNCTIONS
    
    // Main button tapped
    @IBAction func mainButtonTapped(sender: UIButton) {
        
        UIView.animateWithDuration(0.2, delay: 0.1, options: .CurveEaseOut, animations: {
            switch self.menuButtonIsActive {
            case false:
                self.menuButtons.frame.origin.y -= self.menuButtons.frame.height * 2.5
            case true:
                self.menuButtons.frame.origin.y += self.menuButtons.frame.height * 2.5
            }
        }) { (true) in
            print(self.menuButtonIsActive)
            self.menuButtonIsActive = !self.menuButtonIsActive
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
            
            // Save user data
            saveData()
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
    
    func displayNoThermostat(notification: NSNotification) {
        
        let alertView = UIAlertController(title: "Server Error", message: "No thermostat found!", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            let vc = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewControllerWithIdentifier("SignIn") as! NestConnectViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func noInternetConnection(notification: NSNotification) {
        
        let alertView = UIAlertController(title: "Server Error", message: "Internet connection FAILED", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            let vc = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewControllerWithIdentifier("SignIn") as! NestConnectViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
}