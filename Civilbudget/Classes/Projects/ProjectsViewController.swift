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
import AsyncDisplayKit

class ProjectsViewController: UIViewController, ToolbarsSupport, CollectionContainerSupport, UserProfilePopupSupport {
    struct Constants {
        static let productDetailsViewControllerIdentifier = "detailsViewController"
    }
    
    @IBOutlet var bottomToolbarContainerView: UIView!
    @IBOutlet var loadingStateContainerView: UIView!
    @IBOutlet var collectionContainerView: UIView!
    @IBOutlet var topToolbarView: UIView!
    
    let viewModel = ProjectsViewModel()
    var collectionController: ProjectsCollectionController!
    var collectionView: ASCollectionView!
    var loadingStateView: ProjectsLoadingStateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureToolbars()
        configureCollectionContainer()
        
        // Load ProjectsLoadingState view
        if let loadingStateView = UIView.loadFirstViewFromNibNamed("ProjectsLoadingStateView") as? ProjectsLoadingStateView {
            loadingStateContainerView.addSubview(loadingStateView)
            loadingStateView.addConstraintsToFitSuperview()
            self.loadingStateView = loadingStateView
        }
        
        // Create and configure ASCollectionView
        let layout = StretchyHeaderCollectionViewLayout()
        collectionView = ASCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.registerSupplementaryNodeOfKind(UICollectionElementKindSectionHeader)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = CivilbudgetStyleKit.loadingStatusBackgroundGrey
        collectionContainerView.addSubview(collectionView)
        
        // Create ProjectsCollectionController
        collectionController = ProjectsCollectionController(collectionView: collectionView, viewModel: viewModel)
        collectionView.asyncDataSource = collectionController
        collectionView.asyncDelegate = collectionController
        
        // Configure bindings
        collectionController.toolbarIsHiden.bindTo(topToolbarView.bnd_hidden)
        collectionController.toolbarAlpha.bindTo(topToolbarView.bnd_alpha)
        viewModel.collectionViewUserInteractionEnabled.bindTo(collectionView.bnd_userInteractionEnabled)
        viewModel.loadingState.bindTo(loadingStateView.state)
        
        // Actions
        loadingStateView.reloadButtonTap.observeNew { [weak self] in
            self?.viewModel.refreshProjectList()
        }.disposeIn(bnd_bag)
        
        viewModel.selectedProjectDetailsViewModel.observeNew { [weak self] viewModel in
            let storyboard = UIStoryboard(name: GlobalConstants.mainBundleName, bundle: nil)
            let detailsViewController = storyboard.instantiateViewControllerWithIdentifier(Constants.productDetailsViewControllerIdentifier) as! ProjectDetailsViewController
            detailsViewController.viewModel = viewModel
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
        }.disposeIn(bnd_bag)
    }
    
    override func viewDidAppear(animated: Bool) {
        if let selectedItem = collectionView.indexPathsForSelectedItems()?.last {
            collectionView.deselectItemAtIndexPath(selectedItem, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = collectionContainerView.bounds
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

/*
class ProjectsViewController: BaseCollectionViewController {
    struct Constants {
        static let productCellIdentifier = "projectCell"
        static let headerCellIdentifier = "headerCell"
        static let productDetailsViewControllerIdentifier = "detailsViewController"
        static let collectionViewVerticalInset = CGFloat(10.0)
    }
    
    let viewModel = ProjectsViewModel()
    var sizingCell: ProjectCollectionViewCell?
    
    @IBOutlet weak var loadingStateContainerView: UIView!
    weak var loadingStateView: ProjectsLoadingStateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Project cell class
        collectionView.registerNib(UINib(nibName: "ProjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.productCellIdentifier)
        collectionView.backgroundColor = CivilbudgetStyleKit.loadingStatusBackgroundGrey
        
        // Load ProjectsLoadingState view
        if let loadingStateView = UIView.loadFirstViewFromNibNamed("ProjectsLoadingStateView") as? ProjectsLoadingStateView {
            loadingStateContainerView.addSubview(loadingStateView)
            loadingStateView.addConstraintsToFitSuperview()
            self.loadingStateView = loadingStateView
        }
        
        // Bind View Model to UI
        viewModel.projects.bindTo(collectionView, proxyDataSource: self) { (indexPath, dataSource, collectionView) in
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.productCellIdentifier, forIndexPath: indexPath) as! ProjectCollectionViewCell
            cell.viewModel.project = dataSource[indexPath.section][indexPath.row]
            return cell
        }
        viewModel.loadingState.bindTo(loadingStateView.state)
        viewModel.loadingState.observeNew { [weak self] _ in
            self?.loadingStateContainerView.hidden = self?.viewModel.projects.last?.count > 0
        }
        viewModel.loadingState.observeNew { [weak self] state in
            switch state {
            case .Failure, .Loaded, .NoData: (self?.headerCell as? ProjectsHeaderReusableView)?.stopLoadingAnimation()
            default: break
            }
        }
        viewModel.projects.last!.observe { [weak self] _ in
            self?.collectionView.userInteractionEnabled = self?.viewModel.projects.last?.count > 0
        }
        
        // Bind Actions
        loadingStateView.reloadButton.bnd_tap.observeNew { [weak self] in
            self?.viewModel.refreshProjectList()
        }
        
        viewModel.selectedProjectDetailsViewModel.observeNew { [weak self] viewModel in
            let storyboard = UIStoryboard(name: GlobalConstants.mainBundleName, bundle: nil)
            let detailsViewController = storyboard.instantiateViewControllerWithIdentifier(Constants.productDetailsViewControllerIdentifier) as! ProjectDetailsViewController
            detailsViewController.viewModel = viewModel
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        
        UserViewModel.currentUser.accountDialog.observeNew { [weak self] value in
            guard let (fullName, handler, sender) = value, sourceView = sender as? UIView, viewController = self
                where viewController.navigationController?.visibleViewController == viewController else {
                return
            }
            self?.presentUserProfilePopupWithFullName(fullName, sourceView: sourceView, logoutHandler: handler)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
            collectionView.deselectItemAtIndexPath(selectedIndexPath, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource methods

extension ProjectsViewController {
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard headerCell == nil else {
            return headerCell!
        }
        
        let view = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath) as! ProjectsHeaderReusableView
        view.viewModel = viewModel
        return view
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
}*/