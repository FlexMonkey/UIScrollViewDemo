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
    }
    
    func labelFunction(value: Double) -> String
    {
        let dialValue = Double(Int(value * 100))
        
        return NSString(format: "%.0f", dialValue)
    }
    
    func dialChangeHandler(numericDial: NumericDial)
    {
        let dialValue = Double(Int(numericDial.currentValue * 100))
        
        NodesPM.changeSelectedNodeValue(dialValue)
    }
}
