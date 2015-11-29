//
//  BaseScrollViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/22/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import Bond

class BaseCollectionViewController: UIViewController {
    struct Constants {
        static let headerCellIdentifier = "headerCell"
    }
    
    var headerCell: UICollectionReusableView?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var topToolbar: UIView!
    @IBOutlet var bottomToolbarContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Top padding constraint
        if let collectionView = collectionView {
            let paddingTopConstraint = NSLayoutConstraint(item: collectionView, attribute: .Top, relatedBy: .Equal,
                toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
            view.addConstraint(paddingTopConstraint)
        }
        
        // Configure collection view layout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSizeMake(collectionView.frame.size.width, GlobalConstants.exposedHeaderViewHeight);
        }
        
        // Top bar configuration
        if let topToolbar = topToolbar {
            topToolbar.backgroundColor = CivilbudgetStyleKit.themeDarkBlue.colorWithAlpha(GlobalConstants.topBarBackgroundOpacity)
        }
        
        // Load BottomToolbar XIB
        if let toolbar = UIView.loadFirstViewFromNibNamed("BottomToolbarView") {
            bottomToolbarContainerView.addSubview(toolbar)
            toolbar.addConstraintsToFitSuperview()
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

// MARK: - BNDCollectionViewProxyDataSource methods (provide header cell)

extension BaseCollectionViewController: BNDCollectionViewProxyDataSource {
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard headerCell == nil else {
            return headerCell!
        }
        headerCell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.headerCellIdentifier, forIndexPath: indexPath)
        return headerCell!
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