//
//  ProjectCellNode.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import AsyncDisplayKit
import WebASDKImageManager

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
        
        dividerNode.backgroundColor = UIColor.lightGrayColor()
        addSubnode(dividerNode)
        
        dividerNode.layoutOptions
    }
    
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        let numberOfColumns = floor(constrainedSize.width / Constants.minWidth)
        let targetWidth = floor(numberOfColumns >= 2 ? constrainedSize.width / numberOfColumns : constrainedSize.width)
        let contentSize = contentNode.measure(CGSize(width: targetWidth, height: Constants.maxHeight))
        let trgetHeight = numberOfColumns > 1 ? Constants.maxHeight : contentSize.height
        contentNode.frame = CGRect(origin: CGPoint(), size: contentSize)
        return CGSize(width: targetWidth, height: trgetHeight)
    }
    
    override func layout() {
        super.layout()

        let pixelHeight = 1.0 / UIScreen.mainScreen().scale
        dividerNode.frame = CGRect(x: 0.0, y: calculatedSize.height - pixelHeight, width: calculatedSize.width, height: pixelHeight)
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
    }
    
    static var asyncImageManager: SDWebASDKImageManager = {
        return SDWebASDKImageManager(webImageManager: SDWebImageManager.sharedManager())
    }()
    
    private var viewModel: ProjectDetailsViewModel!
    
    private let imageNode = ASNetworkImageNode()
    private let titleTextNode = ASTextNode()
    private let descriptionTextNode = ASTextNode()
    private let createdDateNode = ASTextNode()
    private let votedCountNode = ASTextNode()
    private let voteBackgroundNode = ASImageNode()
    private let voteTextNode = ASTextNode()

    convenience init(viewModel: ProjectDetailsViewModel) {
        self.init()
        
        self.viewModel = viewModel
        imageNode.backgroundColor = UIColor.greenColor()
        imageNode.contentMode = .ScaleAspectFill
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
        createdDateNode.attributedString = createdString
        addSubnode(createdDateNode)
        
        let votedString = NSMutableAttributedString(string: "Підтримало: ",
            attributes: [NSFontAttributeName : Constants.detailsFont, NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        let votedAmountString = NSAttributedString(string: viewModel.supportedByCount.value,
            attributes: [NSFontAttributeName : Constants.detailsFont, NSForegroundColorAttributeName: CivilbudgetStyleKit.themeDarkBlue])
        votedString.appendAttributedString(votedAmountString)
        votedCountNode.attributedString = votedString
        addSubnode(votedCountNode)
        
        voteBackgroundNode.image = CivilbudgetStyleKit.imageOfDetailsButtonBackground
        addSubnode(voteBackgroundNode)
        
        voteTextNode.attributedString = NSAttributedString(string: "Підтримати")
        addSubnode(voteTextNode)
    }

    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec! {
        imageNode.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: 120.0)
        
        let footerSpec = ASStackLayoutSpec(direction: .Horizontal,
            spacing: 25.0,
            justifyContent: .Start,
            alignItems: .Center,
            children: [ASStackLayoutSpec(direction: .Vertical,
                spacing: 3.0,
                justifyContent: .SpaceAround,
                alignItems: .Start,
                children: [createdDateNode, votedCountNode]), ASBackgroundLayoutSpec(child: ASInsetLayoutSpec(insets: UIEdgeInsets(top: 2.0, left: 6.0, bottom: 3.0, right: 6.0), child: voteTextNode), background: voteBackgroundNode)])
        
        let fullLayoutSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12.0, left: 14.0, bottom: 10.0, right: 14.0),
            child: ASStackLayoutSpec(direction: .Vertical,
                spacing: 6.0,
                justifyContent: .Start,
                alignItems: .Start,
                children: [imageNode, titleTextNode, descriptionTextNode, footerSpec]))
        
        return fullLayoutSpec
    }
}