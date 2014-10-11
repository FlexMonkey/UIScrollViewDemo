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

class Toolbar: UIToolbar, UIPopoverControllerDelegate
{
    var numberButton: UIBarButtonItem!
    var operatorButton: UIBarButtonItem!
    
    var numericButtons: [UIBarButtonItem]!
    var operatorButtons: [UIBarButtonItem]!
    
    override func didMoveToSuperview()
    {
        barStyle = UIBarStyle.Black
    
        numberButton = UIBarButtonItem(title: "\(NodeTypes.Number.toRaw())", style: UIBarButtonItemStyle.Plain, target: self, action: "typeButtonHandler:")
        operatorButton = UIBarButtonItem(title: "\(NodeTypes.Operator.toRaw())", style: UIBarButtonItemStyle.Plain, target: self, action: "typeButtonHandler:")
        
        createButtons()
        
        NodesPM.addObserver(self, selector: "selectedNodeChange", notificationType: .NodeSelected)
        NodesPM.addObserver(self, selector: "selectedNodeChange", notificationType: .NodeUpdated)
    }
    
    func selectedNodeChange()
    {
        selectedNode = NodesPM.selectedNode
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
                        populateToolbar(buttons: numericButtons, selectedButton: numberButton)
                    case NodeTypes.Operator:
                        populateToolbar(buttons: operatorButtons, selectedButton: operatorButton)
                }
            }
            else
            {
                setItems(nil, animated: true)
            }
        }
    }
    

    
    func typeButtonHandler(value: UIBarButtonItem)
    {
        if let buttonLabel = value.title
        {
            NodesPM.changeSelectedNodeType(NodeTypes.fromRaw(buttonLabel)!)
        }
    }
    
    func operatorButtonHandler(value: UIButton)
    {
        if let buttonLabel = value.titleLabel?.text
        {
            NodesPM.changeSelectedNodeOperator(NodeOperators.fromRaw(buttonLabel)!)
        }
    }
    
    func numericButtonHandler(value: UIButton)
    {
        if let node = selectedNode
        {
            if let buttonLabel = value.titleLabel?.text
            {
                let newValue = Double(Int(node.value) * 10 + buttonLabel.toInt()!)
                
                NodesPM.changeSelectedNodeValue(newValue)
            }
        }
    }
    
    func clearValue()
    {
        NodesPM.changeSelectedNodeValue(0.0)
    }
    
    func showDial(value: UIBarButtonItem)
    {
        if let rootController = UIApplication.sharedApplication().keyWindow.rootViewController?
        {
            let numericDialViewController = NumericDialViewController()
            numericDialViewController.modalPresentationStyle = .Popover

            let popoverController =  UIPopoverController(contentViewController: numericDialViewController)
            popoverController.delegate = self
            
            popoverController.presentPopoverFromBarButtonItem(value, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            
            // enableItems(false)
        }
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool
    {
        println("popoverControllerDidDismissPopover")
        
        // enableItems(true)
        
        return false
    }
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController)
    {
        println("popoverControllerDidDismissPopover")
        
        // enableItems(true)
    }
    
    func enableItems(enable: Bool)
    {
        // userInteractionEnabled doesn't work when set as pop up opened...
        if let barButtonItems = items
        {
            for barButtonItem:AnyObject in barButtonItems
            {
                (barButtonItem as UIBarButtonItem).enabled = enable; println(enable)
            }
        }
    }
    
    func populateToolbar(#buttons: [UIBarButtonItem], selectedButton: UIBarButtonItem)
    {
        numberButton.tintColor = UIColor.blueColor()
        operatorButton.tintColor = UIColor.blueColor()
        selectedButton.tintColor = UIColor.yellowColor()
        
        var barButtonItems = [UIBarButtonItem]()

        barButtonItems.append(numberButton)
        barButtonItems.append(operatorButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        barButtonItems.append(spacer)
        
        barButtonItems.extend(buttons)
        
        setItems(barButtonItems, animated: true)
    }

    private func createButtons()
    {
        numericButtons = [UIBarButtonItem]()
        
        let numericButtonShowDial = UIBarButtonItem(title: "Dial", style: UIBarButtonItemStyle.Plain, target: self, action: "showDial:")
        numericButtonShowDial.tintColor = UIColor.yellowColor()
        
        numericButtons.append(numericButtonShowDial)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        spacer.width = 15
        numericButtons.append(spacer)
        
        for i in 0...9
        {
            let numericButton = Toolbar.createBorderedToolbarButton("\(i)", target: self, action: "numericButtonHandler:")
            
            numericButtons.append(numericButton)
        }
        
    
        numericButtons.append(spacer)
        
        let numericButtonClear = Toolbar.createBorderedToolbarButton("AC", target: self, action: "clearValue")
        numericButtons.append(numericButtonClear)
        
        let operatorButtonAdd = Toolbar.createBorderedToolbarButton(NodeOperators.Add.toRaw(), target: self, action: "operatorButtonHandler:")
        let operatorButtonSubtract = Toolbar.createBorderedToolbarButton(NodeOperators.Subtract.toRaw(), target: self, action: "operatorButtonHandler:")
        let operatorButtonMultiply = Toolbar.createBorderedToolbarButton(NodeOperators.Multiply.toRaw(), target: self, action: "operatorButtonHandler:")
        let operatorButtonDivide = Toolbar.createBorderedToolbarButton(NodeOperators.Divide.toRaw(), target: self, action: "operatorButtonHandler:")
        operatorButtons = [operatorButtonAdd, operatorButtonSubtract, operatorButtonMultiply, operatorButtonDivide]
    }
    
    class func createBorderedToolbarButton(title: String, target: AnyObject?, action: Selector) -> UIBarButtonItem
    {
        let button : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        button.layer.borderColor = UIColor.yellowColor().CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        
        button.showsTouchWhenHighlighted = true
    
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        button.setTitle(title, forState: UIControlState.Normal)
        
        let barButtonItem = UIBarButtonItem(customView: button)
  
        return barButtonItem
    }
}