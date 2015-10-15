//
//  ProjectTableViewCell.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import AlamofireImage

class ProjectTableViewCell: UITableViewCell {
    var project: Project! {
        didSet {
            titleLabel.text = project.title
            descriptionLabel.text = project.shortDescription
            iconImage.af_setImageWithURL(NSURL(string: "http://lorempixel.com/80/80/sports/\(project.id)/")!)
        }
    }
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}
