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
    
    func updateValue()
    {
        println("update \(name)")
        
        if inputNodes.count >= 2
        {
            let valueOne = inputNodes[0]
            let valueTwo = inputNodes[1]
            
            switch nodeOperator
            {
                case .Null:
                    value = 0
                case  .Add:
                    value = valueOne.value + valueTwo.value
                case .Subtract:
                    value = valueOne.value - valueTwo.value
                case .Multiply:
                    value = valueOne.value * valueTwo.value
                case .Divide:
                    value = valueOne.value / valueTwo.value
            }
        }
    }
}

enum NodeTypes: String
{
    case Number = "Number"
    case Operator = "Operator"
}

enum NodeOperators: String
{
    case Null = ""
    case Add = "+"
    case Subtract = "-"
    case Divide = "÷"
    case Multiply = "×"
}

func == (left: NodeVO, right: NodeVO) -> Bool
{
    return left.uuid == right.uuid
}