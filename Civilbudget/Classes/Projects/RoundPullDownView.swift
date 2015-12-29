//
//  PullToRefreshView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/28/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class RoundPullDownView: UIView {
    struct Constants {
        static let defaultRadius = CGFloat(60.0)
        static let defaultProgressColor = UIColor.greenColor()
    }
    
    let circleLayer = CAShapeLayer()
    
    var radius = Constants.defaultRadius
    var progressColor = Constants.defaultProgressColor
    
    init(radius: CGFloat = Constants.defaultRadius) {
        let frame = CGRect(origin: CGPoint(), size: CGSize(width: radius * 2, height: radius * 2))
        super.init(frame: frame)
        
        self.radius = radius
        
        let center = CGPoint(x: radius, y: radius)
        circleLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(M_PI * 1.5), endAngle: CGFloat(M_PI * 3.5), clockwise: true).CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = progressColor.CGColor
        circleLayer.lineWidth = 5
        circleLayer.strokeEnd = 0.0
        layer.addSublayer(circleLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCircle(duration: NSTimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        
        circleLayer.strokeEnd = 1.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }
}
