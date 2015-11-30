//
//  ProjectsHeaderReusableView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/29/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class ProjectsHeaderReusableView: UICollectionReusableView {
    @IBOutlet weak var userProfileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure UI
        userProfileButton.setImage(CivilbudgetStyleKit.imageOfUserProfileImagePlaceholder, forState: .Normal)
        
        // Binding
        User.currentUser.map({ $0 == nil }).bindTo(userProfileButton.bnd_hidden)
        userProfileButton.bnd_tap.observeNew { [weak self] in UserViewModel.currentUser.presentAccountDialog(self?.userProfileButton) }
    }
}