//
//  NestConnectViewController.swift
//  Nesting
//
//  Created by Keith Kowalski on 4/21/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import NestSDK

class NestConnectViewController: UIViewController {

    @IBOutlet weak var nestInfoTextView: UITextView!
    
    var dataManager: NestSDKDataManager = NestSDKDataManager()
    var deviceObserverHandles: Array<NestSDKObserverHandle> = []
    
    var structuresObserverHandle: NestSDKObserverHandle = 0
    
    // Networking Singleton
//    var sharedNetworkStruct = NetworkingData.networkDataStruct()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check authorization
        if (NestSDKAccessToken.currentAccessToken() != nil) {
            observeStructures()
        }
    }
    
    @IBAction func connectWithNestButtonTapped(sender: UIButton) {
        
        let authorizationManager = NestSDKAuthorizationManager()
        authorizationManager.authorizeWithNestAccountFromViewController(self, handler:{
            result, error in
            
            if (error == nil) {
                print("Process error: \(error)")
                
            } else if (result.isCancelled) {
                print("Cancelled")
                
            } else {
                print("Authorized!")
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clean up
        removeObservers()
    }
    
    func observeStructures() {
        // Clean up previous observers
        removeObservers()
        
        // Start observing structures
        structuresObserverHandle = dataManager.observeStructuresWithBlock({
            structuresArray, error in
            
            self.logMessage("Structures updated!")
            
            // Structure may change while observing, so remove all current device observers and then set all new ones
            self.removeDevicesObservers()
            
            // Iterate through all structures and set observers for all devices
            for structure in structuresArray as! [NestSDKStructure] {
                self.logMessage("Structure Name: \(structure.name)!")
                self.observeThermostatsWithinStructure(structure)
            }
        })
    }
    
    func observeThermostatsWithinStructure(structure: NestSDKStructure) {
        for thermostatId in structure.thermostats as! [String] {
            let handle = dataManager.observeThermostatWithId(thermostatId, block: {
                thermostat, error in
                
                if (error != nil) {
                    self.logMessage("Error observing thermostat: \(error)")
                    
                } else {
                    self.logMessage("Thermostat Name: \(thermostat.name) \n Current temperature in F: \(thermostat.ambientTemperatureF) \n HVAC-Mode: \(thermostat.hvacMode.rawValue) \n Target Temp: \(thermostat.targetTemperatureF) \n HVAC-state: \(thermostat.hvacState.rawValue)")
                    
//                    sharedNetworkStruct.structureName = "\(thermostat.name)"
//                    
//                    print(sharedNetworkStruct.structureName)
                }
            })
            
            deviceObserverHandles.append(handle)
        }
    }
    
    func removeObservers() {
        removeDevicesObservers();
        removeStructuresObservers();
    }
    
    func removeDevicesObservers() {
        for (_, handle) in deviceObserverHandles.enumerate() {
            dataManager.removeObserverWithHandle(handle);
        }
        
        deviceObserverHandles.removeAll()
    }
    
    func removeStructuresObservers() {
        dataManager.removeObserverWithHandle(structuresObserverHandle)
    }
    
    func logMessage(message: String) {
        nestInfoTextView.text = nestInfoTextView.text + "\(message)\n"
    }

}
