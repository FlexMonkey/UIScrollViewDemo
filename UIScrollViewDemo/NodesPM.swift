//
//  NodesPM.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 29/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKIt

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
                        if preferredInputIndex == -1 || preferredInputIndex > targetNode.inputNodes.count - 1 || targetNode.inputNodes.count < 2
                        {
                            targetNode.inputNodes.append(inputNode)
                        }
                        else
                        {
                            targetNode.inputNodes[preferredInputIndex] = inputNode
                        }
        
                        nodeUpdate(targetNode)
                        postNotification(.RelationshipsChanged, payload: nil)
                    }
                }
            }
            preferredInputIndex = -1
        }
        didSet
        {
            postNotification(.NodeSelected, payload: selectedNode)
            
            relationshipCreationMode = false
        }
    }

    static var preferredInputIndex: Int = -1
    
    static func changeSelectedNodeOperator(newOperator: NodeOperators)
    {
        if let node = selectedNode
        {
            node.nodeOperator = newOperator
    
            postNotification(.NodeUpdated, payload: node)
            postNotification(.RelationshipsChanged, payload: nil)
            nodeUpdate(node)
        }
    }
    
    static func changeSelectedNodeType(newType: NodeTypes)
    {
        if let node = selectedNode
        {
            node.nodeType = newType
            
            if node.nodeType == NodeTypes.Operator && node.nodeOperator == NodeOperators.Null
            {
                node.nodeOperator = NodeOperators.Add
            }
            else if node.nodeType == NodeTypes.Number
            {
                node.nodeOperator = NodeOperators.Null
                
                if node.inputNodes.count > 0
                {
                    node.inputNodes = [NodeVO]()
                }
            }
      
            postNotification(.NodeUpdated, payload: node)
            postNotification(.RelationshipsChanged, payload: nil)
            nodeUpdate(node)
        }
    }
    
    static func changeSelectedNodeValue(newValue: Double)
    {
        if let node = selectedNode
        {
            node.value = newValue
  
            postNotification(.NodeUpdated, payload: node)
            nodeUpdate(node)
        }
    }
    
    static var updatedNodes: [NodeVO]!
    
    static func nodeUpdate(node: NodeVO, isRecursive: Bool = false)
    {
        if !isRecursive
        {
            updatedNodes = [node]
        }
      
        node.updateValue();

        // find all operator nodes that are descendants of this node and update their value...
        
        for candidateNode in nodes.filter({!($0 == NodesPM.selectedNode!)})
        {
            var timeInterval = 0.1
            
            for inputNode in candidateNode.inputNodes.filter({($0 == node)})
            {
                if inputNode == node && candidateNode.nodeType == NodeTypes.Operator
                {
                    if updatedNodes.filter({($0 == candidateNode)}).count == 0
                    {
                        updatedNodes.append(candidateNode)
                    }
                    
                    nodeUpdate(candidateNode, isRecursive: true)
                }
            }
        }
        
        if !isRecursive
        {
            // post notifications of all updated nodes
            
            for updatedNode in updatedNodes
            {
                postNotification(.NodeUpdated, payload: updatedNode)
            }
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
            if oldValue != relationshipCreationMode
            {
                postNotification(.RelationshipCreationModeChanged, payload: relationshipCreationMode)
            }
        }
    }
    
    static func removeObserver(observer: AnyObject)
    {
        notificationCentre.removeObserver(observer)
    }
    
    static func addObserver(observer: AnyObject, selector: Selector, notificationType: NodeNotificationTypes)
    {
        notificationCentre.addObserver(observer, selector: selector, name: notificationType.rawValue, object: nil)
    }
    
    static func deleteSelectedNode()
    {
        for node in nodes
        {
            node.inputNodes = node.inputNodes.filter({!($0 == NodesPM.selectedNode!)})
        }

        nodes = nodes.filter({!($0 == NodesPM.selectedNode!)})
      
        postNotification(.NodeDeleted, payload: selectedNode)
        postNotification(.RelationshipsChanged, payload: nil)
        
        selectedNode = nil
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
        
        postNotification(.RelationshipsChanged, payload: nil)
    }
    
    private static func postNotification(notificationType: NodeNotificationTypes, payload: AnyObject?)
    {
        let notification = NSNotification(name: notificationType.rawValue, object: payload)
        
        notificationCentre.postNotification(notification)
    }
}

struct NodeConstants
{
    static let WidgetWidthInt: Int = 240
    static let WidgetHeightInt: Int = 80
    
    static let WidgetWidthCGFloat = CGFloat(WidgetWidthInt)
    static let WidgetHeightCGFloat = CGFloat(WidgetHeightInt)
    
    static let backgroundColor = UIColor.lightGrayColor()
    static let curveColor = UIColor.blueColor()
    
    static let selectedNodeColor = UIColor.blueColor()
    static let unselectedNodeColor = UIColor(red: 0.5, green: 0.5, blue: 1, alpha: 0.9)
    
    static let animationDuration = 0.25
}

enum NodeNotificationTypes: String
{
    case NodeSelected = "nodeSelected"
    case NodeCreated = "nodeCreated"
    case NodeDeleted = "nodeDeleted"
    case DraggingChanged = "draggingChanged"
    case RelationshipCreationModeChanged = "relationshipCreationModeChanged"
    case RelationshipsChanged = "relationshipsChanged"
    case NodeUpdated = "nodeUpdated"
}