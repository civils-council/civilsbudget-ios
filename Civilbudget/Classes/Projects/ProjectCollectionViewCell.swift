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
    static let width = CGFloat(300.0)
        
    var project: Project! {
        didSet {
            titleLabel.text = project.title.capitalizedString
            descriptionLabel.text = project.shortDescription
            if let picURL = project.picture.value {
                headerImage.af_setImageWithURL(NSURL(string: picURL)!)
            } else {
                headerImage.image = nil
            }
        }
    }
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var supportedByLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var placeholderIconLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        createdAtLabel.textColor = CivilbudgetStyleKit.bottomBarBlue
        supportedByLabel.textColor = CivilbudgetStyleKit.bottomBarBlue
        detailsButton.setBackgroundImage(CivilbudgetStyleKit.imageOfDetailsButtonBackground, forState: .Normal)
        placeholderIconLabel.backgroundColor = CivilbudgetStyleKit.placeholderBackgroundGrey
        placeholderIconLabel.text = "\u{f03e}"
        
        // Configure selected background
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = CivilbudgetStyleKit.selectedCellBackgroundGrey 
        
        // Bind View Model to UI
        viewModel.title.bindTo(titleLabel.bnd_text)
        viewModel.fullDescription.bindTo(descriptionLabel.bnd_text)
        viewModel.createdAt.bindTo(createdAtLabel.bnd_text)
        viewModel.supportedBy.bindTo(supportedByLabel.bnd_text)
        viewModel.pictureURL.observe { [weak self] url in
            guard let headerImage = self?.headerImage, placeholderIconLabel = self?.placeholderIconLabel else {
                return
            }
            headerImage.image = nil
            placeholderIconLabel.hidden = false
            if let url = url {
                self?.headerImage.af_setImageWithURL(url, placeholderImage: nil, filter: nil,
                    imageTransition: UIImageView.ImageTransition.None) { response in
                    placeholderIconLabel.hidden = response.result.error == nil
                }
            }
        }
    }
}
