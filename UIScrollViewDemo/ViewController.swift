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

class ViewController: UIViewController, UIScrollViewDelegate
{
    let scrollView = UIScrollView(frame: CGRectZero)
    let backgroundControl = BackgroundControl(frame: CGRect(x: 0, y: 0, width: 5000, height: 5000))
    
    override func viewDidLoad()
    {        
        super.viewDidLoad()
        
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
        
        // NodesPM.notificationCentre.addObserver(self, selector: "nodeCreated:", name: NodeNotificationTypes.NodeCreated.toRaw(), object: nil)
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView!
    {
        return backgroundControl
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        scrollView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: size.width, height: size.height - topLayoutGuide.length)
    }
    
}

