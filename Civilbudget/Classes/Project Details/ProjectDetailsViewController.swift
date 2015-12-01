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
        viewModel.supportButtonSelected.bindTo(supportButton.bnd_selected)
        viewModel.supportButtonSelected.map { !$0 }.bindTo(supportButton.bnd_userInteractionEnabled)
        viewModel.loadingIndicatorVisible.observeNew { visible in visible ? KVNProgress.show() : KVNProgress.dismiss() }
        viewModel.authorizationWithCompletion.observeNew { [weak self] completionHandler in
            guard let completionHandler = completionHandler, viewController = self else {
                return
            }
            
            let authViewController = AuthorizationViewController(getOnlyAuthCode: false, patchIndexPage: true, completionHandler: completionHandler)
            let navigationController = UINavigationController(rootViewController: authViewController)
            viewController.presentViewController(navigationController, animated: true, completion: nil)
        }
        
        viewModel.alertWithStatus.observeNew { [weak self] description in
            guard let viewController = self else {
                return
            }
            
            let title = description ?? "Сталася прикра помилка ;("
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Закрити", style: .Cancel, handler: nil))
            viewController.presentViewController(alert, animated: true, completion: nil)
        }
        
        UserViewModel.currentUser.accountDialog.observeNew { [weak self] value in
            guard let (fullName, handler, sender) = value, sourceView = sender as? UIView, viewController = self
                where viewController.navigationController?.visibleViewController == viewController else {
                    return
            }
            self?.presentUserProfilePopupWithFullName(fullName, sourceView: sourceView, logoutHandler: handler)
        }
        
        viewModel.votingState.observeNew { state in
            guard let state = state else {
                return
            }
            
            switch state {
            case .VoteAccepted: break
            default: return
            }
            
            let alertView = SCLAlertView()
            // alertView.addButton("Розповісти друзям", target: viewController, selector: "shareButtonTapped:")
            alertView.showTitle("Дякуємо!", subTitle: " Ваш голос важливий для нас", duration: 0.0, completeText: "Закрити",
                style: .Success, colorStyle: 0x525c99, colorTextButton: 0xFFFFFF)
        }
        
        // UI Controls actions
        backButton.bnd_tap.observeNew { [weak self] in self?.navigationController?.popViewControllerAnimated(true) }
        supportButton.bnd_tap.observeNew { [weak self] in self?.viewModel.voteForCurrentProject() }
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
