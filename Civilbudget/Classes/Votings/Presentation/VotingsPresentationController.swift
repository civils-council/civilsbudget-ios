//
//  VotingsPresentationController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/26/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import UIKit

class VotingsPresentationController: UIPresentationController {
    
    struct Constants {
        static let minPresentingViewControllerWidth = CGFloat(290.0)
        static let presentingViewControllerWidth = CGFloat(0.75)
    }
    
    let chromeView = UIView()
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController:presentedViewController, presentingViewController:presentingViewController)
        
        chromeView.backgroundColor = UIColor.blackColor().colorWithAlpha(0.4)
        chromeView.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: "chromeViewTapped:")
        chromeView.addGestureRecognizer(tap)
    }
    
    func chromeViewTapped(gesture: UIGestureRecognizer) {
        if gesture.state == .Ended {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        guard let containerBounds = containerView?.bounds else {
            return CGRectZero
        }
        
        var presentedViewFrame = CGRectZero
        presentedViewFrame.size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds.size)
        
        return presentedViewFrame
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let width = max(ceil(parentSize.width * Constants.presentingViewControllerWidth), Constants.minPresentingViewControllerWidth)
            
        return CGSizeMake(width, parentSize.height)
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(chromeView, atIndex:0)
        
        chromeView.alpha = 0.0
        
        if let coordinator = presentedViewController.transitionCoordinator() {
            coordinator.animateAlongsideTransition({ context in
                    self.chromeView.alpha = 1.0
                }, completion:nil)
        } else {
            chromeView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator() {
            coordinator.animateAlongsideTransition({ context in
                self.chromeView.alpha = 0.0
            }, completion:nil)
        } else {
            chromeView.alpha = 0.0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        if let bounds = containerView?.bounds {
            chromeView.frame = bounds
        }
        
        presentedView()?.frame = frameOfPresentedViewInContainerView()
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        
        return true
    }
    
    override func adaptivePresentationStyle() -> UIModalPresentationStyle {
        
        return .FullScreen
    }
}