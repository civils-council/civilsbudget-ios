//
//  ViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/2/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import Alamofire
import AsyncDisplayKit
import UIKit

class ProjectsViewController: UIViewController, ToolbarsSupport, CollectionContainerSupport, UserProfilePopupSupport {
    struct Constants {
        static let productDetailsViewControllerIdentifier = "detailsViewController"
        static let votingsViewControllerIdentifier = "votingsViewController"
    }
    
    @IBOutlet var bottomToolbarContainerView: UIView!
    @IBOutlet var loadingStateContainerView: UIView!
    @IBOutlet var collectionContainerView: UIView!
    @IBOutlet var topToolbarView: UIView!
    
    let viewModel = ProjectsViewModel()
    var collectionController: ProjectsCollectionController!
    var collectionView: ASCollectionView!
    var loadingStateView: ProjectsLoadingStateView!
    
    let votingsTransitioningDelegate = VotingsTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureToolbars()
        configureCollectionContainer()
        
        // Load ProjectsLoadingState view
        if let loadingStateView = UIView.loadFirstViewFromNibNamed(ProjectsLoadingStateView.defaultNibName) as? ProjectsLoadingStateView {
            loadingStateContainerView.addSubview(loadingStateView)
            loadingStateView.addConstraintsToFitSuperview()
            self.loadingStateView = loadingStateView
        }
        
        (topToolbarView as? ProjectsTopToolbarView)?.viewModel.value = viewModel
        
        // Create and configure ASCollectionView
        let layout = StretchyHeaderCollectionViewLayout()
        collectionView = ASCollectionView(collectionViewLayout: layout)
        collectionView.registerSupplementaryNodeOfKind(UICollectionElementKindSectionHeader)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = CivilbudgetStyleKit.loadingStatusBackgroundGrey
        collectionContainerView.addSubview(collectionView)
        
        // Create and set ProjectsCollectionController
        collectionController = ProjectsCollectionController(collectionView: collectionView, viewModel: viewModel)
        collectionView.asyncDataSource = collectionController
        collectionView.asyncDelegate = collectionController
        
        // Configure bindings
        collectionController.toolbarIsHiden.bindTo(topToolbarView.bnd_hidden)
        collectionController.toolbarAlpha.bindTo(topToolbarView.bnd_alpha)
        viewModel.collectionViewUserInteractionEnabled.bindTo(collectionView.bnd_userInteractionEnabled)
        combineLatest(viewModel.loadingState, viewModel.projectListIsEmpty).bindTo(loadingStateView.state)
        
        // Actions
        
        // Reload project list after initial loading error on button tap
        loadingStateView.reloadButtonTap.observeNew { [weak self] in
            self?.viewModel.reloadProjectList()
        }.disposeIn(bnd_bag)
        
        // Did select Project handler
        viewModel.selectedProjectDetailsViewModel.observeNew { [weak self] viewModel in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailsViewController = storyboard.instantiateViewControllerWithIdentifier(Constants.productDetailsViewControllerIdentifier) as! ProjectDetailsViewController
            detailsViewController.viewModel = viewModel
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
        }.disposeIn(bnd_bag)
        
        viewModel.shouldPresentVotingsList.observeNew { [weak self] in
            self?.presentVotings(animated: true, allowDismiss: true)
        }.disposeIn(bnd_bag)
        
        // User Profile button tap
        UserViewModel.currentUser.accountDialog.observeNew { [weak self] value in
            guard let (fullName, handler, sender) = value, sourceView = sender as? UIView, viewController = self
                where viewController.navigationController?.visibleViewController == viewController else {
                    return
            }
            self?.presentUserProfilePopupWithFullName(fullName, sourceView: sourceView, logoutHandler: handler)
        }.disposeIn(bnd_bag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        presentVotings(animated: false, allowDismiss: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedItem = collectionView.indexPathsForSelectedItems()?.last {
            collectionView.deselectItemAtIndexPath(selectedItem, animated: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = collectionContainerView.bounds
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func presentVotings(animated animated: Bool, allowDismiss: Bool) {
        let votingsViewController = VotingsViewController()
        
        votingsTransitioningDelegate.allowChromeDismiss = allowDismiss
        votingsViewController.transitioningDelegate = votingsTransitioningDelegate
        votingsViewController.modalPresentationStyle = .Custom
        
        presentViewController(votingsViewController, animated: animated, completion: nil)
    }
}