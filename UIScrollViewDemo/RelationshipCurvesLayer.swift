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
        strokeColor = NodeConstants.curveColor.CGColor
        lineWidth = 2
        fillColor = nil
        
        shadowOffset = CGSize(width: 0, height: 0)
        shadowColor = UIColor.blackColor().CGColor
        shadowOpacity = 0.5
        shadowRadius = 2
        
        drawsAsynchronously = true

        relationshipCurvesPath.removeAllPoints()
        
        for targetNode in NodesPM.nodes.filter({$0 != NodesPM.resizingNode})
        {
            let targetWidgetHeight = CGFloat(targetNode.getInputCount() * NodeConstants.WidgetRowHeight + NodeConstants.WidgetRowHeight)
            let targetWidgetHeightInt = Int(targetWidgetHeight)
            
            let rect = CGRect(x: CGFloat(targetNode.position.x + 1), y: CGFloat(targetNode.position.y + 1), width: NodeConstants.WidgetWidthCGFloat - 2, height: targetWidgetHeight - 2)
            let rectPath = UIBezierPath(roundedRect: rect, cornerRadius: 10)
            relationshipCurvesPath.appendPath(rectPath)
            
            for idx in 0 ..< targetNode.getInputCount()
            {
                let targetY = targetNode.position.y + CGFloat((targetWidgetHeightInt / (targetNode.getInputCount() + 1)) * (idx + 1))
                let targetPosition = CGPoint(x: targetNode.position.x, y: targetY)
                
                drawSemiCircle(relationshipCurvesPath: relationshipCurvesPath, position: targetPosition, clockwise: true)
            }
            
            for (idx : Int, candidateNode: NodeVO?) in enumerate(targetNode.inputNodes)
            {
                if let inputNode = candidateNode
                {
                    let inputWidgetHeight = CGFloat(inputNode.getInputCount() * NodeConstants.WidgetRowHeight + NodeConstants.WidgetRowHeight)
                    let inputWidgetHeightInt = Int(inputWidgetHeight)
                    
                    let inputPosition = CGPoint(x: inputNode.position.x + NodeConstants.WidgetWidthCGFloat, y: inputNode.position.y + inputWidgetHeight / 2)
                    
                    let targetY = targetNode.position.y + CGFloat((targetWidgetHeightInt / (targetNode.getInputCount() + 1)) * (idx + 1))
                    
                    let targetPosition = CGPoint(x: targetNode.position.x, y: targetY)
                    
                    let controlPointOne = CGPoint(x: targetNode.position.x - controlPointVerticalOffset, y: targetY)
                                        
                    let controlPointTwo = CGPoint(x: inputNode.position.x + NodeConstants.WidgetWidthCGFloat + controlPointVerticalOffset, y: inputNode.position.y + inputWidgetHeight / 2)
                    
                    drawSemiCircle(relationshipCurvesPath: relationshipCurvesPath, position: inputPosition, clockwise: false)
                    
                    relationshipCurvesPath.moveToPoint(targetPosition)
                    relationshipCurvesPath.addCurveToPoint(inputPosition, controlPoint1: controlPointOne, controlPoint2: controlPointTwo)
                }
            }
        }
        
        path = relationshipCurvesPath.CGPath
    }

    func drawSemiCircle(#relationshipCurvesPath: UIBezierPath, position: CGPoint, clockwise: Bool)
    {
        let quarterCircle = CGFloat(M_PI) / 2
        let halfCircle = CGFloat(M_PI)
        
        relationshipCurvesPath.moveToPoint(position)
        
        for i in 1...3
        {
            relationshipCurvesPath.addArcWithCenter(position, radius: CGFloat(i * 2), startAngle: quarterCircle, endAngle: halfCircle + quarterCircle, clockwise: clockwise)
        }
    }
    
    
}