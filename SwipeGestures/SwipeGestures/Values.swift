//
//  Constants.swift
//  SwipeGestures
//
//  Created by Keith Kowalski on 4/7/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation
import UIKit

class Values: NSObject {
    
    // MARK: - CONSTANTS
    
    // Thermostat max and min constants
    let kMAXTEMP = 90
    let kMINTEMP = 50
    
    // Static gradient color
    let kLOWERGRADIENT:CGFloat = 238.0 / 255.0
    
    // MARK: - VARIABLES
    
    // system temperature
    var currentTemp = 75

    // Parsed value for finger drag
    var valueParser = 0
    
    // RGB changable values
    var red1: CGFloat = 255.0
    var green1: CGFloat = 113.0
    var blue1: CGFloat = 0.0
}