//
//  VotingTableViewCell.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/28/17.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import AlamofireImage

class VotingTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var votedLabel: UILabel!
    @IBOutlet var termsLabel: UILabel!
    @IBOutlet var shadowView: UIView!
    
    var viewModel: VotingViewModel? = nil {
        didSet {
            titleLabel.text = viewModel?.title
            locationLabel.text = viewModel?.location
            votedLabel.text = viewModel?.votes
            termsLabel.text = viewModel?.terms
            
            backgroundImage.image = nil
            logoImage.image = nil
            
            if let viewModel = viewModel {
                loadImage(viewModel.background, into: backgroundImage, active: viewModel.isActive)
                loadImage(viewModel.logo, into: logoImage, active: viewModel.isActive)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImage.backgroundColor = .darkGrayColor()
        backgroundImage.layer.cornerRadius = 2
    }
    
    func loadImage(url: NSURL?, into imageView: UIImageView, active: Bool) {
        guard let url = url else {
            imageView.image = nil
            
            return
        }
        
        if active {
            imageView.af_setImageWithURL(url)
        } else {
            imageView.af_setImageWithURL(url, placeholderImage: nil, filter: InactiveVotingFilter())
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        shadowView.layer.shadowColor = UIColor.blackColor().CGColor
        shadowView.layer.shadowOffset = CGSize(width: 2, height: 2)
        shadowView.layer.shadowOpacity = selected ? 0.6 : 0.2
        shadowView.layer.shadowRadius =  2.0
    }
}

struct InactiveVotingFilter: ImageFilter {
    
    let identifier = "inactiveFilter"
    
    let filter: Image -> Image = { image in
        return image.af_imageWithAppliedCoreImageFilter("CIColorMonochrome",
                                                        filterParameters: ["inputIntensity": NSNumber(double: 1.0),
                                                                           "inputColor": CIColor(color: UIColor.whiteColor())]) ?? image
    }
}