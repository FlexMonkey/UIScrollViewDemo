//
//  RelationshipCurvesLayer.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 30/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import Foundation
import UIKit

class RelationshipCurvesLayer: CALayer
{
    required override init()
    {
        super.init()
        
        NodesPM.addObserver(self, selector: "renderRelationships", notificationType: .RelationshipsChanged)
        NodesPM.addObserver(self, selector: "renderRelationships", notificationType: .NodeMoved)
    }
    
    func renderRelationships()
    {
        println("rendering relationships!!!")
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}