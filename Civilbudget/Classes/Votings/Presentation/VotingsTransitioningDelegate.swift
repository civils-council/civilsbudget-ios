//
//  VotingsTransitioningDelegate.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/26/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import UIKit

class VotingsTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    
        return VotingsPresentationController(presentedViewController:presented, presentingViewController:presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return VotingsAnimatedTransitioning(presenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return VotingsAnimatedTransitioning(presenting: false)
    }
}