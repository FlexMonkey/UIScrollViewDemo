//
//  NodeVO.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 29/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import CoreGraphics

class NodeVO
{
    let uuid = NSUUID.UUID().UUIDString
    
    var name: String
    var position: CGPoint
    var inputNodes = [NodeVO]()
    
    var nodeType: NodeTypes
    var nodeOperator: NodeOperators
    var value : Double = 0
    
    init(name: String, position: CGPoint)
    {
        self.name = name
        self.position = position
        
        self.nodeType = .Number
        self.nodeOperator = .Null
    }
}

enum NodeTypes
{
    case Number
    case Operator
}

enum NodeOperators
{
    case Null
    case Add
    case Subtract
    case Divide
    case Multiply
}

func == (left: NodeVO, right: NodeVO) -> Bool
{
    return left.uuid == right.uuid
}