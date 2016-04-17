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
    let value = Values()
    
    var cgColorHeat: CGColor = UIColor(red: 255.0/255, green: 113.0/255, blue: 0.0, alpha: 1.0).CGColor
    var cgColorCool: CGColor = UIColor(red: 0.0/255, green: 30.0/255, blue: 140.0/255, alpha: 1.0).CGColor
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        gradientLayer.frame = bounds
        
        settings.stringForKey("temp")! == "Heat" ? (gradientLayer.colors = [cgColorHeat, temp.cgColorNeutral]) : (gradientLayer.colors = [temp.cgColorNeutral,cgColorCool])
        
        gradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer)
    }
    
    func updateGradientColor() {
        
        self.cgColorHeat = settings.objectForKey("cgColorHeat")! as! CGColor
        self.cgColorCool = settings.objectForKey("cgColorCool")! as! CGColor
        setNeedsDisplay()
    }
}

