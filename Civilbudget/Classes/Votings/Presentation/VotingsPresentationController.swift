//
//  VotingsPresentationController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/26/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import UIKit

class VotingsPresentationController: UIPresentationController {
    
    let chromeView = UIView()
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController:presentedViewController, presentingViewController:presentingViewController)
        
        chromeView.backgroundColor = UIColor(white:0.0, alpha:0.4)
        chromeView.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: "chromeViewTapped:")
        chromeView.addGestureRecognizer(tap)
    }
    
    func chromeViewTapped(gesture: UIGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerState.Ended) {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        var presentedViewFrame = CGRectZero
        let containerBounds = containerView!.bounds
        presentedViewFrame.size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds.size)
        
        return presentedViewFrame
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let width = max(ceil(parentSize.width * CGFloat(0.75)), 290.0)
            
        return CGSizeMake(width, parentSize.height)
    }
    
    override func presentationTransitionWillBegin() {
        chromeView.frame = self.containerView!.bounds
        chromeView.alpha = 0.0
        containerView!.insertSubview(chromeView, atIndex:0)
        let coordinator = presentedViewController.transitionCoordinator()
        if (coordinator != nil) {
            coordinator!.animateAlongsideTransition({
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.chromeView.alpha = 1.0
                }, completion:nil)
        } else {
            chromeView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator()
        if (coordinator != nil) {
            coordinator!.animateAlongsideTransition({
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.chromeView.alpha = 0.0
                }, completion:nil)
        } else {
            chromeView.alpha = 0.0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        chromeView.frame = containerView!.bounds
        presentedView()!.frame = frameOfPresentedViewInContainerView()
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        
        return true
    }
    
    override func adaptivePresentationStyle() -> UIModalPresentationStyle {
        
        return .FullScreen
    }
}