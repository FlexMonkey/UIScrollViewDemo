//
//  Node.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 28/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class NodeWidget: UIControl, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate
{
    var node: NodeVO!
    
    let operatorLabel = UILabel(frame: CGRectZero)
    let outputLabel = UILabel(frame: CGRectZero)
    let colorSwatch = UIControl(frame: CGRectZero)
    
    var previousPanPoint = CGPointZero
    var inputLabels = [UILabel]()
    
    required init(frame: CGRect, node: NodeVO)
    {
        super.init(frame: frame)
        
        self.node = node
        
        self.clipsToBounds = true
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
        
        setUpPersistentLabels()
        populateLabels()
        addSubview(operatorLabel)
        addSubview(outputLabel)
        addSubview(colorSwatch)
        
        let pan = UIPanGestureRecognizer(target: self, action: "panHandler:")
        pan.delegate = self
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
    
    func setUpPersistentLabels()
    {
        operatorLabel.textAlignment = NSTextAlignment.Center
        operatorLabel.layer.backgroundColor = UIColor.whiteColor().CGColor
        operatorLabel.alpha = 0.75
        operatorLabel.layer.cornerRadius = 5
        operatorLabel.textColor = UIColor.blueColor()
        operatorLabel.font = UIFont.boldSystemFontOfSize(20)
        operatorLabel.adjustsFontSizeToFitWidth = true
        
        outputLabel.textAlignment = NSTextAlignment.Right
        outputLabel.textColor = UIColor.whiteColor()
        outputLabel.font = UIFont.boldSystemFontOfSize(20)
        outputLabel.adjustsFontSizeToFitWidth = true
        
        colorSwatch.layer.borderColor = UIColor.blueColor().CGColor
        colorSwatch.layer.cornerRadius = 10
        colorSwatch.layer.borderWidth = 2
    }
    
    func fadeInComplete(value: Bool)
    {
        if value
        {
            frame.offset(dx: 0, dy: 0);
            
            NodesPM.moveSelectedNode(CGPoint(x: frame.origin.x, y: frame.origin.y))
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
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
                    enableLabelsAsButtons()
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
            
                enableLabelsAsButtons()
                setWidgetColors()
            }
        }
    }
    
    func enableLabelsAsButtons()
    {
        for (idx: Int, inputLabel: UILabel) in enumerate(inputLabels)
        {
            if relationshipCreationCandidate && NodesPM.relationshipCreationMode
            {
                let isValidInput = node.getInputTypes()[idx] == NodesPM.selectedNode?.getOutputType()
                
                inputLabel.enabled = isValidInput
                
                inputLabel.textColor = UIColor.blueColor()
                inputLabel.layer.borderWidth = 1
                inputLabel.layer.cornerRadius = 5
                inputLabel.layer.borderColor = UIColor.blueColor().CGColor
                inputLabel.layer.backgroundColor = isValidInput ? UIColor.yellowColor().CGColor : UIColor(red: 0.75, green: 0.75, blue: 0.0, alpha: 1.0).CGColor
            }
            else
            {
                inputLabel.enabled = true
                
                inputLabel.textColor = UIColor.whiteColor()
                inputLabel.layer.borderWidth = 0
                inputLabel.layer.backgroundColor = UIColor.clearColor().CGColor
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        
        if NodesPM.relationshipCreationMode && relationshipCreationCandidate
        {
            if NodesPM.zoomScale > 0.75
            {
                var targetIndex = -1
                let touch: UITouch = touches.allObjects[0] as UITouch
                
                for (i: Int, inputLabel: UILabel) in enumerate(inputLabels)
                {
                    let touchLocationInView = touch.locationInView(inputLabel)
                    
                    if inputLabel.enabled && touchLocationInView.x > 0 && touchLocationInView.y > 0 && touchLocationInView.x < inputLabel.frame.width && touchLocationInView.y < inputLabel.frame.height
                    {
                        targetIndex = i
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
            else
            {
                displayInputSelectPopOver()
            }
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

    var targetHeight: CGFloat = 0
    
    func nodeUpdated(value: AnyObject)
    {
        let updatedNode = value.object as NodeVO
        
        if updatedNode == node
        {
            targetHeight = CGFloat(node.getInputCount() * NodeConstants.WidgetRowHeight + (NodeConstants.WidgetRowHeight * 2))
            
            if targetHeight != frame.size.height
            {
                NodesPM.resizingNode = node
            
                UIView.animateWithDuration(NodeConstants.animationDuration, animations: {self.doResize()}, completion: resizeComplete)
            }
            
            populateLabels()
        }
    }
    
    func doResize()
    {
        frame.size.height = targetHeight
        populateLabels()
    }
    
    func resizeComplete(value: Bool)
    {
        NodesPM.resizingNode = nil
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
        
        for i: Int in 0 ..< node.getInputCount()
        {
            let style = node.inputNodes[i] == nil ? UIAlertActionStyle.Default : UIAlertActionStyle.Destructive
            
            let inputSelectAction = UIAlertAction(title: node.getInputLabelOfIndex(i), style: style, handler: inputSelectHandler)
            
            let isValidInput = node.getInputTypes()[i] == NodesPM.selectedNode?.getOutputType()
            inputSelectAction.enabled = isValidInput
            
            alertController.addAction(inputSelectAction)
        }
        
        if let viewController = UIApplication.sharedApplication().keyWindow!.rootViewController
        {
            if let popoverPresentationController = alertController.popoverPresentationController
            {
                popoverPresentationController.sourceRect = CGRect(x: frame.origin.x * NodesPM.zoomScale, y: frame.origin.y * NodesPM.zoomScale, width: frame.width * NodesPM.zoomScale, height: frame.height * NodesPM.zoomScale).rectByOffsetting(dx: -NodesPM.contentOffset.x, dy: -NodesPM.contentOffset.y)
                
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
        if inputLabels.count != node.getInputCount()
        {
            for oldLabel in inputLabels
            {
                oldLabel.removeFromSuperview()
            }
            
            inputLabels = [UILabel]()
            
            for var i: Int = 0; i < node.getInputCount(); i++
            {
                let label = UILabel(frame: CGRect(x: 0, y: i * NodeConstants.WidgetRowHeight + NodeConstants.WidgetRowHeight, width: Int(frame.width), height: NodeConstants.WidgetRowHeight).rectByInsetting(dx: 5, dy: 2))
                
                label.textColor = UIColor.whiteColor()
                label.font = UIFont.boldSystemFontOfSize(20)
                label.adjustsFontSizeToFitWidth = true
                
                addSubview(label)
                inputLabels.append(label)
            }
        }
        
        for var i: Int = 0; i < node.getInputCount(); i++
        {
            let label = inputLabels[i]
            
            label.text = node.getInputLabelOfIndex(i)
        }
        
        if node.nodeType == NodeTypes.Operator && node.getOutputType() == InputOutputTypes.Color
        {
            colorSwatch.frame = CGRect(x: 0, y: NodeConstants.WidgetRowHeight + node.getInputCount() * NodeConstants.WidgetRowHeight, width: NodeConstants.WidgetRowHeight * 2, height: NodeConstants.WidgetRowHeight)
            colorSwatch.alpha = 1
            colorSwatch.backgroundColor = node.colorValue
        }
        else
        {
            colorSwatch.alpha = 0
        }
        
        
        operatorLabel.frame = CGRect(x: 2, y: 0, width: Int(frame.width - 4), height: NodeConstants.WidgetRowHeight)
        operatorLabel.text = node.nodeType == NodeTypes.Operator ? node.nodeOperator.rawValue : node.nodeType.rawValue
        
        outputLabel.frame = CGRect(x: 0, y: NodeConstants.WidgetRowHeight + node.getInputCount() * NodeConstants.WidgetRowHeight, width: Int(frame.width) - 5, height: NodeConstants.WidgetRowHeight)
        outputLabel.textAlignment = NSTextAlignment.Right
        outputLabel.adjustsFontSizeToFitWidth = true
        
        outputLabel.text = node.getOutputLabel()
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
            
            previousPanPoint = recognizer.locationInView(UIApplication.sharedApplication().keyWindow)
            
            NodesPM.isDragging = true
        }
        else if recognizer.state == UIGestureRecognizerState.Changed || recognizer.state == UIGestureRecognizerState.Ended
        {
            let gestureLocation = recognizer.locationInView(UIApplication.sharedApplication().keyWindow)
            
            let deltaX = (gestureLocation.x - previousPanPoint.x) / NodesPM.zoomScale
            let deltaY = (gestureLocation.y - previousPanPoint.y) / NodesPM.zoomScale
            
            let newPosition = CGPoint(x: frame.origin.x + deltaX, y: frame.origin.y + deltaY)
            
            frame.origin.x = newPosition.x
            frame.origin.y = newPosition.y
            
            NodesPM.moveSelectedNode(CGPoint(x: newPosition.x, y: newPosition.y))
            
            previousPanPoint = recognizer.locationInView(UIApplication.sharedApplication().keyWindow)
            
            if recognizer.state == UIGestureRecognizerState.Ended
            {
                NodesPM.isDragging = false
            }
        }
    }
    
}
