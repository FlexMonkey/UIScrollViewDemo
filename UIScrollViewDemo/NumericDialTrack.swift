//
//  NumericDialTrack.swift
//  NumericDial
//
//  Created by Simon Gladman on 05/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class NumericDialTrack: CAShapeLayer
{
    weak var numericDial: NumericDial?

    final func drawValueCurve()
    {
        if let value = numericDial?.currentValue
        {
            strokeColor = UIColor.blueColor().CGColor
            lineWidth = 30
            fillColor = nil
            self.lineCap = "round"
            
            let angle : CGFloat = -135 + 270 * CGFloat(value)
            let centre = min(frame.width, frame.height) / 2.0
            let radius = centre - 20
            
            let valuePath = UIBezierPath(arcCenter: CGPoint(x: centre, y: centre), radius: radius, startAngle: 135 * CGFloat(M_PI)/180, endAngle: (angle - 90) * CGFloat(M_PI)/180, clockwise: true)
            
            
       
            path = valuePath.CGPath
            
            /*
            let trackPath = UIBezierPath(arcCenter: CGPoint(x: centre, y: centre), radius: radius, startAngle: 135 * CGFloat(M_PI)/180, endAngle: 45 * CGFloat(M_PI)/180, clockwise: true)

            // outer path
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextAddPath(ctx, trackPath.CGPath)
            CGContextSetStrokeColorWithColor(ctx, UIColor.blueColor().CGColor)
            CGContextSetLineWidth(ctx, 40)
            CGContextStrokePath(ctx)
            
            // inner path
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextAddPath(ctx, trackPath.CGPath)
            CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
            CGContextSetLineWidth(ctx, 35)
            CGContextStrokePath(ctx)
            
            let valuePath = UIBezierPath(arcCenter: CGPoint(x: centre, y: centre), radius: radius, startAngle: 135 * CGFloat(M_PI)/180, endAngle: (angle - 90) * CGFloat(M_PI)/180, clockwise: true)
            
            // value path
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextAddPath(ctx, valuePath.CGPath)
            CGContextSetStrokeColorWithColor(ctx, UIColor.blueColor().CGColor)
            CGContextSetLineWidth(ctx, 30)
            CGContextStrokePath(ctx)
            
            CGContextSetShadowWithColor(ctx, CGSize(width: 0.0, height: 0.0), 5.0, UIColor.grayColor().CGColor)
            */
        }
    }
}
