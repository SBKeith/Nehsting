//
//  GradientView.swift
//  SwipeGestures
//
//  Created by Keith Kowalski on 4/5/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class GradientView: UIView {

    let gradientLayer = CAGradientLayer()
    
    var red: CGFloat?
    var green: CGFloat?
    var blue: CGFloat?
    
    var color1: UIColor {
        get{
            return UIColor(red: red!, green: green!, blue: blue!, alpha: 1)
        }
        set {
            self.red = red;, self.green = green; self.blue = blue
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        gradientLayer.frame = bounds
        
        let color1 = UIColor.redColor().CGColor as CGColorRef
        let color2 = UIColor.blueColor().CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        
        gradientLayer.locations = [0.0, 1.0]
        
        layer.addSublayer(gradientLayer)
    }
    
    
}




//    func setGradientColors() {
//
//        let topColor = UIColor(red: red1/255.0, green: green1/255.0, blue: blue1/255.0, alpha: 1)
//        let bottomColor = UIColor(red: red2/255.0, green: green2/255.0, blue: blue2/255.0, alpha: 1)
//
//        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
//        let gradientLocations: [Float] = [0.0, 1.0]
//
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        gradientLayer.colors = gradientColors
//        gradientLayer.locations = gradientLocations
//
//        gradientLayer.frame = self.view.bounds
//        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
//    }


//setNeedsDisplay