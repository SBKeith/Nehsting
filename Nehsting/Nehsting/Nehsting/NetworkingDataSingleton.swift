//
//  NetworkingData.swift
//  Nesting
//
//  Created by Keith Kowalski on 4/21/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation
import UIKit
import NestSDK

class NetworkingDataSingleton {
    
    // Set singleton for class
    static let sharedNetworkManager = NetworkingDataSingleton()
    
    // Shared Data Singleton
    let sharedDataManager = SharedDataSingleton.sharedDataManager
    
    // Data and structures variables
    var dataManager = NestSDKDataManager()
    var deviceObserverHandles: Array<NestSDKObserverHandle> = []
    var structuresObserverHandle: NestSDKObserverHandle = 0
    
    // Thermostat Values
    var thermostat: NestSDKThermostat?
    
    // Structure Values
    var structureID: NestSDKStructure?
    
    // MARK: STRUCTURES / THERMOSTAT FUNCTIONS

/////////////////////////////////////////////////////////////////////////////////////
////// Find Structure(s)
    func observeStructures(tempClosure: (temp: UInt?, hvacMode: UInt?) -> Void) {
        
        // Clean up previous observers
        removeObservers()
        
        // Start observing structures
        structuresObserverHandle = dataManager.observeStructuresWithBlock({
            structuresArray, error in
            
            // Structure may change while observing, so remove all current device observers and then set all new ones
            self.removeDevicesObservers()
            

            // Iterate through all structures and set observers for all devices
            for structure in structuresArray as! [NestSDKStructure] {
                
                self.structureID = structure
                self.getAndLocallySetStructure()
                
                self.observeThermostatsWithinStructure(structure, tempHandler: { (temp, hvacMode) in
                    tempClosure(temp: temp, hvacMode: hvacMode)
                    NSNotificationCenter.defaultCenter().postNotificationName("hideLoadingScreen", object: nil)
                })
//                print("Structure: \(structure.name)")
            }
            tempClosure(temp: nil, hvacMode: nil)
        })
    }
/////////////////////////////////////////////////////////////////////////////////////
    
/////////////////////////////////////////////////////////////////////////////////////
////// Observe Thermostat(s)
    func observeThermostatsWithinStructure(structure: NestSDKStructure, tempHandler: (temp: UInt?, hvacMode: UInt?) -> Void) {
        
        for thermostatId in structure.thermostats as! [String] {
            
            
            let handle = dataManager.observeThermostatWithId(thermostatId, block: {
                thermostat, error in
                
                if (error != nil) {
                    print("Error observing thermostat")
                    tempHandler(temp: nil, hvacMode: nil)
                } else {
                    self.thermostat = thermostat
                    self.getAndLocallySetThermostatTemperature()
                    
                    tempHandler(temp: self.sharedDataManager.temperature, hvacMode: self.sharedDataManager.hvacMode)
                }
            })
            deviceObserverHandles.append(handle)
        }
    }
/////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////
////// Remove observers functions
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
/////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: HELPER FUNCTIONS
    
    // Get thermostat data and set it
    func getAndLocallySetThermostatTemperature() {
        
        // Set displayTemp
        self.sharedDataManager.temperature = (self.thermostat?.targetTemperatureF)!
        
        // Set hvacMode
        self.sharedDataManager.hvacMode = (self.thermostat?.hvacMode.rawValue)!
        
        // Set leaf icon
        self.sharedDataManager.leafHidden = (self.thermostat?.hasLeaf)!

        
        // Set thermostat name
        self.sharedDataManager.thermostatName = (self.thermostat?.name)!
        
        // Get timestamp for last interaction
        self.sharedDataManager.timeStamp = (self.thermostat?.lastConnection)
    }
    
    
    
    func getAndLocallySetStructure() {
        
        self.sharedDataManager.homeOrAwayStatus = (self.structureID?.away.rawValue)!
    }
    
    // Update thermostat HVAC
    func networkHVACUpdate() {
        
        var errorResult = ""
        
        self.thermostat?.hvacMode = NestSDKThermostatHVACMode(rawValue: sharedDataManager.hvacMode)!
        self.dataManager.setThermostat(self.thermostat, block: { (thermostat, error) in
            
            errorResult = error != nil ? "ERROR" : "SUCCESS"
            
            if errorResult == "ERROR" {
                NSNotificationCenter.defaultCenter().postNotificationName("displayErrorAlert", object: nil)
            }
        })
    }
    
    // Update thermostat temperature
    func networkTemperatureUpdate() {
        
        self.thermostat?.targetTemperatureF = sharedDataManager.temperature
        self.dataManager.setThermostat(self.thermostat, block: { (thermostat, error) in
            
            let errorResult = error != nil ? "ERROR" : "SUCCESS"
            
            if errorResult == "ERROR" {
                NSNotificationCenter.defaultCenter().postNotificationName("displayErrorAlert", object: nil)
            }
        })
    }
    
    // Update structure status
    func structureHomeOrAwayStatusUpdate() {
        
        self.structureID?.away = NestSDKStructureAwayState(rawValue: sharedDataManager.homeOrAwayStatus!)!
        self.dataManager.setStructure(self.structureID, block: { (structure, error) in
            
            let errorResult = error != nil ? "ERROR" : "SUCCESS"
            
            if errorResult == "ERROR" {
                NSNotificationCenter.defaultCenter().postNotificationName("displayErrorAlert", object: nil)
            }
        })
    }
}