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

let sharedDataManager = NetworkingDataSingleton()

class NetworkingDataSingleton {
    
    var dataManager: NestSDKDataManager = NestSDKDataManager()
    var deviceObserverHandles: Array<NestSDKObserverHandle> = []
    var structuresObserverHandle: NestSDKObserverHandle = 0

    var targetTemp: UInt?
    
    var sharedStructure: NestSDKStructure?
    
    func observeStructures() {
        // Clean up previous observers
        removeObservers()
        
        // Start observing structures
        structuresObserverHandle = dataManager.observeStructuresWithBlock({
            structuresArray, error in
            
            // Structure may change while observing, so remove all current device observers and then set all new ones
            self.removeDevicesObservers()
            
            // Iterate through all structures and set observers for all devices
            for structure in structuresArray as! [NestSDKStructure] {
                
                self.observeThermostatsWithinStructure(structure)
                
                print("Structure Found: \(self.sharedStructure!.name)")
            }
        })
    }
    
    func observeThermostatsWithinStructure(structure: NestSDKStructure) {
        for thermostatId in structure.thermostats as! [String] {
            let handle = dataManager.observeThermostatWithId(thermostatId, block: {
                thermostat, error in
                
                if (error != nil) {
                    print("Error observing thermostat")
                    
                } else {
                    print("Observing: \(thermostat.name)")
                }
            })
            
            deviceObserverHandles.append(handle)
        }
    }
    
    func setThermostatTemperature(newTemp: UInt) {
        
        // Clean up previous observers
        removeObservers()
        
        // Start observing structures
        structuresObserverHandle = dataManager.observeStructuresWithBlock({
            structuresArray, error in
            
            // Structure may change while observing, so remove all current device observers and then set all new ones
            self.removeDevicesObservers()
            
            // Iterate through all structures and set observers for all devices
            for structure in structuresArray as! [NestSDKStructure] {
                for thermostatId in structure.thermostats as! [String] {
                    let handle = self.dataManager.observeThermostatWithId(thermostatId, block: {
                        thermostat, error in
                        
                        if (error != nil) {
                            print("Error observing thermostat")
                            
                        } else {
                            
                            thermostat.targetTemperatureF = 82
                    
                            self.dataManager.setThermostat(thermostat, block: { thermostat, error in
                                if error != nil {
                                    print("ERROR")
                                }
                                else {
                                    print("SUCCESS!")
                                }
                            })
                            
                        }
                    })
                    
                    self.deviceObserverHandles.append(handle)
                }
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