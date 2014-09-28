//
//  BackgroundControl.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 28/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class BackgroundControl: UIControl
{
    let backgroundLayer = BackgroundGrid()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)

        backgroundColor = UIColor.blackColor()
        
        backgroundLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(backgroundLayer)
        
        backgroundLayer.frame = bounds.rectByInsetting(dx: 0, dy: 0)
        backgroundLayer.setNeedsDisplay()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews()
    {

    }
}
