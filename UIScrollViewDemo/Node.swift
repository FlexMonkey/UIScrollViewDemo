//
//  Node.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 28/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class Node: UIControl
{

    override func didMoveToSuperview()
    {
        backgroundColor = UIColor.blueColor()
        
        layer.cornerRadius = 10
        
        let pan = UIPanGestureRecognizer(target: self, action: "panHandler:");
        addGestureRecognizer(pan)
    }
    
    func panHandler(recognizer: UIPanGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.Changed
        {
            let gestureLocation = recognizer.locationInView(self)
            
            frame.offset(dx: gestureLocation.x - frame.width / 2, dy: gestureLocation.y - frame.height / 2)
        }
        else if recognizer.state == UIGestureRecognizerState.Ended
        {
            sendActionsForControlEvents(.TouchUpInside)
        }
    }
  
}
