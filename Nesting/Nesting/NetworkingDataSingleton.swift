//
//  NetworkingData.swift
//  Nesting
//
//  Created by Keith Kowalski on 4/21/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation
import NestSDK
import UIKit

class NetworkingDataSingleton {
    
    static let sharedDataManager = NetworkingDataSingleton()
    
    var dataManager: NestSDKDataManager = NestSDKDataManager()
    var deviceObserverHandles: Array<NestSDKObserverHandle> = []
    var structuresObserverHandle: NestSDKObserverHandle = 0

    // Values Singleton
    let sharedValues = ValuesSingleton.sharedValues
    var sharedTempStruct = ValuesSingleton.sharedTempStruct
    
    var thermostat: NestSDKThermostat?
    
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
                
                self.observeThermostatsWithinStructure(structure, tempHandler: { (temp, hvacMode) in
                    tempClosure(temp: temp, hvacMode: hvacMode)
                })
                
//                print("Structure: \(structure.name)")
            }
            
            tempClosure(temp: nil, hvacMode: nil)
        })
    }
    
    func observeThermostatsWithinStructure(structure: NestSDKStructure, tempHandler: (temp: UInt?, hvacMode: UInt?) -> Void) {
        for thermostatId in structure.thermostats as! [String] {
            let handle = dataManager.observeThermostatWithId(thermostatId, block: {
                thermostat, error in
                
                if (error != nil) {
                    print("Error observing thermostat")
                    
                    tempHandler(temp: nil, hvacMode: nil)
                    
                } else {
                    
                    self.thermostat = thermostat
                    
                    tempHandler(temp: self.sharedTempStruct.displayCurrentTemp, hvacMode: self.sharedTempStruct.hvacMode)

                    self.getAndLocallySetThermostatTemperature()
                }
            })
            
            deviceObserverHandles.append(handle)
        }
    }
    
    func getAndLocallySetThermostatTemperature() {
        
        // Set displayTemp
        self.sharedTempStruct.displayCurrentTemp = self.thermostat?.targetTemperatureF
        
        // Set hvacMode
        self.sharedTempStruct.hvacMode = self.thermostat?.hvacMode.rawValue
        
        // Store temperatures for cooling and heating
        switch(UInt(sharedTempStruct.hvacMode!)) {
            case 1:
                print("SYSTEM IS HEATING\n")
                if let temp = sharedTempStruct.displayCurrentTemp {
                    sharedTempStruct.currentTempHeat = temp
                }
            
            case 2:
                print("SYSTEM IS COOLING\n")
                if let temp = sharedTempStruct.displayCurrentTemp {
                    sharedTempStruct.currentTempCool = temp
                }
            
            case 4:
                print("SYSTEM IS OFF\n")
            
            default:
                break
        }
        
//        print("STORED HEATING TEMP: \(sharedTempStruct.currentTempHeat)")
//        print("STORED COOLING TEMP: \(sharedTempStruct.currentTempCool)")
    }
    
    
    // SET TEMP
    
//        self.thermostat?.targetTemperatureF = newTemp
//        
//        dataManager.setThermostat(self.thermostat, block: { thermostat, error in
//            if error != nil {
//                print("ERROR")
//            } else {
//                print("SUCCESS!")
//            }
//        })
    

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
}