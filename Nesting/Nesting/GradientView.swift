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
    
    var color1 = UIColor(red: 205/255, green: 122/255, blue: 42/255, alpha: 1)
    var color2 = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        gradientLayer.frame = bounds
        
        let cgColor1 = color1.CGColor
        let cgColor2 = color2.CGColor
        
        gradientLayer.colors = [cgColor1, cgColor2]
        gradientLayer.locations = [0.0, 1.0]
        
        layer.addSublayer(gradientLayer)
    }
    
    func updateGradientColor(color1: UIColor, color2: UIColor) {
        
        self.color1 = color1
        self.color2 = color2
        
        setNeedsDisplay()
    }
}

