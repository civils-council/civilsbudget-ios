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
    var viewModel: ProjectDetailsViewModel! {
        didSet {
            reconfigureBindings()
        }
    }
    
    @IBOutlet weak var pictureImageView: StretchyHeaderBackgroundImageView!
    @IBOutlet weak var supportedByLabel: UILabel!
    @IBOutlet weak var supportedByContainerView: UIView!
    @IBOutlet weak var endDateContainerView: UIView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var endDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure appearence
        supportedByContainerView.backgroundColor = CivilbudgetStyleKit.themeLightBlue
        endDateContainerView.backgroundColor = CivilbudgetStyleKit.themeDarkBlue
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground(supported: false), forState: .Normal)
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground(supported: true), forState: .Selected)
        supportButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        supportButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        userProfileButton.setImage(CivilbudgetStyleKit.imageOfUserProfileImagePlaceholder, forState: .Normal)
    }
    
    private func reconfigureBindings() {
        bnd_bag.dispose()
        
        // Bindings
        viewModel.supportedByCount.bindTo(supportedByLabel.bnd_text)
        viewModel.budgetLabel.bindTo(budgetLabel.bnd_text)
        viewModel.pictureURL.observe { [weak self] url in
            if let url = url {
                self?.pictureImageView.af_setImageWithURL(url)
            } else {
                self?.pictureImageView.image = nil
            }
        }.disposeIn(bnd_bag)
        
        viewModel.supportButtonSelected.bindTo(supportButton.bnd_selected)
        viewModel.supportButtonUserInterationEnabled.bindTo(supportButton.bnd_userInteractionEnabled)
        viewModel.supportButtonEnabled.bindTo(supportButton.bnd_enabled)
        viewModel.userProfileButtonHidden.bindTo(userProfileButton.bnd_hidden)
        
        // Actions
        supportButton.bnd_tap.observeNew { [weak self] in
            self?.viewModel.voteForCurrentProject()
        }.disposeIn(bnd_bag)
        
        userProfileButton.bnd_tap.observeNew { [weak self] in
            UserViewModel.currentUser.presentAccountDialog(self?.userProfileButton)
        }.disposeIn(bnd_bag)
        
        endDateLabel.text = viewModel.voting.endDate
    }
}