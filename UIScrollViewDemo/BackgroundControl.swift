//
//  BackgroundControl.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 28/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class BackgroundControl: UIControl
{
    let backgroundLayer = BackgroundGrid()
    let curvesLayer = RelationshipCurvesLayer()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)

        backgroundColor = UIColor.blackColor()
        
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = 2
        
        backgroundLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(backgroundLayer)
        backgroundLayer.frame = bounds.rectByInsetting(dx: 0, dy: 0)
        backgroundLayer.drawGrid()
        
        curvesLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(curvesLayer)
        curvesLayer.frame = bounds.rectByInsetting(dx: 0, dy: 0)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "longHoldHandler:")
        addGestureRecognizer(longPress)
        
        addTarget(self, action: "backgroundPress", forControlEvents: UIControlEvents.TouchUpInside)
        
        NodesPM.addObserver(self, selector: "nodeCreated:", notificationType: .NodeCreated)
        NodesPM.addObserver(self, selector: "renderRelationships", notificationType: .RelationshipsChanged)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func backgroundPress()
    {
        NodesPM.relationshipCreationMode = false
    }
    
    func longHoldHandler(recognizer: UILongPressGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.Began
        {
            let gestureLocation = recognizer.locationInView(self)
            
            if self.hitTest(gestureLocation, withEvent: nil) is BackgroundControl
            {
                NodesPM.createNewNode(CGPoint(x: gestureLocation.x - NodeConstants.WidgetWidthCGFloat / 2, y: gestureLocation.y - NodeConstants.WidgetHeightCGFloat / 2))
            }
        }
    }
    
    func renderRelationships()
    {
        curvesLayer.redrawRelationshipCurves()
    }
    
    func nodeCreated(value : AnyObject)
    {
        let newNode = value.object as NodeVO
        
        let originX = Int( newNode.position.x )
        let originY = Int( newNode.position.y )
        
        let nodeWidget = NodeWidget(frame: CGRect(x: originX, y: originY, width: NodeConstants.WidgetWidthInt, height: NodeConstants.WidgetHeightInt), node: newNode)
        
        addSubview(nodeWidget)
    }
}
