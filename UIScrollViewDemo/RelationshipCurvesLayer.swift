//
//  RelationshipCurvesLayer.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 30/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import UIKit

class RelationshipCurvesLayer: CALayer
{
    private var curvesDirty: Bool = false
    var path = UIBezierPath()
    
    func redrawRelationshipCurves()
    {
        drawsAsynchronously = true
        
        curvesDirty = true
        
        setNeedsDisplay()
    }
    
    override func drawInContext(ctx: CGContext!)
    {
        println("draw curves drawInContext")
        
        if curvesDirty
        {
            curvesDirty = false
            
            path.removeAllPoints()
            
            for targetNode in NodesPM.nodes
            {
                for inputNode in targetNode.inputNodes
                {
                    let targetPosition = CGPoint(x: targetNode.position.x + 75, y: targetNode.position.y)
                    let inputPosition = CGPoint(x: inputNode.position.x + 75, y: inputNode.position.y + 150)
                    
                    let controlPointOne = CGPoint(x: targetNode.position.x + 75, y: targetNode.position.y - 50)
                    let controlPointTwo = CGPoint(x: inputNode.position.x + 75, y: inputNode.position.y + 150 + 50)
                    
                    path.moveToPoint(targetPosition)
                    
                    path.addCurveToPoint(inputPosition, controlPoint1: controlPointOne, controlPoint2: controlPointTwo)
                }
            }
            
            CGContextAddPath(ctx, path.CGPath)
            CGContextSetStrokeColorWithColor(ctx, UIColor.blueColor().CGColor)
            CGContextSetLineWidth(ctx, 3)
            CGContextStrokePath(ctx)
        }
    }
    
}