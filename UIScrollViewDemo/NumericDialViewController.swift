//
//  NumericDialViewController.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 09/10/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class NumericDialViewController: UIViewController
{
    let numericDial = NumericDial(frame: CGRect(x: 5, y: 5, width: 300, height: 300))
    var ignoreDialChangeEvents: Bool = false

    override func viewDidLoad()
    {        
        preferredContentSize = CGSize(width: 310, height: 275)
        
        view.addSubview(numericDial)
        
        if let value = NodesPM.selectedNode!.value as Double?
        {
            numericDial.currentValue = value / 100
        }
        
        numericDial.labelFunction = labelFunction
        
        numericDial.addTarget(self, action: "dialChangeHandler:", forControlEvents: .ValueChanged)
        
        NodesPM.addObserver(self, selector: "nodeChangeHandler", notificationType: NodeNotificationTypes.NodeSelected)
        NodesPM.addObserver(self, selector: "nodeChangeHandler", notificationType: NodeNotificationTypes.NodeUpdated)
    }
    
    func labelFunction(value: Double) -> String
    {
        let dialValue = Double(Int(value * 100))
        
        return NSString(format: "%.0f", dialValue)
    }
    
    func nodeChangeHandler()
    {
        if let selectedNode = NodesPM.selectedNode
        {
            let value = selectedNode.value
            
            ignoreDialChangeEvents = true
                
            numericDial.currentValue = value / 100
                
            ignoreDialChangeEvents = false
        }
    }
    
    func dialChangeHandler(numericDial: NumericDial)
    {
        let dialValue = Double(Int(numericDial.currentValue * 100))
        
        if !ignoreDialChangeEvents
        {
            NodesPM.changeSelectedNodeValue(dialValue)
        }
    }
}
