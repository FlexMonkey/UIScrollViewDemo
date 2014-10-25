//
//  NodeVO.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 29/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import CoreGraphics

class NodeVO: Equatable
{
    let uuid = NSUUID().UUIDString
    let maxInputNodeCount: Int = 8
    
    var name: String
    var position: CGPoint
    var inputNodes: [NodeVO?]
    
    var nodeType: NodeTypes
    var nodeOperator: NodeOperators
    var value : Double = 0
    
    init(name: String, position: CGPoint)
    {
        self.name = name
        self.position = position
        
        self.nodeType = .Number
        self.nodeOperator = .Null
        
        inputNodes = [NodeVO?](count: maxInputNodeCount, repeatedValue: nil)
    }
    
    final func updateValue()
    {
        if let inputNodeOne = inputNodes[0]
        {
            if let inputNodeTwo = inputNodes[1]
            {
                switch nodeOperator
                {
                    case .Null:
                        value = 0
                    case  .Add:
                        value = inputNodeOne.value + inputNodeTwo.value
                    case .Subtract:
                        value = inputNodeOne.value - inputNodeTwo.value
                    case .Multiply:
                        value = inputNodeOne.value * inputNodeTwo.value
                    case .Divide:
                        value = inputNodeOne.value / inputNodeTwo.value
                    case .Squareroot:
                        value = sqrt(inputNodeOne.value)
                }
            }
        }
    }
    
    final func getInputCount() -> Int
    {
        var returnValue: Int = 0
        
        if nodeType == NodeTypes.Operator
        {
            switch nodeOperator
            {
                case .Null:
                    returnValue = 0
                case  .Add:
                    returnValue = 2
                case .Subtract, .Multiply, .Divide:
                    returnValue = 2
                case .Squareroot:
                    returnValue = 1
            }
        }
    
        return returnValue
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
    case Squareroot = "sqrt"
}

func == (left: NodeVO, right: NodeVO) -> Bool
{
    return left.uuid == right.uuid
}