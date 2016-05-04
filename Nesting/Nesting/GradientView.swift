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
    
    let gradientLayer = CAGradientLayer()
    
    var cgColor1: CGColor?
    var cgColor2: CGColor?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        cgColor1 = ValuesSingleton.sharedValues.tempSettings?.cgColor1
        cgColor2 = ValuesSingleton.sharedValues.tempSettings?.cgColorNeutral
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        gradientLayer.frame = bounds
        
        if let hvacMode = ValuesSingleton.sharedValues.tempSettings?.hvacMode {
            
            print("GOT HERE!!!!")
            
            switch(Int(hvacMode)) {
            case 1:
                (gradientLayer.colors = [cgColor1!, cgColor2!])
            case 2:
                (gradientLayer.colors = [cgColor2!, cgColor1!])
            case 4:
                (gradientLayer.colors = [cgColor2!, cgColor1!])
            default:
                break
            }
        }
        gradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer)
    }
    
    func updateGradientColor(cgColor1: CGColor) {
        
        self.cgColor1 = cgColor1
        setNeedsDisplay()
    } 
    
    func adjustGradient(setting: String) {
        
        if let hvacMode = ValuesSingleton.sharedValues.tempSettings?.hvacMode {
            
            var sharedTempStruct = ValuesSingleton.sharedValues.tempSettings!
            
            switch(Int(hvacMode)) {
                case 1:
                    switch(setting) {
                        case "INCREASE":
                            sharedTempStruct.rgbHeat.1 -= sharedValues.tempDifferential_1
                            sharedTempStruct.rgbHeat.2 -= sharedValues.tempDifferential_2
                            updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbHeat.0, green: sharedTempStruct.rgbHeat.1, blue: sharedTempStruct.rgbHeat.2))
                        case "DECREASE":
                            sharedTempStruct.rgbHeat.1 += sharedValues.tempDifferential_1
                            sharedTempStruct.rgbHeat.2 += sharedValues.tempDifferential_2
                            updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbHeat.0, green: sharedTempStruct.rgbHeat.1, blue: sharedTempStruct.rgbHeat.2))
                        default: break
                    }
                case 2:
                    switch(setting) {
                        case "INCREASE":
                            sharedTempStruct.rgbCool.1 += sharedValues.tempDifferential_1
                            sharedTempStruct.rgbCool.0 += sharedValues.tempDifferential_2
                            updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbCool.0, green: sharedTempStruct.rgbCool.1, blue: sharedTempStruct.rgbCool.2))
                        case "DECREASE":
                            sharedTempStruct.rgbCool.1 -= sharedValues.tempDifferential_1
                            sharedTempStruct.rgbCool.0 -= sharedValues.tempDifferential_2
                            updateGradientColor(sharedTempStruct.gradientValue(sharedTempStruct.rgbCool.0, green: sharedTempStruct.rgbCool.1, blue: sharedTempStruct.rgbCool.2))
                        default: break
                    }
                default: break
            }
        }
    }
}