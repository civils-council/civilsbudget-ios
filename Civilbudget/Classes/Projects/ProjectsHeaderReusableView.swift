//
//  ProjectsHeaderReusableView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/29/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import DGActivityIndicatorView
import Bond

class ProjectsHeaderReusableView: UICollectionReusableView {
    static let minimumPullDownHeigh = CGFloat(280.0)
    
    var viewModel: ProjectsViewModel!
    var activityIndicatorView = DGActivityIndicatorView(type: .TripleRings, tintColor: UIColor.whiteColor(), size: 140.0)
    
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var centerLogoImageView: UIImageView!
    @IBOutlet weak var loadingIndicatorContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure UI
        userProfileButton.setImage(CivilbudgetStyleKit.imageOfUserProfileImagePlaceholder, forState: .Normal)
        
        // Binding
        User.currentUser.map({ $0 == nil }).bindTo(userProfileButton.bnd_hidden)
        userProfileButton.bnd_tap.observeNew { [weak self] in UserViewModel.currentUser.presentAccountDialog(self?.userProfileButton) }
        
        // Add loading indicator
        loadingIndicatorContainerView.addSubview(activityIndicatorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame.size.height > ProjectsHeaderReusableView.minimumPullDownHeigh &&
            !activityIndicatorView.animating {
            activityIndicatorView.startAnimating()
            viewModel.refreshProjectList()
        }
    }
    
    func stopLoadingAnimation() {
        activityIndicatorView.stopAnimating()
    }
}