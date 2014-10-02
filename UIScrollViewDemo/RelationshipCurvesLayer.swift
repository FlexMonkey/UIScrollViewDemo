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
                let targetPosition = CGPoint(x: targetNode.position.x + 75, y: targetNode.position.y)
                let inputPosition = CGPoint(x: inputNode.position.x + 75, y: inputNode.position.y + 150)
                
                let controlPointOne = CGPoint(x: targetNode.position.x + 75, y: targetNode.position.y - 50)
                let controlPointTwo = CGPoint(x: inputNode.position.x + 75, y: inputNode.position.y + 150 + 50)
                
                relationshipCurvesPath.moveToPoint(targetPosition)
                
                relationshipCurvesPath.addCurveToPoint(inputPosition, controlPoint1: controlPointOne, controlPoint2: controlPointTwo)
            }
        }
        
        self.path = relationshipCurvesPath.CGPath
    }
    
    
}