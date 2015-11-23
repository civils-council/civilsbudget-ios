//
//  GradientHeaderView.swift
//  ZappShopFinder
//
//  Created by Sztanyi Szabolcs on 13/11/15.
//  Copyright © 2015 Szabolcs Sztányi. All rights reserved.
//

import Foundation
import UIKit

/// Custom header view that displays a gradient layer inside it
@IBDesignable class GradientHeaderView: UIView {
    
    /// Gradient layer that is added on top of the view
    var gradientLayer: CAGradientLayer!
    
    /// Top color of the gradient layer
    @IBInspectable var topColor: UIColor = UIColor.blackColor() {
        didSet {
            updateUI()
        }
    }
    
    /// Bottom color of the gradient layer
    @IBInspectable var bottomColor: UIColor = UIColor.clearColor() {
        didSet {
            updateUI()
        }
    }
    
    /// At which vertical point the layer should end
    @IBInspectable var bottomYPoint: CGFloat = 0.6 {
        didSet {
            updateUI()
        }
    }
    
    /**
     Initialises the view
     
     - parameter aDecoder: aDecoder
     
     - returns: self
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradientLayer()
    }
    
    /**
     Initialises the view
     
     - parameter frame: frame to use
     
     - returns: self
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    /**
     Sets up the gradient layer
     */
    func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [topColor.CGColor, bottomColor.CGColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: bottomYPoint)
        layer.addSublayer(gradientLayer)
    }
    
    /**
     Updates the UI
     */
    func updateUI() {
        setNeedsDisplay()
    }
    
    /**
     Adjusts the background of the view if user scrolls down enough
     
     - parameter isClear: YES, if the background needs to be clear, otherwise use a solid color
     */
    func adjustBackground(isClear: Bool) {
        if isClear == true {
            gradientLayer.hidden = false
            backgroundColor = UIColor.clearColor()
        } else {
            gradientLayer.hidden = true
            backgroundColor = UIColor(red: CGFloat(54/255.0), green: CGFloat(54/255.0), blue: CGFloat(54/255.0), alpha: 1.0)
        }
    }
    
    /**
     Lays out all the subviews it has, in our case the gradient layer
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = frame
    }
    
    /**
     Prepares UI for interface builder
     */
    override func prepareForInterfaceBuilder() {
        setupGradientLayer()
    }
}