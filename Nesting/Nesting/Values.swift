//
//  PlaceHolderData.swift
//  Nesting
//
//  Created by Keith Kowalski on 3/30/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation
import UIKit

class Values {
    
    // MARK: - DATA STRUCTS
    
    struct data {
        
        let dataArray = [["date":"September 4, 2016", "temp": 75],
                         ["date":"October 8, 2016",   "temp": 70],
                         ["date":"November 7, 2016",  "temp": 73]
        ]
    }
    
    enum temperatureType: String {
        case heat = "Heat"
        case cool = "Cool"
        case on   = "ON"
        case off  = "OFF"
    }
    
    struct temperatureSettings {
        var settingTitle: temperatureType?
        var currentTemperature = 75
        let cgColorNeutral: CGColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0).CGColor
    }
    
    func gradientValue(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha:1.0).CGColor
    }
    
    // MARK: - CONSTANTS
    
    // NSUserDefaults
    let settings = NSUserDefaults.standardUserDefaults()
    
    // Thermostat max and min constants
    let kMAXTEMP = 90
    let kMINTEMP = 50
    
    // Values that are responsible for increasing / decreasing gradient color values
    let tempDifferential_1: CGFloat = 10.0
    let tempDifferential_2: CGFloat = 20.0
    
    // MARK: - VARIABLES
    
    // Power
    var power: temperatureType?
    
    // Parsed value for finger drag
    var valueParser = 0
}