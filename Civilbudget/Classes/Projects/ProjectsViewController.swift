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

class ProjectsViewController: BaseCollectionViewController {
    struct Constants {
        static let productCellIdentifier = "projectCell"
        static let headerCellIdentifier = "headerCell"
        static let productDetailsViewControllerIdentifier = "detailsViewController"
        static let collectionViewVerticalInset = CGFloat(10.0)
    }
    
    let projectsViewModel = ProjectsViewModel()
    var sizingCell: ProjectCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Projects Cell class
        collectionView.registerNib(UINib(nibName: "ProjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.productCellIdentifier)
        
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
    /*func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let numberOfCells = floor(self.view.frame.size.width / ProjectCollectionViewCell.width)
        let horizontalEdgeInset = (self.view.frame.size.width - (numberOfCells * ProjectCollectionViewCell.width)) / (numberOfCells + 1);
        let verticalEdgeInset = numberOfCells < 2 ? Constants.collectionViewVerticalInset : horizontalEdgeInset
        return UIEdgeInsetsMake(verticalEdgeInset, horizontalEdgeInset, verticalEdgeInset, horizontalEdgeInset);
    }*/
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let targetWidth: CGFloat = self.collectionView.bounds.width

        if sizingCell == nil {
            sizingCell = NSBundle.mainBundle().loadNibNamed("ProjectCollectionViewCell", owner: self, options: nil)[0] as? ProjectCollectionViewCell
        }
        
        guard let sizingCell = sizingCell else {
            return CGSize()
        }
        
        sizingCell.project = projectsViewModel.projectForIndexPath(indexPath)
        sizingCell.bounds = CGRectMake(0, 0, targetWidth, sizingCell.bounds.height)
        sizingCell.contentView.bounds = sizingCell.bounds
        
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        var size = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        size.width = targetWidth
        return size
    }
}

// MARK: - UICollectionViewDelegate method for cell tap handling

extension ProjectsViewController {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        projectsViewModel.selectProjectWithIndexPath(indexPath)
    }
}