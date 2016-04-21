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

class NetworkingData {

    static let sharedNetworkData = NetworkingData.networkDataStruct()
    
    struct networkDataStruct {
        let structureName: String?
        let thermostatName: String?
        let ambientTemperature: UInt?
        var targetTemperatureF: UInt?
        var hvacMode: NestSDKThermostatHVACMode?
        var hvacState: NestSDKThermostatHVACState?
    }
}