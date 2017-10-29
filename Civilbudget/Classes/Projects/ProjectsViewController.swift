//
//  ViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/2/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import AsyncDisplayKit
import UIKit

class ProjectsViewController: UIViewController, ToolbarsSupport, CollectionContainerSupport, UserProfilePopupSupport {
    struct Constants {
        static let storyboardName = "Main"
        static let productDetailsViewControllerIdentifier = "detailsViewController"
        static let votingsViewControllerIdentifier = "votingsViewController"
    }
    
    @IBOutlet var bottomToolbarContainerView: UIView!
    @IBOutlet var loadingStateContainerView: UIView!
    @IBOutlet var collectionContainerView: UIView!
    @IBOutlet var topToolbarView: UIView!
    @IBOutlet var votingsListButton: UIButton!
    @IBOutlet var votingTitleLabel: UILabel!
    
    
    let viewModel = ProjectsViewModel()
    var collectionController: ProjectsCollectionController!
    var collectionView: ASCollectionView!
    var loadingStateView: LoadingStateView!
    
    let votingsTransitioningDelegate = VotingsTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureToolbars()
        configureCollectionContainer()
        
        // Load ProjectsLoadingState view
        if let loadingStateView = UIView.loadFirstViewFromNibNamed(LoadingStateView.defaultNibName) as? LoadingStateView {
            loadingStateContainerView.addSubview(loadingStateView)
            loadingStateView.addConstraintsToFitSuperview()
            self.loadingStateView = loadingStateView
        }
        
        votingsListButton.setTitle("\u{f0c9}", forState: .Normal)
        
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
        loadingStateView.bnd_hidden.bindTo(loadingStateContainerView.bnd_hidden)
        viewModel.votingTitle.bindTo(votingTitleLabel.bnd_text)
        
        // Actions
        
        // Reload project list after initial loading error on button tap
        loadingStateView.reloadButtonTap.observeNew { [weak self] in
            self?.viewModel.reloadProjectList()
        }.disposeIn(bnd_bag)
        
        // Did select Project handler
        viewModel.selectedProjectDetailsViewModel.observeNew { [weak self] viewModel in
            let storyboard = UIStoryboard(name:Constants.storyboardName, bundle: nil)
            let detailsViewController = storyboard.instantiateViewControllerWithIdentifier(Constants.productDetailsViewControllerIdentifier) as! ProjectDetailsViewController
            detailsViewController.viewModel = viewModel
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
        }.disposeIn(bnd_bag)
        
        // Open Votings Side List
        votingsListButton.bnd_tap.observeNew { [weak self] in
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
        
        presentVotings(animated: false, allowDismiss: true)
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
        let storyboard = UIStoryboard(name:Constants.storyboardName, bundle: nil)
        
        guard let votingsNavigationController = storyboard.instantiateViewControllerWithIdentifier(Constants.votingsViewControllerIdentifier) as? UINavigationController,
              let votingsViewController = votingsNavigationController.topViewController as? VotingsViewController else {
            
            return
        }
        
        votingsTransitioningDelegate.allowChromeDismiss = allowDismiss
        votingsNavigationController.transitioningDelegate = votingsTransitioningDelegate
        votingsNavigationController.modalPresentationStyle = .Custom
        
        navigationController?.presentViewController(votingsNavigationController, animated: animated, completion: nil)
    }
}