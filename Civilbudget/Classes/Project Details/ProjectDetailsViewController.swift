//
//  ProjectDetailsViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import BankIdSDK
import KVNProgress
import SCLAlertView
import Bond

class ProjectDetailsViewController: BaseCollectionViewController {
    struct Constants {
        static let detailsCellIdentifier = "detailsCell"
    }
    
    var viewModel: ProjectDetailsViewModel!
    var sizingCell: ProjectDetailsCollectionViewCell?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UI
        collectionView.backgroundColor = CivilbudgetStyleKit.loadingStatusBackgroundGrey
        backButton.setTitle("\u{f104}", forState: .Normal)
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground(supported: false), forState: .Normal)
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground(supported: true), forState: .Selected)
        supportButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        supportButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        
        // Register Projects details cell class
        collectionView.registerNib(UINib(nibName: "ProjectDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.detailsCellIdentifier)
        
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
            
            let authViewController = AuthorizationViewController(getOnlyAuthCode: false, patchIndexPage: true, completionHandler: completionHandler)
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
    
    func shareButtonTapped(sender: UIButton) {
        let activityViewController = UIActivityViewController(activityItems: [NSURL(string: "https://www.facebook.com/")!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceRect = sender.bounds
        activityViewController.popoverPresentationController?.sourceView = sender
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource methods

extension ProjectDetailsViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.detailsCellIdentifier, forIndexPath: indexPath) as! ProjectDetailsCollectionViewCell
        cell.viewModel = viewModel
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard headerCell == nil else {
            return headerCell!
        }
        
        let view = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath) as! ProjectDetailsHeaderReusableView
        view.viewModel = viewModel
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods (layout customization)

extension ProjectDetailsViewController {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let targetWidth: CGFloat = self.collectionView.bounds.width
        
        if sizingCell == nil {
            sizingCell = NSBundle.mainBundle().loadNibNamed("ProjectDetailsCollectionViewCell", owner: self, options: nil).first as? ProjectDetailsCollectionViewCell
        }
        
        guard let sizingCell = sizingCell else {
            return CGSize()
        }
        
        sizingCell.viewModel = viewModel
        sizingCell.bounds = CGRectMake(0, 0, targetWidth, sizingCell.bounds.height)
        sizingCell.contentView.bounds = sizingCell.bounds
        
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        var size = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        size.width = targetWidth
        return size
    }
}
