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
    
    // MARK: - DATA STRUCT
    
    struct data {
        
        let dataArray = [["date":"September 4, 2016", "temp": 75],
                         ["date":"October 8, 2016",   "temp": 70],
                         ["date":"November 7, 2016",  "temp": 73]
        ]
    }
    
    // MARK: - CONSTANTS
    
    // Thermostat max and min constants
    let kMAXTEMP = 90
    let kMINTEMP = 50
    
    // Static gradient color
    let kLOWERGRADIENT:CGFloat = 238.0 / 255.0
    
    // MARK: - VARIABLES
    
    // system temperature (temporary)
    var currentTemp = 75
    
    // Parsed value for finger drag
    var valueParser = 0
    
    // RGB changable values
    var red1: CGFloat = 255.0
    var green1: CGFloat = 113.0
    var blue1: CGFloat = 0.0
}