//
//  GradientView.swift
//  Nesting
//
//  Created by Keith Kowalski on 4/8/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    // Singletons
    let sharedValues = ValuesSingleton.sharedValues
    var sharedTempStruct = ValuesSingleton.sharedTempStruct
    
    let gradientLayer = CAGradientLayer()
    let settings = NSUserDefaults.standardUserDefaults()
    
    var cgColor1: CGColor?
    var cgColor2: CGColor?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        cgColor1 = sharedTempStruct.cgColor1
        cgColor2 = sharedTempStruct.cgColorNeutral
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        gradientLayer.frame = bounds
//        settings.stringForKey("temperature")! == "Heat" ? (gradientLayer.colors = [cgColor1!, cgColor2!]) : (gradientLayer.colors = [cgColor2!, cgColor1!])
        gradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer)
    }
    
    func updateGradientColor(cgColor1: CGColor) {
        
        self.cgColor1 = cgColor1
        setNeedsDisplay()
    }
    
    func adjustGradient(setting: String) {
        
//        switch(sharedValues.settings.stringForKey("temperature")!) {
//            case "Heat":
//                switch(setting) {
//                    case "INCREASE":
//                        sharedTempStruct.rgbHeat.1 -= sharedValues.tempDifferential_1
//                        sharedTempStruct.rgbHeat.2 -= sharedValues.tempDifferential_2
//                        updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbHeat.0, green: sharedTempStruct.rgbHeat.1, blue: sharedTempStruct.rgbHeat.2))
//                        
//                    case "DECREASE":
//                        sharedTempStruct.rgbHeat.1 += sharedValues.tempDifferential_1
//                        sharedTempStruct.rgbHeat.2 += sharedValues.tempDifferential_2
//                        updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbHeat.0, green: sharedTempStruct.rgbHeat.1, blue: sharedTempStruct.rgbHeat.2))
//                        
//                    default: break
//                }
//                
//            case "Cool":
//                switch(setting) {
//                    case "INCREASE":
//                        sharedTempStruct.rgbCool.1 += sharedValues.tempDifferential_1
//                        sharedTempStruct.rgbCool.0 += sharedValues.tempDifferential_2
//                        updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbCool.0, green: sharedTempStruct.rgbCool.1, blue: sharedTempStruct.rgbCool.2))
//                        
//                    case "DECREASE":
//                        sharedTempStruct.rgbCool.1 -= sharedValues.tempDifferential_1
//                        sharedTempStruct.rgbCool.0 -= sharedValues.tempDifferential_2
//                        updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbCool.0, green: sharedTempStruct.rgbCool.1, blue: sharedTempStruct.rgbCool.2))
//                        
//                    default: break
//                }
//            default: break
//            }
    }
}



