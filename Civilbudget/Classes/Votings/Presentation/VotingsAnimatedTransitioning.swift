//
//  VotingsAnimatedTransitioning.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/26/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import UIKit

class VotingsAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    private let isPresenting: Bool
    
    init(presenting: Bool) {
        isPresenting = presenting
        
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView() else {
                
                return
        }
        
        let fromView = fromViewController.view
        let toView = toViewController.view
        
        
        if isPresenting {
            containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresenting ? toViewController : fromViewController
        let animatingView = animatingVC.view
        
        let finalFrameForVC = transitionContext.finalFrameForViewController(animatingVC)
        var initialFrameForVC = finalFrameForVC
        initialFrameForVC.origin.x += initialFrameForVC.size.width;
        
        let initialFrame = isPresenting ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresenting ? finalFrameForVC : initialFrameForVC
        
        print(finalFrame)
        
        animatingView?.frame = initialFrame
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay:0, usingSpringWithDamping:300.0, initialSpringVelocity:5.0, options:UIViewAnimationOptions.AllowUserInteraction, animations:{
                animatingView?.frame = finalFrame
            }, completion:{ (value: Bool) in
                if !self.isPresenting {
                    fromView?.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
        })
    }
}