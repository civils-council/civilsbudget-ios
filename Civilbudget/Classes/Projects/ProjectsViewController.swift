//
//  ViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/2/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import Bond
import Alamofire
import BankIdSDK

class ProjectsViewController: BaseScrollViewController {
    struct Constants {
        static let productCellIdentifier = "projectCell"
        static let headerCellIdentifier = "headerCell"
        static let productDetailsViewControllerIdentifier = "detailsViewController"
        static let collectionViewVerticalInset = CGFloat(10.0)
        static let headerHeight = CGFloat(240.0)
    }
    
    let projectsViewModel = ProjectsViewModel()
    var headerCell: UICollectionReusableView?
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure collection view layout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSizeMake(collectionView.frame.size.width, Constants.headerHeight);
        }
        
        // Bind View Model to UI
        projectsViewModel.projects.lift().bindTo(collectionView, proxyDataSource: self) { indexPath, dataSource, collectionView in
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.productCellIdentifier, forIndexPath: indexPath) as! ProjectCollectionViewCell
            cell/*.detailsViewModel*/.project = dataSource[indexPath.section][indexPath.row]
            return cell
        }
        
        // Bind Actions
        projectsViewModel.selectedProjectDetailsViewModel.observeNew { [weak self] detailsViewModel in
            let storyboard = UIStoryboard(name: GlobalConstants.mainBundleName, bundle: nil)
            let detailsViewController = storyboard.instantiateViewControllerWithIdentifier(Constants.productDetailsViewControllerIdentifier) as! ProjectDetailsViewController
            detailsViewController.detailsViewModel = detailsViewModel
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - BNDCollectionViewProxyDataSource methods (provide header cell)

extension ProjectsViewController: BNDCollectionViewProxyDataSource {
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard headerCell == nil else {
            return headerCell!
        }
        headerCell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.headerCellIdentifier, forIndexPath: indexPath)
        return headerCell!
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods (layout customization)

extension ProjectsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let numberOfCells = floor(self.view.frame.size.width / ProjectCollectionViewCell.width)
        let horizontalEdgeInset = (self.view.frame.size.width - (numberOfCells * ProjectCollectionViewCell.width)) / (numberOfCells + 1);
        let verticalEdgeInset = numberOfCells < 2 ? Constants.collectionViewVerticalInset : horizontalEdgeInset
        return UIEdgeInsetsMake(verticalEdgeInset, horizontalEdgeInset, verticalEdgeInset, horizontalEdgeInset);
    }
}

// MARK: - UICollectionViewDelegate method for cell tap handling

extension ProjectsViewController {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        projectsViewModel.selectProjectWithIndexPath(indexPath)
    }
}

// MARK: - UIScrollViewDelegate methods to limit bounce of scroll view

extension ProjectsViewController {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView,
            collectionViewLayout = collectionView.collectionViewLayout as? StretchyHeaderCollectionViewLayout
            else {
                return
        }
        
        if scrollView.contentOffset.y < -collectionViewLayout.headerBounceThreshold {
            scrollView.contentOffset = CGPointMake(0, -collectionViewLayout.headerBounceThreshold);
        }
    }
}