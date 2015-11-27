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


class ProjectsViewController: BaseCollectionViewController {
    struct Constants {
        static let productCellIdentifier = "projectCell"
        static let headerCellIdentifier = "headerCell"
        static let productDetailsViewControllerIdentifier = "detailsViewController"
        static let collectionViewVerticalInset = CGFloat(10.0)
    }
    
    let viewModel = ProjectsViewModel()
    var sizingCell: ProjectCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Project cell class
        collectionView.registerNib(UINib(nibName: "ProjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.productCellIdentifier)
        
        // Bind View Model to UI
        viewModel.projects.bindTo(collectionView, proxyDataSource: self) { (indexPath, dataSource, collectionView) in
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.productCellIdentifier, forIndexPath: indexPath) as! ProjectCollectionViewCell
            cell.viewModel.project = dataSource[indexPath.section][indexPath.row]
            return cell
        }
        
        // Bind Actions
        viewModel.selectedProjectDetailsViewModel.observeNew { [weak self] viewModel in
            let storyboard = UIStoryboard(name: GlobalConstants.mainBundleName, bundle: nil)
            let detailsViewController = storyboard.instantiateViewControllerWithIdentifier(Constants.productDetailsViewControllerIdentifier) as! ProjectDetailsViewController
            detailsViewController.viewModel = viewModel
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
            collectionView.deselectItemAtIndexPath(selectedIndexPath, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods (layout customization)

extension ProjectsViewController {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellMinWidth = ProjectCollectionViewCell.maxWidth
        let containerWidth = collectionView.bounds.width
        let numberOfColumns = floor(containerWidth / cellMinWidth)
        let targetWidth = floor(numberOfColumns >= 2.0 ? containerWidth / numberOfColumns : containerWidth)

        if sizingCell == nil {
            sizingCell = NSBundle.mainBundle().loadNibNamed("ProjectCollectionViewCell", owner: self, options: nil).first as? ProjectCollectionViewCell
        }
        
        guard let sizingCell = sizingCell else {
            return CGSize()
        }
        
        sizingCell.viewModel = viewModel.projectViewModelForIndexPath(indexPath)
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
        viewModel.selectProjectWithIndexPath(indexPath)
    }
}