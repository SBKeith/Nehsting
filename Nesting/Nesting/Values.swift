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
    
    static let sharedValues = Values()
    static let sharedTempStruct = Values.temperatureSettings()
    
    // MARK: - DATA STRUCTS
    
    struct data {
        
        let dataArray = [["date":"September 4, 2016", "temp": 75],
                         ["date":"October 8, 2016",   "temp": 70],
                         ["date":"November 7, 2016",  "temp": 73]
        ]
    }
    
    struct temperatureSettings {
        var settingTitle: temperatureType?
        var power = temperatureType?()
        var currentTempHeat: Int?
        var currentTempCool: Int?
        var displayCurrentTemp: Int?

        enum temperatureType: String {
            case heat = "Heat"
            case cool = "Cool"
            case on   = "ON"
            case off  = "OFF"
        }
        
        // GRADIENT VALUES
        
        var rgbHeat: (CGFloat, CGFloat, CGFloat) = (255.0, 113.0, 0.0)
        var rgbCool: (CGFloat, CGFloat, CGFloat) = (0.0, 30.0, 140.0)
        
        // Variables for heat / cool
        var cgColor1 = UIColor(red: 255/255, green: 113/255, blue: 0/255, alpha: 1).CGColor
        
        // Constant 2nd gradient color
        let cgColorNeutral = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0).CGColor
        
        // Derive gradient value
        func gradientValue(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGColor {
            
            return UIColor(red: red/255, green: green/255, blue: blue/255, alpha:1.0).CGColor
        }
    }
    
    // MARK: - CONSTANTS
    
    // NSUserDefaults
    let settings = NSUserDefaults.standardUserDefaults()
    
    // Thermostat max and min constants
    let kMAXTEMP = 90
    let kMINTEMP = 50
    
    // Values that are responsible for increasing / decreasing gradient color values
    let tempDifferential_1: CGFloat = 10.0
    let tempDifferential_2: CGFloat = 30.0
    
    // MARK: - VARIABLES
    
    // Parsed value for finger drag
    var valueParser = 0
}