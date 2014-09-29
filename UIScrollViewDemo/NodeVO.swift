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
    
    init(name: String, position: CGPoint)
    {
        self.name = name
        self.position = position
    }
}

func == (left: NodeVO, right: NodeVO) -> Bool
{
    return left.uuid == right.uuid
}