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
    var relationshipsDirty = false
    
    required override init()
    {
        super.init()
        
        drawsAsynchronously = false
        
        NodesPM.addObserver(self, selector: "renderRelationships", notificationType: .RelationshipsChanged)
        // NodesPM.addObserver(self, selector: "renderRelationships", notificationType: .NodeMoved)
    }
    
    func renderRelationships()
    {
        nodes = NodesPM.nodes
    }
    
    private var nodes: [NodeVO]!
    {
        didSet
        {
            if !relationshipsDirty
            {
                relationshipsDirty = true
                setNeedsDisplay()
            }
        }
    }
    

    final override func drawInContext(ctx: CGContext!)
    {
        frame = bounds.rectByInsetting(dx: 0, dy: 0)
        
        if relationshipsDirty
        {
            relationshipsDirty = false
            
            println("renderRelationships")
            
            var path = UIBezierPath()
            
            for targetNode in nodes
            {
                for inputNode in targetNode.inputNodes
                {
                    let targetPosition = CGPoint(x: targetNode.position.x + 75, y: targetNode.position.y)
                    let inputPosition = CGPoint(x: inputNode.position.x + 75, y: inputNode.position.y + 150)
                    
                    path.moveToPoint(targetPosition)
                    path.addLineToPoint(inputPosition)
                }
            }
            
            CGContextAddPath(ctx, path.CGPath)
            CGContextSetStrokeColorWithColor(ctx, UIColor.blueColor().CGColor)
            CGContextSetLineWidth(ctx, 3)
            CGContextStrokePath(ctx)
        }
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}