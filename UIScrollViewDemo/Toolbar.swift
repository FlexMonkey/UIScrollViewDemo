//
//  Toolbar.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 03/10/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//
// Thanks to http://makeapppie.com/2014/08/30/the-swift-swift-tutorials-adding-modal-views-and-popovers/

import Foundation
import UIKit

class Toolbar: UIControl
{
    var numberButton: UIBarButtonItem!
    var operatorButton: UIBarButtonItem!
    
    let numericOperators = [NodeOperators.Add.rawValue, NodeOperators.Subtract.rawValue, NodeOperators.Multiply.rawValue, NodeOperators.Divide.rawValue, NodeOperators.Squareroot.rawValue]
    let colorOperators = [NodeOperators.Color.rawValue, NodeOperators.HSLColor.rawValue, NodeOperators.ColorMultiply.rawValue]
    
    let buttons: [[String]]!
    
    let categorySegmentedControl = UISegmentedControl(items: [SegmentedControlItems.Number.rawValue, SegmentedControlItems.Operator.rawValue, SegmentedControlItems.ColorFunctions.rawValue])
    var operatorsSegmentedControl = UISegmentedControl(items: [])
    let valueSlider = UISlider(frame: CGRectZero)

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        buttons = [[], numericOperators, colorOperators]
        
        categorySegmentedControl.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        categorySegmentedControl.tintColor = UIColor.whiteColor()
        categorySegmentedControl.alpha = 0.95
        
        addSubview(categorySegmentedControl)
        
        categorySegmentedControl.addTarget(self, action: "categorySegmentedControlChangeHandler", forControlEvents: UIControlEvents.ValueChanged)
   
        valueSlider.addTarget(self, action: "valueSliderChangeHandler", forControlEvents: UIControlEvents.ValueChanged)
        
        alpha = 0
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview()
    {
        numberButton = UIBarButtonItem(title: "\(NodeTypes.Number.rawValue)", style: UIBarButtonItemStyle.Plain, target: self, action: "typeButtonHandler:")
        operatorButton = UIBarButtonItem(title: "\(NodeTypes.Operator.rawValue)", style: UIBarButtonItemStyle.Plain, target: self, action: "typeButtonHandler:")
        
        NodesPM.addObserver(self, selector: "selectedNodeChange", notificationType: .NodeSelected)
        NodesPM.addObserver(self, selector: "selectedNodeChange", notificationType: .NodeUpdated)
    }
    
    var categoryIndex: Int = -1
    {
        didSet
        {
            if categoryIndex != oldValue
            {
                operatorsSegmentedControl.removeFromSuperview()
                
                operatorsSegmentedControl = UISegmentedControl(items: buttons[categoryIndex])
                addSubview(operatorsSegmentedControl)
                
                operatorsSegmentedControl.addTarget(self, action: "operatorsSegmentedControlChangeHandler", forControlEvents: UIControlEvents.ValueChanged)
                
                operatorsSegmentedControl.layer.borderColor = UIColor.blueColor().CGColor
                operatorsSegmentedControl.layer.borderWidth = 1
                operatorsSegmentedControl.layer.backgroundColor = UIColor.whiteColor().CGColor
                // operatorsSegmentedControl.tintColor = UIColor.whiteColor()
                operatorsSegmentedControl.alpha = 0.95
                operatorsSegmentedControl.frame = CGRect(x: 0, y: 39, width: frame.width, height: 41)
                
                if categoryIndex == 0
                {
                    addSubview(valueSlider)
                    valueSlider.frame = CGRect(x: 0, y: 40, width: frame.width, height: 40)
                }
                else
                {
                    valueSlider.removeFromSuperview()
                }
                
                categorySegmentedControl.selectedSegmentIndex = categoryIndex
            }
        }
    }
    
    func categorySegmentedControlChangeHandler()
    {
        categoryIndex = categorySegmentedControl.selectedSegmentIndex == -1 ? 0 : categorySegmentedControl.selectedSegmentIndex
    }
    
    func operatorsSegmentedControlChangeHandler()
    {
        let index = operatorsSegmentedControl.selectedSegmentIndex
        let selectedOperatorName = [[], numericOperators, colorOperators][categorySegmentedControl.selectedSegmentIndex][index]
        
        if let _selectectedOperator = NodeOperators(rawValue: selectedOperatorName)
        {
            NodesPM.changeSelectedNodeType(NodeTypes.Operator)
            NodesPM.changeSelectedNodeOperator(_selectectedOperator)
        }
    }
    
    func selectedNodeChange()
    {
        selectedNode = NodesPM.selectedNode
        
        let targetAlpha = CGFloat(selectedNode == nil ? 0 : 1)
        UIView.animateWithDuration(NodeConstants.animationDuration, animations: {self.alpha = targetAlpha})
    }
    
    var selectedNode: NodeVO?
    {
        didSet
        {
            if let node = selectedNode
            {
                switch node.nodeType
                {
                    case NodeTypes.Number:
                        valueSlider.setValue(Float(node.value), animated: true)
                        categoryIndex = 0
                    case NodeTypes.Operator:
                        if node.getOutputType() == InputOutputTypes.Numeric
                        {
                           categoryIndex = 1
                        }
                        else if node.getOutputType() == InputOutputTypes.Color
                        {
                            categoryIndex = 2
                        }
                    
                        let currentButtons = buttons[categoryIndex]
                        let operatorIndex = find(currentButtons, node.nodeOperator.rawValue)
                        
                        operatorsSegmentedControl.selectedSegmentIndex = operatorIndex!
                }
            }
        }
    }
    
    func valueSliderChangeHandler()
    {
        NodesPM.changeSelectedNodeValue(Double(valueSlider.value))
    }
    
    override func layoutSubviews()
    {
        categorySegmentedControl.frame = CGRect(x: 0, y: 0, width: frame.width, height: 40).rectByInsetting(dx: -3, dy: 0)

        operatorsSegmentedControl.frame = CGRect(x: 0, y: 39, width: frame.width, height: 41).rectByInsetting(dx: -3, dy: 0)
        valueSlider.frame = CGRect(x: 0, y: 39, width: frame.width, height: 41).rectByInsetting(dx: 5, dy: 0)
    }
    
    class func getOperatorsForSegmentedControlItem(controlItem: SegmentedControlItems) -> [NodeOperators]
    {
        var returnOperators = [NodeOperators.Null]
        
        switch controlItem
        {
            case .Number:
                returnOperators = [NodeOperators.Null]
            case .Operator:
                returnOperators = [NodeOperators.Add, NodeOperators.Subtract, NodeOperators.Multiply, NodeOperators.Divide, NodeOperators.Squareroot]
            case .ColorFunctions:
                returnOperators = [NodeOperators.Color, NodeOperators.HSLColor, NodeOperators.ColorMultiply]
        }
        
        return returnOperators
    }
}

enum SegmentedControlItems: String
{
    case Number = "Number"
    case Operator = "Operator"
    case ColorFunctions = "Color Functions"
}