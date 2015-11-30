//
//  ProjectDetailsHeaderReusableView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/25/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class ProjectDetailsHeaderReusableView: UICollectionReusableView {
    private var parentViewModel: ProjectDetailsViewModel? = nil
    private var _viewModel: ProjectDetailsViewModel = ProjectDetailsViewModel()
    
    var viewModel: ProjectDetailsViewModel! {
        set(value) {
            _viewModel.project = value.project
            parentViewModel = value
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
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground, forState: .Normal)
        supportButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        userProfileButton.setImage(CivilbudgetStyleKit.imageOfUserProfileImagePlaceholder, forState: .Normal)
        
        // Binding
        viewModel.supportedBy.bindTo(supportedByLabel.bnd_text)
        viewModel.budgetLabel.bindTo(budgetLabel.bnd_text)
        viewModel.pictureURL.observeNew { [weak self] url in
            if let url = url {
                self?.pictureImageView.af_setImageWithURL(url)
            } else {
                self?.pictureImageView.image = nil
            }
        }
        User.currentUser.map({ $0 == nil }).bindTo(userProfileButton.bnd_hidden)
        
        // UI Control actions
        supportButton.bnd_tap.observeNew { [weak self] in self?.parentViewModel?.voteForCurrentProject() }
        userProfileButton.bnd_tap.observeNew { UserViewModel.currentUser.presentAccountDialog() }
    }
}
