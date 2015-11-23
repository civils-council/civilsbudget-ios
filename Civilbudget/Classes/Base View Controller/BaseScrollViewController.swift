//
//  BaseScrollViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/22/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class BaseScrollViewController: UIViewController {
    var paddingTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bottomToolbar: BootomToolbar!
    @IBOutlet var bottomToolbarPlaceholderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Top padding constraint
        if let scrollView = scrollView {
            paddingTopConstraint = NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal,
                toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
            view.addConstraint(paddingTopConstraint)
        }
        
        // Load BottomToolbar XIB
        NSBundle.mainBundle().loadNibNamed("BottomToolbar", owner: self, options: nil)
        if let container = bottomToolbarPlaceholderView, toolbar = bottomToolbar {
            container.addSubview(toolbar)
            container.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Top, relatedBy: .Equal, toItem: container, attribute: .Top, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Left, relatedBy: .Equal, toItem: container, attribute: .Left, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Right, relatedBy: .Equal, toItem: container, attribute: .Right, multiplier: 1.0, constant: 0.0))
        }
    }
}
