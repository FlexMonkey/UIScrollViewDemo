//
//  BackgroundGrid.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 28/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class BackgroundGrid: CALayer
{
    override func drawInContext(ctx: CGContext!)
    {
        let hGap = Int(frame.width / 50)
        let vGap = Int(frame.height / 50)
        
        for i in 0...50
        {
            var path = UIBezierPath()
            
            path.moveToPoint(CGPoint(x: i * hGap, y: 0))
            path.addLineToPoint((CGPoint(x: i * hGap, y: Int(frame.height))))
            
            CGContextAddPath(ctx, path.CGPath)
            CGContextSetStrokeColorWithColor(ctx, UIColor.darkGrayColor().CGColor)
            CGContextSetLineWidth(ctx, 3)
            CGContextStrokePath(ctx)
            
            path.moveToPoint(CGPoint(x: 0, y: i * vGap))
            path.addLineToPoint((CGPoint(x: Int(frame.width), y: i * vGap)))
            
            CGContextAddPath(ctx, path.CGPath)
            CGContextSetStrokeColorWithColor(ctx, UIColor.darkGrayColor().CGColor)
            CGContextSetLineWidth(ctx, 3)
            CGContextStrokePath(ctx)
        }
    }
}
