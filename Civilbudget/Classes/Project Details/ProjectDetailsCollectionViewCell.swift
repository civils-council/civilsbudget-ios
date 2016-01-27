//
//  ProjectDetailsCollectionViewCell.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/25/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class ProjectDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: AutoPrefferedLayoutWidthLabel!
    @IBOutlet weak var dividerView: UIView!
    
    private var _viewModel: ProjectDetailsViewModel = ProjectDetailsViewModel()
    
    var viewModel: ProjectDetailsViewModel! {
        set(value) {
            _viewModel.project = value.project
        }
        get {
            return _viewModel
        }
    }
    
    private static var sizingCell = NSBundle.mainBundle().loadNibNamed("ProjectDetailsCollectionViewCell", owner: nil, options: nil).first as! ProjectDetailsCollectionViewCell
    
    class func sizeWithViewModel(viewModel: ProjectDetailsViewModel, constrainedWidth: CGFloat) -> CGSize {
        sizingCell.viewModel = viewModel
        sizingCell.bounds = CGRectMake(0, 0, constrainedWidth, sizingCell.bounds.height)
        sizingCell.contentView.bounds = sizingCell.bounds
        
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        var size = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        size.width = constrainedWidth
        
        return size
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewModel.title.bindTo(titleLabel.bnd_text)
        viewModel.fullDescription.bindTo(descriptionLabel.bnd_text)
        viewModel.author.bindTo(authorLabel.bnd_text)
        
        dividerView.backgroundColor = CivilbudgetStyleKit.bottomCopyrightGrey
        addSubview(dividerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pixelHeight = 1.0 / UIScreen.mainScreen().scale
        dividerView.frame = CGRect(x: 0.0, y: frame.height - pixelHeight, width: frame.width, height: pixelHeight)
    }
}