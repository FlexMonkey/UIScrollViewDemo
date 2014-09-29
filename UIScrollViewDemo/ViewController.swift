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
    let toolbar = UIToolbar(frame: CGRectZero)
    let toolbarLabel = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    
    override func viewDidLoad()
    {        
        super.viewDidLoad()
   
        createScrollView()
        createToolbar()
        
        NodesPM.notificationCentre.addObserver(self, selector: "displayNodeSummary:", name: NodeNotificationTypes.NodeSelected.toRaw(), object: nil)
        NodesPM.notificationCentre.addObserver(self, selector: "displayNodeSummary:", name: NodeNotificationTypes.NodeMoved.toRaw(), object: nil)
        
        NodesPM.notificationCentre.addObserver(self, selector: "draggingChangedHandler:", name: NodeNotificationTypes.DraggingChanged.toRaw(), object: nil)
    }

    func createScrollView()
    {
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundControl)
        
        scrollView.contentSize = backgroundControl.frame.size;
        scrollView.minimumZoomScale = 0.3
        scrollView.maximumZoomScale = 2
        scrollView.zoomScale = 1
        
        scrollView.bouncesZoom = false
        scrollView.bounces = false
        
        scrollView.delegate = self
        
        scrollView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: view.frame.height - topLayoutGuide.length)
    }
    
    func createToolbar()
    {
        view.addSubview(toolbar)
        toolbarLabel.enabled = false
        toolbarLabel.tintColor = UIColor.blackColor()
        toolbar.setItems([toolbarLabel], animated: false)
    }
    
    func draggingChangedHandler(value: AnyObject)
    {
        let isDragging = value.object as Bool
        
        scrollView.scrollEnabled = !isDragging
    }
    
    func displayNodeSummary(value: AnyObject)
    {
        let selectedNode = value.object as NodeVO
        
        toolbarLabel.title = "Selected Node \(selectedNode.name) | Position \(selectedNode.position)"
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView!
    {
        return backgroundControl
    }

    override func viewDidLayoutSubviews()
    {
        toolbar.frame = CGRect(x: 0, y: view.frame.height - 40, width: view.frame.width, height: 40)
    }
        
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        scrollView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: size.width, height: size.height - topLayoutGuide.length)
    }
    
}

