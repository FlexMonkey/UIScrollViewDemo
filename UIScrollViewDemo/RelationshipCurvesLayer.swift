//
//  RelationshipCurvesLayer.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 30/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import UIKit

class RelationshipCurvesLayer: CAShapeLayer
{
    var relationshipCurvesPath = UIBezierPath()
    
    let controlPointVerticalOffset = CGFloat(100)
    
    final func redrawRelationshipCurves()
    {
        strokeColor = UIColor.yellowColor().CGColor
        lineWidth = 3
        fillColor = nil
        
        relationshipCurvesPath.removeAllPoints()
        
        for targetNode in NodesPM.nodes
        {
            for inputNode in targetNode.inputNodes
            {
                let targetPosition = CGPoint(x: targetNode.position.x + NodeConstants.WidgetWidthCGFloat / 2, y: targetNode.position.y)
                let inputPosition = CGPoint(x: inputNode.position.x + NodeConstants.WidgetWidthCGFloat / 2, y: inputNode.position.y + NodeConstants.WidgetHeightCGFloat)
                
                let controlPointOne = CGPoint(x: targetNode.position.x + NodeConstants.WidgetWidthCGFloat / 2, y: targetNode.position.y - controlPointVerticalOffset)
                let controlPointTwo = CGPoint(x: inputNode.position.x + NodeConstants.WidgetWidthCGFloat / 2, y: inputNode.position.y + NodeConstants.WidgetHeightCGFloat + controlPointVerticalOffset)
                
                relationshipCurvesPath.moveToPoint(targetPosition)
                
                relationshipCurvesPath.addCurveToPoint(inputPosition, controlPoint1: controlPointOne, controlPoint2: controlPointTwo)
            }
        }
        
        self.path = relationshipCurvesPath.CGPath
    }
    
    
}