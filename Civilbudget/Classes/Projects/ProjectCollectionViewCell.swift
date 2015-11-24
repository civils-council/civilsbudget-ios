//
//  ProjectTableViewCell.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import AlamofireImage
import Bond

class ProjectCollectionViewCell: UICollectionViewCell {
    static let maxWidth = CGFloat(300.0)
    
    private var _viewModel: ProjectDetailsViewModel = ProjectDetailsViewModel()
    
    var viewModel: ProjectDetailsViewModel! {
        set(value) {
            _viewModel.project = value.project
        }
        get {
            return _viewModel
        }
    }
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var supportedByLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        createdAtLabel.textColor = CivilbudgetStyleKit.bottomBarBlue
        supportedByLabel.textColor = CivilbudgetStyleKit.bottomBarBlue
        
        viewModel.title.bindTo(titleLabel.bnd_text)
        viewModel.fullDescription.bindTo(descriptionLabel.bnd_text)
        viewModel.createdAt.bindTo(createdAtLabel.bnd_text)
        viewModel.supportedBy.bindTo(supportedByLabel.bnd_text)
    }
}
