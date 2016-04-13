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
        
        var rgbHeatValues: [String: CGFloat] = ["red":255.0/255.0, "green":113.0/255.0, "blue":0.0/255.0]
        var rgbCoolValues: [String: CGFloat] = ["red":0.0/255.0, "green":30.0/255.0, "blue":140.0/255.0]
    }
    
    func gradientValue(rgbDict: [String: CGFloat]) -> CGColor {
        
        return UIColor(red:rgbDict["red"]!, green:rgbDict["green"]!, blue:rgbDict["blue"]!, alpha:1.0).CGColor
    }
    
//    struct temperature {
//        
//        // Initial heat values
//        var hRed:CGFloat = 255.0, hGreen:CGFloat = 113.0, hBlue:CGFloat = 0.0
//        
//        // Initial Cool Values
//        var cRed:CGFloat = 0.0, cGreen:CGFloat = 30.0, cBlue:CGFloat = 140.0
//
//        
//        var heat: CGColor {
//            return UIColor(red: hRed/255, green: hGreen/255, blue: hBlue/255, alpha: 1).CGColor
//        }
//        
//        var cool: CGColor {
//            return UIColor(red: cRed/255, green: cGreen/255, blue: cBlue/255, alpha: 1).CGColor
//        }
//        
//        var neutral: CGColor {
//            return UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1).CGColor
//        }
//    }
    
    // MARK: - CONSTANTS
    
    // Neutral Color for gradients
    let neutralColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0).CGColor
    
    // NSUserDefaults
    let settings = NSUserDefaults.standardUserDefaults()
    
    // Thermostat max and min constants
    let kMAXTEMP = 90
    let kMINTEMP = 50
    
    // Values that are responsible for increasing / decreasing gradient color values
    let tempDifferential_1: CGFloat = 10.0
    let tempDifferential_2: CGFloat = 20.0
    
    // Static gradient color
    let kLOWERGRADIENT:CGFloat = 238.0 / 255.0
    
    // MARK: - VARIABLES
    
    // Power
    var power: temperatureType?
    
    // system temperature (temporary)
//    var currentTemp = 75
    
    // Parsed value for finger drag
    var valueParser = 0
    
    // RGB changable values
    // HEAT
//    var hRed: CGFloat = 255.0
//    var hGreen: CGFloat = 113.0
//    var hBlue: CGFloat = 0.0
//    
//    // COOL
//    var cRed: CGFloat = 0.0
//    var cGreen: CGFloat = 30.0
//    var cBlue: CGFloat = 140.0
}