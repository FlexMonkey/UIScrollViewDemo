//
//  Node.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 28/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class NodeWidget: UIControl
{
    var node: NodeVO!
    
    let label: UILabel = UILabel(frame: CGRectZero)
    
    required init(frame: CGRect, node: NodeVO)
    {
        super.init(frame: frame)
        
        self.node = node
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        println("DEINIT!!!")
        
        NodesPM.removeObserver(self)
    }
    
    override func didMoveToSuperview()
    {
        alpha = 0

        layer.borderColor = NodeConstants.curveColor.CGColor
        layer.borderWidth = 2
        layer.cornerRadius = 10
        
        label.frame = bounds.rectByInsetting(dx: 2, dy: 2)
        label.textAlignment = NSTextAlignment.Center

        label.numberOfLines = 0
        
        label.font = UIFont.boldSystemFontOfSize(20)
        
        populateLabel()
        addSubview(label)
        
        let pan = UIPanGestureRecognizer(target: self, action: "panHandler:");
        addGestureRecognizer(pan)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "longHoldHandler:")
        addGestureRecognizer(longPress)
     
        NodesPM.addObserver(self, selector: "populateLabel", notificationType: .NodeUpdated)
        NodesPM.addObserver(self, selector: "nodeSelected:", notificationType: .NodeSelected)
        NodesPM.addObserver(self, selector: "populateLabel", notificationType: .NodeCreated)
        NodesPM.addObserver(self, selector: "relationshipCreationModeChanged:", notificationType: .RelationshipCreationModeChanged)
        NodesPM.addObserver(self, selector: "relationshipsChanged:", notificationType: .RelationshipsChanged)
        
        UIView.animateWithDuration(NodeConstants.animationDuration, animations: {self.alpha = 1}, completion: fadeInComplete)
    }
    
    func fadeInComplete(value: Bool)
    {
        if value
        {
            frame.offset(dx: 0, dy: 0);
            
            NodesPM.moveSelectedNode(CGPoint(x: frame.origin.x, y: frame.origin.y))
        }
    }
    
    // to do - move to PM and prevent circular relationships
    var relationshipCreationCandidate: Bool = false
    {
        didSet
        {
            if NodesPM.relationshipCreationMode
            {
                if relationshipCreationCandidate && !(NodesPM.selectedNode! == node)
                {
                    UIView.animateWithDuration(NodeConstants.animationDuration, animations: {self.backgroundColor = UIColor.yellowColor()})
                    label.textColor = UIColor.blueColor()
                }
                else
                {
                    UIView.animateWithDuration(NodeConstants.animationDuration, animations: {self.alpha = 0.5})
                    enabled = false
                }
            }
            else
            {
                UIView.animateWithDuration(NodeConstants.animationDuration, animations: {self.alpha = 1.0})
                enabled = true
            
                setWidgetColors()
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        if NodesPM.relationshipCreationMode && relationshipCreationCandidate
        {
            let touch = (touches.allObjects[0] as UITouch).locationInView(self)
            NodesPM.preferredInputIndex = touch.x < self.frame.width / 2 ? 0 : 1
            
            NodesPM.selectedNode = node
        }
        else if !NodesPM.relationshipCreationMode
        {
            NodesPM.selectedNode = node
            NodesPM.isDragging = true
        }
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        NodesPM.isDragging = false
    }
    
    func relationshipCreationModeChanged(value : AnyObject)
    {
        let relationshipCreationMode = value.object as Bool
        
        relationshipCreationCandidate = node.nodeType == NodeTypes.Operator
    }
    
    func relationshipsChanged(value: AnyObject)
    {
        populateLabel()
    }

    func populateLabel()
    {
        if node.nodeType == NodeTypes.Operator
        {
            let valueAsString = node.inputNodes.count > 1 ? NSString(format: "%.2f", node.value) : "??"
            
            let lhs = node.inputNodes.count > 0 ? NSString(format: "%.2f", node.inputNodes[0].value) : "??"
            let rhs = node.inputNodes.count > 1 ? NSString(format: "%.2f", node.inputNodes[1].value) : "??"
            
            label.text = "\(lhs) \(node.nodeOperator.toRaw()) \(rhs)\n\n\(valueAsString)"
        }
        else
        {
            let valueAsString = NSString(format: "%.2f", node.value);
            
            label.text = "\(valueAsString)"
        }
    }
    
   
    func nodeSelected(value: AnyObject?)
    {
        setWidgetColors()
    }
    
    func setWidgetColors()
    {
        var isSelected = !(NodesPM.selectedNode == nil)
        
        if isSelected
        {
            isSelected = NodesPM.selectedNode! == node 
        }
        
        let targetColor = isSelected ? NodeConstants.selectedNodeColor : NodeConstants.unselectedNodeColor
        
        UIView.animateWithDuration(NodeConstants.animationDuration, animations: {self.backgroundColor = targetColor})
        
        label.textColor = isSelected ? UIColor.whiteColor() : UIColor.whiteColor()
    }
    
    func longHoldHandler(recognizer: UILongPressGestureRecognizer)
    {
        NodesPM.relationshipCreationMode = true
    }
    
    func panHandler(recognizer: UIPanGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.Began
        {
            if !(NodesPM.selectedNode! == node)
            {
                NodesPM.selectedNode = node
            }
            
            NodesPM.isDragging = true
        }
        else if recognizer.state == UIGestureRecognizerState.Changed || recognizer.state == UIGestureRecognizerState.Ended
        {
            let gestureLocation = recognizer.locationInView(self)
            
            frame.offset(dx: gestureLocation.x - frame.width / 2, dy: gestureLocation.y - frame.height / 2)
            
            NodesPM.moveSelectedNode(CGPoint(x: frame.origin.x, y: frame.origin.y))
            
            if recognizer.state == UIGestureRecognizerState.Ended
            {
                NodesPM.isDragging = false
            }
        }
    }
    
}


