//
//  MenuButton.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 06/10/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import UIKit

class MenuButton: UIButton
{
    var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    let deleteAlertAction: UIAlertAction
    let makeNumericAction: UIAlertAction
    let makeOperatorAction: UIAlertAction
    
    override init(frame: CGRect)
    {
        func changeNodeType(value : UIAlertAction!) -> Void
        {
            NodesPM.changeSelectedNodeType(NodeTypes(rawValue: value.title)!)
        }
        
        func deleteSelectedNode(value : UIAlertAction!) -> Void
        {
            NodesPM.deleteSelectedNode()
        }
        
        makeOperatorAction = UIAlertAction(title: NodeTypes.Operator.rawValue, style: UIAlertActionStyle.Default, handler: changeNodeType)
        makeNumericAction = UIAlertAction(title: NodeTypes.Number.rawValue, style: UIAlertActionStyle.Default, handler: changeNodeType)
        deleteAlertAction = UIAlertAction(title: "Delete Selected Node", style: UIAlertActionStyle.Default, handler: deleteSelectedNode)
        
        deleteAlertAction.enabled = false
        makeNumericAction.enabled = false
        makeOperatorAction.enabled = false
        
        alertController.addAction(deleteAlertAction)
        alertController.addAction(makeNumericAction)
        alertController.addAction(makeOperatorAction)
        
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview()
    {
        setTitle("Menu", forState: UIControlState.Normal)
        
        tintColor = UIColor.blueColor()
        
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.backgroundColor = UIColor.blueColor().CGColor
        layer.borderColor = UIColor.whiteColor().CGColor
        
        NodesPM.addObserver(self, selector: "selectedNodeChanged:", notificationType: NodeNotificationTypes.NodeSelected)
        NodesPM.addObserver(self, selector: "selectedNodeChanged:", notificationType: NodeNotificationTypes.NodeUpdated)
    }
    
    func selectedNodeChanged(value: AnyObject)
    {
        if let selectedNode = NodesPM.selectedNode
        {
            deleteAlertAction.enabled = true
            makeNumericAction.enabled = selectedNode.nodeType == NodeTypes.Operator
            makeOperatorAction.enabled = selectedNode.nodeType == NodeTypes.Number
        }
        else
        {
            deleteAlertAction.enabled = false
            makeNumericAction.enabled = false
            makeOperatorAction.enabled = false
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
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
    
}