//
//  UIView+Constraint.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/28/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsToFitSuperview() {
        if let superview = superview {
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1.0, constant: 0.0))
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: superview, attribute: .Left, multiplier: 1.0, constant: 0.0))
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: superview, attribute: .Right, multiplier: 1.0, constant: 0.0))
        }
    }
}

extension UIView {
    class func loadFirstViewFromNibNamed(name: String, owner: AnyObject? = nil) -> UIView? {
        return NSBundle.mainBundle().loadNibNamed(name, owner: owner, options: nil).first as? UIView
    }
}
