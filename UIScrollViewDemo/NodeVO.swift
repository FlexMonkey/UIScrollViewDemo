//
//  NodeVO.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 29/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

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
    var colorValue: UIColor = UIColor.blackColor()
    
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
        if nodeType != NodeTypes.Operator
        {
            return
        }
        
        let inputValueOne = inputNodes[0]?.value ?? 0.0
        let inputValueTwo = inputNodes[1]?.value ?? 0.0
        let inputValueThree = inputNodes[2]?.value ?? 0.0
        
        switch nodeOperator
        {
            case .Null:
                value = 0
            case  .Add:
                var accum: Double = 0.0
                
                for var i: Int = 0; i < getInputCount(); i++
                {
                    if let input = inputNodes[i]
                    {
                        accum += input.value
                    }
                }
                
                value = accum
                
            case .Subtract:
                value = inputValueOne - inputValueTwo
            case .Multiply:
                value = inputValueOne * inputValueTwo
            case .Divide:
                value = inputValueOne / inputValueTwo
            case .Squareroot:
                value = sqrt(inputValueOne)
            case .Color:
                let candidateColor = UIColor.colorFromDoubles(redComponent: inputValueOne, greenComponent: inputValueTwo, blueComponent: inputValueThree)
                colorValue = candidateColor ?? UIColor.blackColor()
            case .HSLColor:
                let candidateColor = UIColor(hue: CGFloat(inputValueOne), saturation: CGFloat(inputValueTwo), brightness: CGFloat(inputValueThree), alpha: 1.0)
                colorValue = candidateColor ?? UIColor.blackColor()
            case .ColorMultiply:
                let inputColor = inputNodes[1]?.colorValue ?? UIColor.blackColor()
                colorValue = inputColor.multiply(inputValueOne)
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
                    returnValue = 5
                case .Subtract, .Multiply, .Divide, .ColorMultiply:
                    returnValue = 2
                case .Squareroot:
                    returnValue = 1
                case .Color, .HSLColor:
                    returnValue = 3
            }
        }
    
        return returnValue
    }
    
    final func getInputTypes() -> [InputOutputTypes]
    {
        var returnArray = [InputOutputTypes.Null]
        
        if nodeType == NodeTypes.Operator
        {
            switch nodeOperator
            {
                case .Null:
                    returnArray = [InputOutputTypes.Null]
                case  .Add, .Subtract, .Multiply, .Divide, .Squareroot, .Color, .HSLColor:
                    returnArray = [InputOutputTypes](count: getInputCount(), repeatedValue: InputOutputTypes.Numeric)
                case .ColorMultiply:
                    returnArray = [InputOutputTypes.Numeric, InputOutputTypes.Color]
            }
        }
        
        return returnArray
    }
    
    final func getOutputType() -> InputOutputTypes
    {
        var returnInputOutputType: InputOutputTypes!
        
        switch nodeType
        {
            case .Number:
                returnInputOutputType = .Numeric
            case .Operator:
                returnInputOutputType = getOutputTypeOfOperator(nodeOperator)
        }
        
        return returnInputOutputType
    }
    
    final func getOutputTypeOfOperator(nodeOperator: NodeOperators) -> InputOutputTypes
    {
        var returnInputOutputType: InputOutputTypes!
        
        switch nodeOperator
        {
            case .Null:
                returnInputOutputType = InputOutputTypes.Null
            case  .Add, .Subtract, .Multiply, .Divide, .Squareroot:
                returnInputOutputType = InputOutputTypes.Numeric
            case .Color, .ColorMultiply, .HSLColor:
                returnInputOutputType = InputOutputTypes.Color
        }
        
        return returnInputOutputType
    }
    
    final func getOutputLabel() -> String
    {
        var valueAsString = ""
        var returnString = ""
        
        if getOutputType() == InputOutputTypes.Numeric
        {
            valueAsString = NSString(format: "%.2f", value) as String
        }
        else if getOutputType() == InputOutputTypes.Color
        {
            valueAsString = colorValue.getHex()
        }
        
        returnString = "\(getOutputType().rawValue) = \(valueAsString)"
        
        return returnString
    }
    
    final func getInputLabelOfIndex(idx: Int) -> String
    {
        var returnString = ""
        
        switch nodeOperator
        {
            case .Color:
                returnString = ["red", "green", "blue"][idx]
            case .ColorMultiply:
                returnString = ["muliplier", "color"][idx]
            case .HSLColor:
                returnString = ["hue", "saturation", "brightness"][idx]
            default:
                returnString = ""
        }
        
        if let inputNode = inputNodes[idx]
        {
            returnString += (returnString == "" ? "" : ": ") + inputNode.getOutputLabel()
        }
        else
        {
            returnString += (returnString == "" ? "" : ": ") + getInputTypes()[idx].rawValue
        }
        
        return returnString
    }
}


enum NodeTypes: String
{
    case Number = "Number"
    case Operator = "Operator"
}

enum InputOutputTypes: String
{
    case Null = ""
    case Numeric = "Number"
    case Color = "Color"
}

enum NodeOperators: String
{
    case Null = ""
    case Add = "+"
    case Subtract = "-"
    case Divide = "÷"
    case Multiply = "×"
    case Squareroot = "sqrt"
    case Color = "RGB Color"
    case HSLColor = "HSL Color"
    case ColorMultiply = "Color Multiply"
}

func == (left: NodeVO, right: NodeVO) -> Bool
{
    return left.uuid == right.uuid
}