//
//  ProjectDetailsCollectionViewCell.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/25/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class ProjectDetailsCollectionViewCell: UICollectionViewCell, LoadableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: AutoPrefferedLayoutWidthLabel!
    @IBOutlet weak var dividerView: UIView!
    
    var viewModel: ProjectDetailsViewModel! {
        didSet {
            reconfigureBindings()
        }
    }
    
    private static var sizingCell = NSBundle.mainBundle().loadNibNamed(ProjectDetailsCollectionViewCell.defaultNibName, owner: nil, options: nil).first as! ProjectDetailsCollectionViewCell
    
    class func sizeWithViewModel(viewModel: ProjectDetailsViewModel, constrainedWidth: CGFloat) -> CGSize {
        sizingCell.viewModel = viewModel
        sizingCell.bounds = CGRect(x: 0.0, y: 0.0, width: constrainedWidth, height: sizingCell.bounds.height)
        sizingCell.contentView.bounds = sizingCell.bounds
        
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        var size = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        size.width = constrainedWidth
        
        return size
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dividerView.backgroundColor = CivilbudgetStyleKit.bottomCopyrightGrey
        addSubview(dividerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dividerView.frame = CGRect(x: 0.0, y: frame.height - UIScreen.mainScreen().pixelHeight, width: frame.width, height: UIScreen.mainScreen().pixelHeight)
    }
    
    private func reconfigureBindings() {
        bnd_bag.dispose()
        
        viewModel.title.bindTo(titleLabel.bnd_text)
        viewModel.fullDescription.bindTo(descriptionLabel.bnd_text)
        viewModel.author.bindTo(authorLabel.bnd_text)
    }
}