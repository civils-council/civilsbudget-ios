//
//  ProjectTableViewCell.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import AlamofireImage

class ProjectCollectionViewCell: UICollectionViewCell {
    static let width = CGFloat(300.0)
        
    var project: Project! {
        didSet {
            titleLabel.text = project.title.capitalizedString
            descriptionLabel.text = project.shortDescription
            headerImage.af_setImageWithURL(NSURL(string: "http://lorempixel.com/300/100/sports/\(project.id)/")!)
        }
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImage.image = CivilbudgetStyleKit.imageOfProjectCellBackground()
    }
}
