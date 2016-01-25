//
//  PullToRefreshView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/28/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import DGActivityIndicatorView
import Bond
import UIKit

class RoundPullDownView: UIView {
    struct Constants {
        static let defaultRadius = CGFloat(60.0)
        static let defaultProgressColor = UIColor.greenColor()
    }
    
    let loadingState = Observable(LoadingState.Loaded)
    let circleLayer = CAShapeLayer()
    let activityIndicatorView = DGActivityIndicatorView(type: .TripleRings, tintColor: UIColor.whiteColor(), size: 140.0)
    
    init(radius: CGFloat = Constants.defaultRadius, progressColor: UIColor = Constants.defaultProgressColor) {
        let frame = CGRect(origin: CGPoint(), size: CGSize(width: radius * 2, height: radius * 2))
        super.init(frame: frame)
        
        configureCircleLayer(radius: radius, progressColor: progressColor)
        
        self.addSubview(activityIndicatorView)
        layer.addSublayer(circleLayer)
        
        // Loading state change handlers
        loadingState.map({ $0 == .Loading(label: nil) })
            .observeNew { [weak self] loading in
                if loading {
                    self?.activityIndicatorView.startAnimating()
                } else {
                    self?.activityIndicatorView.stopAnimating()
                    // restart animation
                }
                self?.circleLayer.hidden = loading
            }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicatorView.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }
    
    func configureCircleLayer(radius radius: CGFloat, progressColor: UIColor) {
        let center = CGPoint(x: radius, y: radius)
        circleLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(M_PI * 1.25), endAngle: CGFloat(M_PI * 3.25), clockwise: true).CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = progressColor.CGColor
        circleLayer.lineWidth = 5
        circleLayer.strokeEnd = 0.0
        circleLayer.lineCap = kCALineCapRound
    }
    
    func startCountdown(duration: NSTimeInterval = 0.5) {
        if case .Loading = loadingState.value {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.delegate = self
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        circleLayer.strokeEnd = 1.0
        circleLayer.hidden = false
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }
    
    func cancelCountdown() {
        circleLayer.removeAnimationForKey("animateCircle")
        circleLayer.strokeEnd = 0.0
        circleLayer.hidden = true
    }
    
    func startLoading() {
        loadingState.value = LoadingState.Loading(label: nil)
    }
    
    func stopLoading() {
        loadingState.value = LoadingState.Loaded
    }
}

extension RoundPullDownView {
    override func animationDidStop(anim: CAAnimation, finished: Bool) {
        if finished {
            startLoading()
        }
    }
}