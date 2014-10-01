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
        
        backgroundLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(backgroundLayer)
        backgroundLayer.frame = bounds.rectByInsetting(dx: 0, dy: 0)
        backgroundLayer.setNeedsDisplay()
        
        curvesLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(curvesLayer)
        curvesLayer.frame = bounds.rectByInsetting(dx: 0, dy: 0)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "longHoldHandler:")
        addGestureRecognizer(longPress)
        
        NodesPM.addObserver(self, selector: "nodeCreated:", notificationType: .NodeCreated)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func longHoldHandler(recognizer: UILongPressGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.Began
        {
            let gestureLocation = recognizer.locationInView(self)
            
            if self.hitTest(gestureLocation, withEvent: nil) is BackgroundControl
            {
                NodesPM.createNewNode(gestureLocation)
            }
        }
    }
    
    func nodeCreated(value : AnyObject)
    {
        let newNode = value.object as NodeVO
        
        let originX = Int( newNode.position.x - 75 )
        let originY = Int( newNode.position.y - 75 )
        
        let nodeWidget = NodeWidget(frame: CGRect(x: originX, y: originY, width: 150, height: 150), node: newNode)
        
        addSubview(nodeWidget)
    }
}
