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
        static let activitiIndicatorSideSize = CGFloat(140.0)
        static let countdownProgressLineWidth = CGFloat(5.0)
        static let countdownAnimationKey = "countdownAnimationKey"
        static let countdownAnimationDuration = NSTimeInterval(0.6)
    }
    
    let loadingState = Observable(LoadingState.Loaded)
    let circleLayer = CAShapeLayer()
    let activityIndicatorView = DGActivityIndicatorView(type: .TripleRings, tintColor: UIColor.whiteColor(), size: Constants.activitiIndicatorSideSize)
    
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
                    self?.circleLayer.hidden = true
                } else {
                    self?.activityIndicatorView.stopAnimating()
                }
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
        circleLayer.lineWidth = Constants.countdownProgressLineWidth
        circleLayer.strokeEnd = 0.0
        circleLayer.lineCap = kCALineCapRound
    }
    
    func startCountdown(duration: NSTimeInterval = Constants.countdownAnimationDuration) {
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
        circleLayer.addAnimation(animation, forKey: Constants.countdownAnimationKey)
    }
    
    func cancelCountdown() {
        circleLayer.removeAnimationForKey(Constants.countdownAnimationKey)
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