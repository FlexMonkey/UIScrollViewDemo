//
//  Node.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 28/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class NodeWidget: UIControl, UIPopoverPresentationControllerDelegate
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
        fatalError("init(coder:) has not been implemented")
    }

    deinit
    {
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
        
        populateLabels()
        addSubview(label)
        
        let pan = UIPanGestureRecognizer(target: self, action: "panHandler:");
        addGestureRecognizer(pan)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "longHoldHandler:")
        addGestureRecognizer(longPress)
     
        NodesPM.addObserver(self, selector: "nodeUpdated:", notificationType: .NodeUpdated)
        NodesPM.addObserver(self, selector: "nodeSelected:", notificationType: .NodeSelected)
        NodesPM.addObserver(self, selector: "nodeUpdated:", notificationType: .NodeCreated)
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
            /*
            let touch = (touches.allObjects[0] as UITouch).locationInView(self)
            NodesPM.preferredInputIndex = touch.x < self.frame.width / 2 ? 0 : 1
            
            // if input count = 1, preferredInputIndex = 1
            // if any inputs are nil, preferredInputIndex = index of first nil
            // otherwise pop up action sheet to allow user to select input...
            
            NodesPM.selectedNode = node
            */
            
            displayInputSelectPopOver()
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
        populateLabels()
    }

    func nodeUpdated(value: AnyObject)
    {
        let updatedNode = value.object as NodeVO
        
        if updatedNode == node
        {
            populateLabels()
        }
    }
    
    func displayInputSelectPopOver()
    {
        var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.message = "Select Input Channel"
        alertController.popoverPresentationController?.delegate = self
        
        func inputSelectHandler(value : UIAlertAction!) -> Void
        {
            var targetIndex: Int = -1
            
            for (idx: Int, action: AnyObject) in enumerate(alertController.actions)
            {
                if action === value
                {
                    targetIndex = idx
                }
            }
            
            if targetIndex != -1
            {
                NodesPM.preferredInputIndex = targetIndex
                NodesPM.selectedNode = node
            }
            else
            {
                NodesPM.relationshipCreationMode = false
            }
        }
        
        for i: Int in 1 ... node.getInputCount()
        {
            let inputSelectAction = UIAlertAction(title: "Input \(i)", style: UIAlertActionStyle.Default, handler: inputSelectHandler)
            
            alertController.addAction(inputSelectAction)
        }
        
        if let viewController = UIApplication.sharedApplication().keyWindow!.rootViewController
        {
            if let popoverPresentationController = alertController.popoverPresentationController
            {
                popoverPresentationController.sourceRect = frame
                popoverPresentationController.sourceView = viewController.view
                
                viewController.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController)
    {
         NodesPM.relationshipCreationMode = false
    }
    
    func populateLabels()
    {
        if node.nodeType == NodeTypes.Operator
        {
            let valueAsString = node.getInputCount() > 1 ? NSString(format: "%.2f", node.value) : "??"
            
            let lhs = node.inputNodes[0] == nil ? "??" : NSString(format: "%.2f", node.inputNodes[0]!.value)
            let rhs = node.inputNodes[1] == nil ? "??" : NSString(format: "%.2f", node.inputNodes[1]!.value)
            
            label.text = "\(lhs) \(node.nodeOperator.rawValue) \(rhs)\n\n\(valueAsString)"
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


