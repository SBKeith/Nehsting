//
//  GradientView.swift
//  Nesting
//
//  Created by Keith Kowalski on 4/8/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class GradientView: UIView {

    let gradientLayer = CAGradientLayer()
    let settings = NSUserDefaults.standardUserDefaults()
    let temp = Values.temperatureSettings()

    var cgColor1 = UIColor(red: 205/255, green: 122/255, blue: 42/255, alpha: 1).CGColor
    var cgColor2 = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1).CGColor
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        print(cgColor1)
        
        
        gradientLayer.frame = bounds
        settings.stringForKey("temp") == "Heat" ? (gradientLayer.colors = [cgColor1, cgColor2]) : (gradientLayer.colors = [cgColor2, cgColor1])
        gradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer)
    }
    
    func updateGradientColor(cgColor1: CGColor, cgColor2: CGColor) {
        
        self.cgColor1 = cgColor1
        self.cgColor2 = cgColor2
                
        setNeedsDisplay()
    }
}

