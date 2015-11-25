//
//  BaseScrollViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/22/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class BaseCollectionViewController: UIViewController {
    var paddingTopConstraint: NSLayoutConstraint!
    var headerCell: UICollectionReusableView?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var topToolbar: UIView!
    @IBOutlet var bottomToolbar: BootomToolbar!
    @IBOutlet var bottomToolbarPlaceholderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Top padding constraint
        if let collectionView = collectionView {
            paddingTopConstraint = NSLayoutConstraint(item: collectionView, attribute: .Top, relatedBy: .Equal,
                toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
            view.addConstraint(paddingTopConstraint)
        }
        
        // Configure collection view layout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSizeMake(collectionView.frame.size.width, GlobalConstants.exposedHeaderViewHeight);
        }
        
        // Top bar configuration
        if let topToolbar = topToolbar {
            topToolbar.backgroundColor = CivilbudgetStyleKit.bottomBarBlue.colorWithAlpha(GlobalConstants.topBarBackgroundOpacity)
        }
        
        // Load BottomToolbar XIB
        NSBundle.mainBundle().loadNibNamed("BottomToolbar", owner: self, options: nil)
        if let container = bottomToolbarPlaceholderView, toolbar = bottomToolbar {
            container.addSubview(toolbar)
            container.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Top, relatedBy: .Equal, toItem: container, attribute: .Top, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Left, relatedBy: .Equal, toItem: container, attribute: .Left, multiplier: 1.0, constant: 0.0))
            container.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Right, relatedBy: .Equal, toItem: container, attribute: .Right, multiplier: 1.0, constant: 0.0))
        }
    }
}

// MARK: - UIScrollViewDelegate methods to limit bounce of scroll view

extension BaseCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView,
            collectionViewLayout = collectionView.collectionViewLayout as? StretchyHeaderCollectionViewLayout
            else {
                return
        }
        
        if scrollView.contentOffset.y < -collectionViewLayout.headerBounceThreshold {
            scrollView.contentOffset = CGPointMake(0, -collectionViewLayout.headerBounceThreshold);
        }
        
        guard let topToolbar = topToolbar else {
            return
        }
        
        topToolbar.hidden = collectionView.contentOffset.y < GlobalConstants.exposedHeaderViewHeight - topToolbar.frame.height
        if !topToolbar.hidden {
            topToolbar.alpha =  (collectionView.contentOffset.y - GlobalConstants.exposedHeaderViewHeight + topToolbar.frame.height) / topToolbar.frame.height
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods (layout customization)

extension BaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: collectionView.bounds.width, height: GlobalConstants.exposedHeaderViewHeight): CGSizeZero
    }
}