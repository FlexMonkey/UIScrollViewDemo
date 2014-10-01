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
    
    private static let notificationCentre = NSNotificationCenter.defaultCenter()
    
    static var selectedNode: NodeVO? = nil
    {
        willSet
        {
            if relationshipCreationMode
            {
                if let targetNode = newValue
                {
                    if let inputNode = selectedNode
                    {
                        targetNode.inputNodes.append(inputNode)
                        postNotification(.RelationshipsChanged, payload: nil)
                    }
                }
            }
        }
        didSet
        {
            if let node = selectedNode
            {
                postNotification(.NodeSelected, payload: node)
            }
            
            relationshipCreationMode = false
        }
    }
    
    static var isDragging: Bool = false
    {
        didSet
        {
            postNotification(.DraggingChanged, payload: isDragging)
        }
    }
    
    static var relationshipCreationMode: Bool = false
    {
        didSet
        {
            postNotification(.RelationshipCreationModeChanged, payload: relationshipCreationMode)
        }
    }
    
    static func addObserver(observer: AnyObject, selector: Selector, notificationType: NodeNotificationTypes)
    {
        notificationCentre.addObserver(observer, selector: selector, name: notificationType.toRaw(), object: nil)
    }
    
    static func createNewNode(origin: CGPoint)
    {
        let newNode = NodeVO(name: "\(nodes.count)", position: origin)
        
        nodes.append(newNode)
        
        postNotification(.NodeCreated, payload: newNode)
        
        selectedNode = newNode
    }
    
    static func moveSelectedNode(position: CGPoint)
    {
        selectedNode?.position = position
        
        // postNotification(.NodeMoved, payload: selectedNode!)
        postNotification(.RelationshipsChanged, payload: nil)
    }
    
    private static func postNotification(notificationType: NodeNotificationTypes, payload: AnyObject?)
    {
        let notification = NSNotification(name: notificationType.toRaw(), object: payload)
        
        notificationCentre.postNotification(notification)
    }
}

enum NodeNotificationTypes: String
{
    case NodeSelected = "nodeSelected"
    case NodeCreated = "nodeCreated"
    // case NodeMoved = "nodeMoved"
    case DraggingChanged = "draggingChanged"
    case RelationshipCreationModeChanged = "relationshipCreationModeChanged"
    case RelationshipsChanged = "relationshipsChanged"
}