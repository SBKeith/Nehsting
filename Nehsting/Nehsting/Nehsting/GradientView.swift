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
    let sharedDataManager = SharedDataSingleton.sharedDataManager
    
    let gradientLayer = CAGradientLayer()
    
    var cgColor1: CGColor?
    var cgColor2: CGColor?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        cgColor1 = sharedDataManager.cgColor1
        cgColor2 = sharedDataManager.cgColorNeutral
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        gradientLayer.frame = bounds
        
        if let hvacMode: UInt = sharedDataManager.hvacMode {
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

        if let hvacMode: UInt = sharedDataManager.hvacMode {
            switch(Int(hvacMode)) {
                case 1: // HEAT
                    switch(setting) {
                        case "INCREASE":
                            sharedDataManager.rgbHeat.1 -= sharedDataManager.heatTempDifferential_1
                            sharedDataManager.rgbHeat.2 -= sharedDataManager.heatTempDifferential_2
                            updateGradientColor(sharedDataManager.gradientValue(sharedDataManager.rgbHeat.0, green: sharedDataManager.rgbHeat.1, blue: sharedDataManager.rgbHeat.2))
                        case "DECREASE":
                            sharedDataManager.rgbHeat.1 += sharedDataManager.heatTempDifferential_1
                            sharedDataManager.rgbHeat.2 += sharedDataManager.heatTempDifferential_2
                            updateGradientColor(sharedDataManager.gradientValue(sharedDataManager.rgbHeat.0, green: sharedDataManager.rgbHeat.1, blue: sharedDataManager.rgbHeat.2))
                        default: break
                    }
                case 2: // COOL
                    switch(setting) {
                        case "INCREASE":
                            sharedDataManager.rgbCool.2 += sharedDataManager.coolTempDifferential_3
                            sharedDataManager.rgbCool.1 += sharedDataManager.coolTempDifferential_1
                            sharedDataManager.rgbCool.0 += sharedDataManager.coolTempDifferential_2
                            updateGradientColor(sharedDataManager.gradientValue(sharedDataManager.rgbCool.0, green: sharedDataManager.rgbCool.1, blue: sharedDataManager.rgbCool.2))
                        case "DECREASE":
                            sharedDataManager.rgbCool.2 -= sharedDataManager.coolTempDifferential_3
                            sharedDataManager.rgbCool.1 -= sharedDataManager.coolTempDifferential_1
                            sharedDataManager.rgbCool.0 -= sharedDataManager.coolTempDifferential_2
                            updateGradientColor(sharedDataManager.gradientValue(sharedDataManager.rgbCool.0, green: sharedDataManager.rgbCool.1, blue: sharedDataManager.rgbCool.2))
                        default: break
                    }
                default: break
            }
        }
    }
}