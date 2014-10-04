//
//  Toolbar.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 03/10/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import UIKit

class Toolbar: UIToolbar
{
    var numberButton: UIBarButtonItem!
    var operatorButton: UIBarButtonItem!
    
    override func didMoveToSuperview()
    {
        barStyle = UIBarStyle.Black
        
        numberButton = UIBarButtonItem(title: "Number", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        operatorButton = UIBarButtonItem(title: "Operator", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    
        operatorButton.tintColor = UIColor.yellowColor()
        
        var buttons = [UIBarButtonItem]()
        buttons.append(numberButton)
        buttons.append(operatorButton)
        
        let xyz = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        buttons.append(xyz)
        
        for i in 0...9
        {
            // let xyz: Dictionary = [NSForegroundColorAttributeName: UIColor.redColor()]
            
            // operatorButton.setTitleTextAttributes(xyz, forState: UIControlState.Normal)
            
            // number emoji??
            
            let button : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 3

            button.setTitle("\(i)", forState: UIControlState.Normal)
            
            let btn = UIBarButtonItem(customView: button)
         
            buttons.append(btn)
        }
        
        setItems(buttons, animated: true)
    }
}