//
//  ProjectDetailsHeaderReusableView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/25/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import Bond

class ProjectDetailsHeaderReusableView: UICollectionReusableView {
    private var _viewModel: ProjectDetailsViewModel!
    
    var viewModel: ProjectDetailsViewModel! {
        set(value) {
            if _viewModel == nil {
                _viewModel = value
                addBindings()
            }
        }
        get {
            return _viewModel
        }
    }
    
    @IBOutlet weak var pictureImageView: StretchyHeaderBackgroundImageView!
    @IBOutlet weak var supportedByLabel: UILabel!
    @IBOutlet weak var supportedByContainerView: UIView!
    @IBOutlet weak var endDateContainerView: UIView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var userProfileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Appearence
        supportedByContainerView.backgroundColor = CivilbudgetStyleKit.themeLightBlue
        endDateContainerView.backgroundColor = CivilbudgetStyleKit.themeDarkBlue
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground(supported: false), forState: .Normal)
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground(supported: true), forState: .Selected)
        supportButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        supportButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        userProfileButton.setImage(CivilbudgetStyleKit.imageOfUserProfileImagePlaceholder, forState: .Normal)
    }
    
    func addBindings() {
        // Binding
        viewModel.supportedByCount.bindTo(supportedByLabel.bnd_text)
        viewModel.budgetLabel.bindTo(budgetLabel.bnd_text)
        viewModel.pictureURL.observe { [weak self] url in
            if let url = url {
                self?.pictureImageView.af_setImageWithURL(url)
            } else {
                self?.pictureImageView.image = nil
            }
        }
        combineLatest(viewModel.supportButtonSelected, User.currentUser).map { $0 && $1 != nil }.bindTo(supportButton.bnd_selected)
        supportButton.bnd_selected.map { !$0 }.bindTo(supportButton.bnd_userInteractionEnabled)
        combineLatest(viewModel.supportButtonSelected, User.currentUser, UserViewModel.currentUser.votedProject)
            .map { !(!$0 && $1 != nil && $2 != nil) }.bindTo(supportButton.bnd_enabled)
        User.currentUser.map({ $0 == nil }).bindTo(userProfileButton.bnd_hidden)
        
        // UI Control actions
        supportButton.bnd_tap.observeNew { [weak self] in self?.viewModel.voteForCurrentProject() }
        userProfileButton.bnd_tap.observeNew { [weak self] in UserViewModel.currentUser.presentAccountDialog(self?.userProfileButton) }
    }
}
