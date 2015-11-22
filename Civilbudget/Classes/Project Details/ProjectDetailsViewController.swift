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
    @IBOutlet weak var supportedTitleLabel: UILabel!
    @IBOutlet weak var supportedCountLabel: UILabel!
    @IBOutlet weak var endingDateTitleLabel: UILabel!
    @IBOutlet weak var endingDateValueLabel: UILabel!
    @IBOutlet weak var projectPriceLabel: UILabel!
    @IBOutlet weak var voteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsViewModel.projectTitle.bindTo(titleLabel.bnd_text)
        detailsViewModel.projectDescription.bindTo(descriptionLabel.bnd_text)
        detailsViewModel.projectOwner.observe{  owner in
            self.title = owner}
        detailsViewModel.projectPicture.observe{  pic in
            self.topImageView.af_setImageWithURL(NSURL(string: pic!)!)}
        
        voteButton.layer.cornerRadius = 3.0
        voteButton.layer.masksToBounds = true
        
//        MARK: hard code
        supportedCountLabel.text = "0"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.M.yy"
        endingDateValueLabel.text = dateFormatter.stringFromDate(NSDate())
        
        let price = 15000
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.locale = NSLocale(localeIdentifier: "uk")
        projectPriceLabel.text = "Ціна проекту: " + formatter.stringFromNumber(price)! + " грн"
    }
}