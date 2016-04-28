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


typealias NetworkClosure = (error: String) -> Void


class NetworkingDataSingleton {
    
    static let sharedDataManager = NetworkingDataSingleton()
    
    var dataManager: NestSDKDataManager = NestSDKDataManager()
    var deviceObserverHandles: Array<NestSDKObserverHandle> = []
    var structuresObserverHandle: NestSDKObserverHandle = 0

    var targetTemp: UInt?
    var thermostat: NestSDKThermostat?
    
    var sharedStructure: NestSDKStructure?
    
    func observeStructures(tempClosure: (temp: UInt?) -> Void) {
        // Clean up previous observers
        removeObservers()
        
        // Start observing structures
        structuresObserverHandle = dataManager.observeStructuresWithBlock({
            structuresArray, error in
            
            // Structure may change while observing, so remove all current device observers and then set all new ones
            self.removeDevicesObservers()
            
            // Iterate through all structures and set observers for all devices
            for structure in structuresArray as! [NestSDKStructure] {
                
                self.observeThermostatsWithinStructure(structure, tempHandler: { temp in
                    tempClosure(temp: temp)
                })
                
                print("Structure: \(structure.name)")
            }
            
            tempClosure(temp: nil)
        })
    }
    
    func observeThermostatsWithinStructure(structure: NestSDKStructure, tempHandler: (temp: UInt?) -> Void) {
        for thermostatId in structure.thermostats as! [String] {
            let handle = dataManager.observeThermostatWithId(thermostatId, block: {
                thermostat, error in
                
                if (error != nil) {
                    print("Error observing thermostat")
                    
                    tempHandler(temp: nil)
                    
                } else {
                    
                    self.thermostat = thermostat
                    
                    self.targetTemp = thermostat.targetTemperatureF
                    
                    tempHandler(temp: self.targetTemp)
                    
                    print("Structure Location: \(self.thermostat!.name)")
                }
            })
            
            deviceObserverHandles.append(handle)
        }
    }
    
    func setThermostatTemperature(newTemp: UInt) {
        
        self.thermostat?.targetTemperatureF = newTemp
        
        dataManager.setThermostat(self.thermostat, block: { thermostat, error in
            if error != nil {
                print("ERROR")
            } else {
                print("SUCCESS!")
            }
        })
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
}