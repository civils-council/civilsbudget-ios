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
            guard let viewModel = viewModel else {
                return
            }
            
            titleLabel.text = viewModel.title
            locationLabel.text = viewModel.location
            votedLabel.text = viewModel.votes
            termsLabel.text = viewModel.terms
            
            titleLabel.alpha = viewModel.textAlpha
            locationLabel.alpha = viewModel.textAlpha
            votedLabel.alpha = viewModel.textAlpha
            termsLabel.alpha = viewModel.textAlpha
            
            backgroundImage.alpha = viewModel.imageAlpha
            logoImage.alpha = viewModel.imageAlpha
            
            loadImage(viewModel.background, into: backgroundImage, active: viewModel.isActive)
            loadImage(viewModel.logo, into: logoImage, active: viewModel.isActive)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImage.backgroundColor = .grayColor()
        backgroundImage.layer.cornerRadius = 2
        
        shadowView.layer.shadowColor = UIColor.blackColor().CGColor
        shadowView.layer.shadowOffset = CGSize(width: 2, height: 2)
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowRadius =  2.0
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = CivilbudgetStyleKit.selectedCellBackgroundGrey
        
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func loadImage(url: NSURL?, into imageView: UIImageView, active: Bool) {
        guard let url = url else {
            imageView.image = nil
            
            return
        }
        
        let filter: ImageFilter = active ? ActiveImageFilter() : InactiveImageFilter()
        imageView.af_setImageWithURL(url, placeholderImage: nil, filter: filter)
    }
}

struct ActiveImageFilter: ImageFilter {
    
    let identifier = "activeFilter"
    
    let filter: Image -> Image = { image in
        return image.af_imageWithAppliedCoreImageFilter("CIExposureAdjust",
                                                        filterParameters: ["inputEV": NSNumber(double: 0.8)]) ?? image
        
    }
}

struct InactiveImageFilter: ImageFilter {
    
    let identifier = "inactiveFilter"
    
    let filter: Image -> Image = { image in
        let blackAndWhiteImage = image.af_imageWithAppliedCoreImageFilter("CIColorMonochrome",
                                                                          filterParameters: ["inputIntensity": NSNumber(double: 1),
                                                                                             "inputColor": CIColor(color: UIColor.whiteColor())]) ?? image
        let darkenImage = blackAndWhiteImage.af_imageWithAppliedCoreImageFilter("CIExposureAdjust",
                                                                                filterParameters: ["inputEV": NSNumber(double: -1.7)]) ?? blackAndWhiteImage
        
        return darkenImage
    }
}