//
//  ProjectCellNode.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import AsyncDisplayKit
import AlamofireImage

class ProjectCellNode: ASCellNode {
    struct Constants {
        static let minWidth = CGFloat(320.0)
        static let maxHeight = CGFloat(295.0)
    }
    
    private var contentNode: ProjectCellContentNode!
    private let dividerNode = ASDisplayNode()
    
    override var selected: Bool { didSet { updateBackgroundColor() } }
    override var highlighted: Bool { didSet { updateBackgroundColor() } }
    
    convenience init(viewModel: ProjectDetailsViewModel) {
        self.init()
        
        contentNode = ProjectCellContentNode(viewModel: viewModel)
        addSubnode(contentNode)
        
        dividerNode.backgroundColor = CivilbudgetStyleKit.bottomCopyrightGrey
        addSubnode(dividerNode)
    }
    
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        let numberOfColumns = floor(constrainedSize.width / Constants.minWidth)
        let targetWidth = floor(numberOfColumns >= 2 ? constrainedSize.width / numberOfColumns : constrainedSize.width)
        let contentSize = contentNode.measure(CGSize(width: targetWidth, height: Constants.maxHeight))
        let targetHeight = numberOfColumns > 1 ? Constants.maxHeight : contentSize.height
        contentNode.frame = CGRect(origin: CGPoint(), size: contentSize)
        return CGSize(width: targetWidth, height: targetHeight)
    }
    
    override func layout() {
        super.layout()
        
        dividerNode.frame = CGRect(x: 0.0, y: calculatedSize.height - UIScreen.mainScreen().pixelHeight, width: calculatedSize.width, height: UIScreen.mainScreen().pixelHeight)
    }
    
    func updateBackgroundColor() {
        backgroundColor = highlighted || selected ? CivilbudgetStyleKit.selectedCellBackgroundGrey : UIColor.whiteColor()
    }
}

class ProjectCellContentNode: ASDisplayNode {
    struct Constants {
        static let titleFont = UIFont(name: "HelveticaNeue", size: 18.0)!
        static let descriptionFont = UIFont(name: "HelveticaNeue", size: 16.0)!
        static let detailsFont = UIFont(name: "HelveticaNeue", size: 14.0)!
        static let detailsButtonFont = UIFont(name: "HelveticaNeue", size: 15.0)!
    }
    
    private var viewModel: ProjectDetailsViewModel!
    
    private let imageNode = ASNetworkImageNode()
    private let titleTextNode = ASTextNode()
    private let descriptionTextNode = ASTextNode()
    private let createdDateTextNode = ASTextNode()
    private let votedCountTextNode = ASTextNode()
    private let detailsBackgroundNode = ASImageNode()
    private let detailsButtonTextNode = ASTextNode()

    convenience init(viewModel: ProjectDetailsViewModel) {        
        self.init()
        
        self.viewModel = viewModel
        imageNode.backgroundColor = CivilbudgetStyleKit.bottomCopyrightGrey
        imageNode.contentMode = .ScaleAspectFill
        imageNode.clipsToBounds = true
        imageNode.imageModificationBlock = { [weak self] image in
            if let size = self?.imageNode.view.frame.size {
                return image.af_imageAspectScaledToFillSize(size)
            }
            return image
        }
        imageNode.URL = viewModel.pictureURL.value ?? NSURL()
        addSubnode(imageNode)
        
        titleTextNode.attributedString = NSAttributedString(string: viewModel.title.value, attributes: [NSFontAttributeName: Constants.titleFont])
        titleTextNode.truncationMode = .ByTruncatingTail
        titleTextNode.maximumNumberOfLines = 2
        addSubnode(titleTextNode)
        
        descriptionTextNode.attributedString = NSAttributedString(string: viewModel.fullDescription.value,
            attributes: [NSFontAttributeName: Constants.descriptionFont, NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        descriptionTextNode.truncationMode = .ByTruncatingTail
        descriptionTextNode.maximumNumberOfLines = 3
        addSubnode(descriptionTextNode)
        
        let createdString = NSMutableAttributedString(string: "Створено: ",
            attributes: [NSFontAttributeName : Constants.detailsFont, NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        let dateString = NSAttributedString(string: viewModel.createdAt.value,
            attributes: [NSFontAttributeName : Constants.detailsFont, NSForegroundColorAttributeName: CivilbudgetStyleKit.themeDarkBlue])
        createdString.appendAttributedString(dateString)
        createdDateTextNode.attributedString = createdString
        addSubnode(createdDateTextNode)
        
        let votedString = NSMutableAttributedString(string: "Підтримало: ",
            attributes: [NSFontAttributeName : Constants.detailsFont, NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        let votedAmountString = NSAttributedString(string: viewModel.supportedByCount.value,
            attributes: [NSFontAttributeName : Constants.detailsFont, NSForegroundColorAttributeName: CivilbudgetStyleKit.themeDarkBlue])
        votedString.appendAttributedString(votedAmountString)
        votedCountTextNode.attributedString = votedString
        addSubnode(votedCountTextNode)

        detailsBackgroundNode.image = CivilbudgetStyleKit.imageOfDetailsButtonBackground
        addSubnode(detailsBackgroundNode)
        
        detailsButtonTextNode.attributedString = NSAttributedString(string: "Детальніше",
            attributes: [NSFontAttributeName : Constants.detailsButtonFont, NSForegroundColorAttributeName: UIColor.whiteColor()])
        addSubnode(detailsButtonTextNode)
    }

    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let horizontalPadding = CGFloat(14.0)
        let imageHeight = CGFloat(120.0)
        let verticalSpacing = CGFloat(6.0)
        let rootInset = UIEdgeInsets(top: 12.0, left: horizontalPadding, bottom: 10.0, right: horizontalPadding)
        let detailsButtonInset = UIEdgeInsets(top: 2.0, left: 10.0, bottom: 4.0, right: 10.0)
        
        imageNode.preferredFrameSize = CGSize(width: constrainedSize.max.width - horizontalPadding * 2, height: imageHeight)
        
        let spacerSpec = ASLayoutSpec()
        spacerSpec.flexGrow = true
        
        let footerSpec = ASStackLayoutSpec(direction: .Horizontal,
            spacing: 0,
            justifyContent: .Start,
            alignItems: .Center,
            children: [ASStackLayoutSpec(direction: .Vertical,
                spacing: verticalSpacing / 2,
                justifyContent: .SpaceAround,
                alignItems: .Start,
                children: [createdDateTextNode, votedCountTextNode]), spacerSpec, ASBackgroundLayoutSpec(child: ASInsetLayoutSpec(insets: detailsButtonInset, child: detailsButtonTextNode), background: detailsBackgroundNode)])
        footerSpec.alignSelf = .Stretch
        
        let fullLayoutSpec = ASInsetLayoutSpec(insets: rootInset,
            child: ASStackLayoutSpec(direction: .Vertical,
                spacing: verticalSpacing,
                justifyContent: .Start,
                alignItems: .Start,
                children: [imageNode, titleTextNode, descriptionTextNode, footerSpec]))
        
        return fullLayoutSpec
    }
}