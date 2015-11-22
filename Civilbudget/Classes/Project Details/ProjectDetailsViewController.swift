//
//  ProjectDetailsViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import AlamofireImage

class ProjectDetailsViewController: UIViewController {
    var detailsViewModel: ProjectDetailsViewModel!
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsViewModel.projectTitle.bindTo(titleLabel.bnd_text)
        detailsViewModel.projectDescription.bindTo(descriptionLabel.bnd_text)
        detailsViewModel.projectPicture.observe{  pic in
            self.topImageView.af_setImageWithURL(NSURL(string: pic!)!)}
    }
}