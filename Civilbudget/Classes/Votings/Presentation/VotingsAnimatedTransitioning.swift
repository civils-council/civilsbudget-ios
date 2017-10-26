//
//  VotingsAnimatedTransitioning.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/26/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import UIKit

class VotingsAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    let defaultAnimationDuration = 0.3
    
    private let isPresenting: Bool
    
    init(presenting: Bool) {
        isPresenting = presenting
        
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return defaultAnimationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view,
            let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view,
            let containerView = transitionContext.containerView() else {
                
                return
        }
        
        if isPresenting {
            containerView.addSubview(toView)
        }
        
        let animatingView = isPresenting ? toView : fromView
        
        var initialFrame = animatingView.frame
        initialFrame.origin.x = isPresenting ? -initialFrame.width : 0.0
        
        var finalFrame = animatingView.frame
        finalFrame.origin.x = isPresenting ? 0.0 : -finalFrame.width
        
        animatingView.frame = initialFrame
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                animatingView.frame = finalFrame
            }, completion: { completed in
                if !self.isPresenting {
                    fromView.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
        })
    }
}