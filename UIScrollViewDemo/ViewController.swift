//
//  ViewController.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 28/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//
// With help from: 
//
//  http://www.raywenderlich.com/76436/use-uiscrollview-scroll-zoom-content-swift
//  http://www.rockhoppertech.com/blog/swift-dragging-a-uiview-with-snap/

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIToolbarDelegate
{
    let scrollView = UIScrollView(frame: CGRectZero)
    let backgroundControl = BackgroundControl(frame: CGRect(x: 0, y: 0, width: 5000, height: 5000))
    let toolbar = Toolbar(frame: CGRectZero)
  
    override func viewDidLoad()
    {        
        super.viewDidLoad()
   
        createScrollView()
        createToolbar()
        
        view.backgroundColor = UIColor.darkGrayColor()
        
        NodesPM.addObserver(self, selector: "displayNodeSummary:", notificationType: .NodeSelected)
        
        NodesPM.addObserver(self, selector: "draggingChangedHandler:", notificationType: .DraggingChanged)
        
        NodesPM.addObserver(self, selector: "relationshipCreationModeChanged", notificationType: .RelationshipCreationModeChanged)
    }

    func createScrollView()
    {
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundControl)
        
        scrollView.contentSize = backgroundControl.frame.size;
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 3
        scrollView.zoomScale = 1
    
        scrollView.delegate = self
        
        scrollView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: view.frame.height - topLayoutGuide.length)
    }
    
    func createToolbar()
    {
        view.addSubview(toolbar)
    }
    
    func relationshipCreationModeChanged()
    {
        scrollView.scrollEnabled = !NodesPM.relationshipCreationMode
    }
    
    func draggingChangedHandler(value: AnyObject)
    {
        let isDragging = value.object as Bool
        
        scrollView.scrollEnabled = !isDragging
    }
    
    func displayNodeSummary(value: AnyObject)
    {
        let selectedNode = value.object as NodeVO
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView!
    {
        return backgroundControl
    }

    override func viewDidLayoutSubviews()
    {
        toolbar.frame = CGRect(x: 0, y: view.frame.height - 40, width: view.frame.width, height: 40)
        
        scrollView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: view.frame.height - topLayoutGuide.length)
    }

    override func supportedInterfaceOrientations() -> Int
    {
        return Int(UIInterfaceOrientationMask.Landscape.toRaw())
    }
}

