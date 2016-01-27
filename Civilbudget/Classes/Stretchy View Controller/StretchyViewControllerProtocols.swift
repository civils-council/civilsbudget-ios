//
//  ViewControllerProtocols.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/19/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

// MARK: - Bottom and top toolbars support

protocol ToolbarsSupport {
    var topToolbarView: UIView! { get set}
    var bottomToolbarContainerView: UIView! { get set }
    func configureToolbars()
}

extension ToolbarsSupport {
    func configureToolbars() {
        // Top bar configuration
        topToolbarView.backgroundColor = CivilbudgetStyleKit.themeDarkBlue
        
        // Load BottomToolbar XIB
        if let toolbar = UIView.loadFirstViewFromNibNamed("BottomToolbarView") {
            bottomToolbarContainerView.addSubview(toolbar)
            toolbar.addConstraintsToFitSuperview()
        }
    }
}

// MARK: - Collection container support

protocol CollectionContainerSupport {
    var collectionContainerView: UIView! { get set }
    func configureCollectionContainer()
}

extension CollectionContainerSupport {
    func configureCollectionContainer() {
        guard let view = (self as? UIViewController)?.view else {
            return
        }
        
        // Top padding constraint
        let paddingTopConstraint = NSLayoutConstraint(item: collectionContainerView, attribute: .Top, relatedBy: .Equal,
            toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        view.addConstraint(paddingTopConstraint)
    }
}

// MARK: - Logout dialog support

protocol UserProfilePopupSupport {
    func presentUserProfilePopupWithFullName(fullName: String, sourceView: UIView, logoutHandler: (UIAlertAction) -> Void)
}

extension UserProfilePopupSupport {
    func presentUserProfilePopupWithFullName(fullName: String, sourceView: UIView, logoutHandler: (UIAlertAction) -> Void) {
        guard let currentViewController = self as? UIViewController else {
            return
        }
        
        let alertViewController = UIAlertController(title: fullName, message: nil, preferredStyle: .ActionSheet)
        alertViewController.addAction(UIAlertAction(title: "Вихід", style: .Destructive, handler: logoutHandler))
        alertViewController.addAction(UIAlertAction(title: "Скасувати", style: .Cancel, handler: nil))
        alertViewController.modalPresentationStyle = .Popover
        alertViewController.popoverPresentationController?.sourceView = sourceView
        alertViewController.popoverPresentationController?.sourceRect = sourceView.bounds
        currentViewController.presentViewController(alertViewController, animated: true, completion: nil)
    }
}