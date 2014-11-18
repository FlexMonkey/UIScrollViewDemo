//
//  Extensions.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 17/11/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit
import Foundation

extension UIColor
{
    class func colorFromFloats(#redComponent: Float, greenComponent: Float, blueComponent: Float) -> UIColor
    {
        return UIColor(red: CGFloat(redComponent), green: CGFloat(greenComponent), blue: CGFloat(blueComponent), alpha: 1.0)
    }

    class func colorFromDoubles(#redComponent: Double, greenComponent: Double, blueComponent: Double) -> UIColor
    {
        return UIColor(red: CGFloat(redComponent), green: CGFloat(greenComponent), blue: CGFloat(blueComponent), alpha: 1.0)
    }
    
    class func colorFromNSNumbers(#redComponent: NSNumber, greenComponent: NSNumber, blueComponent: NSNumber) -> UIColor
    {
        return UIColor(red: CGFloat(redComponent), green: CGFloat(greenComponent), blue: CGFloat(blueComponent), alpha: 1.0)
    }
    
    func multiply(value: Double) -> UIColor
    {
        let newRed = CGFloat(getRGB().redComponent * Float(value))
        let newGreen = CGFloat(getRGB().greenComponent * Float(value))
        let newBlue = CGFloat(getRGB().blueComponent * Float(value))
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    func getRGB() -> (redComponent: Float, greenComponent: Float, blueComponent: Float)
    {
        let colorRef = CGColorGetComponents(self.CGColor);
        
        println("\(self.CGColor) -- \(Float(colorRef[0]))  \(Float(colorRef[1]))  \(Float(colorRef[2]))")
        
        let redComponent = Float(colorRef[0])
        let greenComponent = Float(colorRef[1])
        let blueComponent = Float(colorRef[2]) 
        
        return (redComponent: redComponent, greenComponent: greenComponent, blueComponent: blueComponent)
    }
    
    func getHex() -> String
    {
        var returnString = ""
        
        let rgb = self.getRGB()
        
        let red = NSString(format: "%02X", Int(rgb.redComponent * 255))
        let green = NSString(format: "%02X", Int(rgb.greenComponent * 255))
        let blue = NSString(format: "%02X", Int(rgb.blueComponent * 255))
        
        return red + green + blue
    }
    
    func makeDarker() -> UIColor
    {
        let red = getRGB().redComponent * 0.9
        let green = getRGB().greenComponent * 0.9
        let blue = getRGB().blueComponent * 0.9
        
        return UIColor.colorFromFloats(redComponent: red, greenComponent: green, blueComponent: blue)
    }
    
    func makeLighter() -> UIColor
    {
        let red = min(getRGB().redComponent * 1.1, 1.0)
        let green = min(getRGB().greenComponent * 1.1, 1.0)
        let blue = min(getRGB().blueComponent * 1.1, 1.0)
        
        return UIColor.colorFromFloats(redComponent: red, greenComponent: green, blueComponent: blue)
    }
    
}
