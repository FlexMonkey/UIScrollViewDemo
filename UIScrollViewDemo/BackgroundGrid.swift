//
//  BackgroundGrid.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 28/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class BackgroundGrid: CAShapeLayer
{
    final func drawGrid()
    {
        let hGap = Int(frame.width / 50)
        let vGap = Int(frame.height / 50)
        
        var gridPath = UIBezierPath()
        
        for i in 0...50
        {
            gridPath.moveToPoint(CGPoint(x: i * hGap, y: 0))
            gridPath.addLineToPoint((CGPoint(x: i * hGap, y: Int(frame.height))))
            
            gridPath.moveToPoint(CGPoint(x: 0, y: i * vGap))
            gridPath.addLineToPoint((CGPoint(x: Int(frame.width), y: i * vGap)))
        }
        
        strokeColor = UIColor.whiteColor().CGColor
        lineWidth = 1
        
        path = gridPath.CGPath
    }
}
