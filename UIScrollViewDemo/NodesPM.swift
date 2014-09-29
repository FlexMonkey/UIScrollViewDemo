//
//  NodesPM.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 29/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import CoreGraphics

struct NodesPM
{
    static var nodes = [NodeVO]()
    static let instance = NodesPM()
    static let notificationCentre = NSNotificationCenter.defaultCenter()
    
    static var selectedNode: NodeVO? = nil
    {
        didSet
        {
            if let node = selectedNode
            {
                let notification = NSNotification(name: NodeNotificationTypes.NodeSelected.toRaw(), object: selectedNode)
            
                notificationCentre.postNotification(notification)
            }
        }
    }
    
    static func createNewNode(origin: CGPoint)
    {
        let newNode = NodeVO(name: "\(nodes.count)", position: origin)
        
        nodes.append(newNode)
        
        let notification = NSNotification(name: NodeNotificationTypes.NodeCreated.toRaw(), object: newNode)
        
        notificationCentre.postNotification(notification)
        
        selectedNode = newNode
    }
}

enum NodeNotificationTypes: String
{
    case NodeSelected = "nodeSelected"
    case NodeCreated = "nodeCreated"
}