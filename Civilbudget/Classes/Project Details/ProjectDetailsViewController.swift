//
//  ProjectDetailsViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import KVNProgress
import SCLAlertView
import BankIdSDK
import Bond
import UIKit

class ProjectDetailsViewController: UIViewController, ToolbarsSupport, CollectionContainerSupport, UserProfilePopupSupport {
    @IBOutlet var bottomToolbarContainerView: UIView!
    @IBOutlet var collectionContainerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var topToolbarView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var supportButton: UIButton!
    
    var viewModel: ProjectDetailsViewModel!
    var collectionController: ProjectDetailsCollectionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureToolbars()
        configureCollectionContainer()
        
        // Configure UI
        collectionView.backgroundColor = CivilbudgetStyleKit.loadingStatusBackgroundGrey
        backButton.setImage(CivilbudgetStyleKit.imageOfBackArrowIcon, forState: .Normal)
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground(supported: false), forState: .Normal)
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground(supported: true), forState: .Selected)
        supportButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        supportButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        
        // Collection controller
        collectionController = ProjectDetailsCollectionController(collectionView: collectionView, viewModel: viewModel)
        collectionView.delegate = collectionController
        collectionView.dataSource = collectionController
        
        // Configure bindings
        collectionController.toolbarIsHiden.bindTo(topToolbarView.bnd_hidden)
        collectionController.toolbarAlpha.bindTo(topToolbarView.bnd_alpha)
        viewModel.supportButtonSelected.bindTo(supportButton.bnd_selected)
        viewModel.supportButtonUserInterationEnabled.bindTo(supportButton.bnd_userInteractionEnabled)
        viewModel.supportButtonEnabled.bindTo(supportButton.bnd_enabled)
        
        // Actions
        backButton.bnd_tap.observeNew { [weak self] in
            self?.navigationController?.popViewControllerAnimated(true)
        }.disposeIn(bnd_bag)
        
        supportButton.bnd_tap.observeNew { [weak self] in
            self?.viewModel.voteForCurrentProject()
        }.disposeIn(bnd_bag)
        
        viewModel.loadingIndicatorVisible.observeNew { visible in
            if visible {
                KVNProgress.show()
            } else {
                KVNProgress.dismiss()
            }
        }.disposeIn(bnd_bag)
        
        viewModel.authorizationWithCompletion.observeNew { [weak self] completionHandler in
            guard let completionHandler = completionHandler, viewController = self else {
                return
            }
            
            let authViewController = AuthorizationViewController(patchIndexPage: true, completionHandler: completionHandler)
            let navigationController = UINavigationController(rootViewController: authViewController)
            viewController.presentViewController(navigationController, animated: true, completion: nil)
        }
        
        viewModel.userAlertWithData.observeNew { [weak self] (let type, let title, let message) in
            self?.showAlertWithTitle(title, subtitle: message, style: type)
        }
        
        UserViewModel.currentUser.accountDialog.observeNew { [weak self] value in
            guard let (fullName, handler, sender) = value, sourceView = sender as? UIView, viewController = self
                where viewController.navigationController?.visibleViewController == viewController else {
                    return
            }
            self?.presentUserProfilePopupWithFullName(fullName, sourceView: sourceView, logoutHandler: handler)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func showAlertWithTitle(title: String, subtitle: String, closeTitle: String = "Закрити", style: SCLAlertViewStyle) {
        SCLAlertView().showTitle(title, subTitle: subtitle, duration: 0.0, completeText: closeTitle,
            style: style, colorStyle: 0x525c99, colorTextButton: 0xFFFFFF)
    }
}