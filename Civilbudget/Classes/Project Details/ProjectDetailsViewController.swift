//
//  ProjectDetailsViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import KVNProgress
import SCLAlertView
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
        
        // Actions
        backButton.bnd_tap.observeNew { [weak self] in
            self?.navigationController?.popViewControllerAnimated(true)
        }.disposeIn(bnd_bag)
        
        supportButton.bnd_tap.observeNew { [weak self] in
            self?.viewModel.voteForCurrentProject()
        }.disposeIn(bnd_bag)
        
        /*
        // Listen to View Model changes
        combineLatest(viewModel.supportButtonSelected, User.currentUser).map { $0 && $1 != nil }.bindTo(supportButton.bnd_selected)
        supportButton.bnd_selected.map { !$0 }.bindTo(supportButton.bnd_userInteractionEnabled)
        combineLatest(viewModel.supportButtonSelected, User.currentUser, UserViewModel.currentUser.votedProject)
            .map { !(!$0 && $1 != nil && $2 != nil) }.bindTo(supportButton.bnd_enabled)
        viewModel.loadingIndicatorVisible.observeNew { visible in visible ? KVNProgress.show() : KVNProgress.dismiss() }
        viewModel.authorizationWithCompletion.observeNew { [weak self] completionHandler in
            guard let completionHandler = completionHandler, viewController = self else {
                return
            }
            
            let authViewController = AuthorizationViewController(patchIndexPage: true, completionHandler: completionHandler)
            let navigationController = UINavigationController(rootViewController: authViewController)
            viewController.presentViewController(navigationController, animated: true, completion: nil)
        }
        
        viewModel.errorAlertWithDescription.observeNew { [weak self] description in
            self?.showAlertWithTitle("Помилка", subtitle: description, style: .Error)
        }
        
        viewModel.infoAlertWithDescription.observeNew { [weak self] description in
            self?.showAlertWithTitle("Увага!", subtitle: description, closeTitle: "Зрозуміло", style: .Info)
        }
        
        viewModel.successAlertWithDescription.observeNew { [weak self] _ in            
            self?.showAlertWithTitle("Дякуємо!", subtitle: "Ваш голос важливий для нас", style: .Success)
        }
        
        UserViewModel.currentUser.accountDialog.observeNew { [weak self] value in
            guard let (fullName, handler, sender) = value, sourceView = sender as? UIView, viewController = self
                where viewController.navigationController?.visibleViewController == viewController else {
                    return
            }
            self?.presentUserProfilePopupWithFullName(fullName, sourceView: sourceView, logoutHandler: handler)
        }
        
        // UI Controls actions
        backButton.bnd_tap.observeNew { [weak self] in self?.navigationController?.popViewControllerAnimated(true) }
        supportButton.bnd_tap.observeNew { [weak self] in self?.viewModel.voteForCurrentProject() }
    }
    
    func showAlertWithTitle(title: String, subtitle: String, closeTitle: String = "Закрити", style: SCLAlertViewStyle) {
        SCLAlertView().showTitle(title, subTitle: subtitle, duration: 0.0, completeText: closeTitle,
            style: style, colorStyle: 0x525c99, colorTextButton: 0xFFFFFF)
    }
    
        */
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}