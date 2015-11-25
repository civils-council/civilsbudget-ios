//
//  ProjectDetailsHeaderReusableView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/25/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class ProjectDetailsHeaderReusableView: UICollectionReusableView {
    private var _viewModel: ProjectDetailsViewModel = ProjectDetailsViewModel()
    
    var viewModel: ProjectDetailsViewModel! {
        set(value) {
            _viewModel.project = value.project
        }
        get {
            return _viewModel
        }
    }
    
    @IBOutlet weak var supportedByLabel: UILabel!
    @IBOutlet weak var supportedByContainerView: UIView!
    @IBOutlet weak var endDateContainerView: UIView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var supportButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        supportedByContainerView.backgroundColor = CivilbudgetStyleKit.themeLightBlue
        endDateContainerView.backgroundColor = CivilbudgetStyleKit.themeDarkBlue
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground, forState: .Normal)
        supportButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
    }
}
