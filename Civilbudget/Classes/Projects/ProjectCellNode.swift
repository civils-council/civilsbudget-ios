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
        static let maxHeight = CGFloat(200.0)
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
        let contentSize = contentNode.measure(CGSize(width: targetWidth, height: 200.0))
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
    static var asyncImageManager: SDWebASDKImageManager = {
        return SDWebASDKImageManager(webImageManager: SDWebImageManager.sharedManager())
    }()
    
    private var viewModel: ProjectDetailsViewModel!
    
    private let imageNode = ASNetworkImageNode()
    private let titleTextNode = ASTextNode()
    private let descriptionTextNode = ASTextNode()

    convenience init(viewModel: ProjectDetailsViewModel) {
        self.init()
        
        self.viewModel = viewModel
        imageNode.backgroundColor = UIColor.greenColor()
        imageNode.contentMode = .ScaleAspectFill
        imageNode.URL = viewModel.pictureURL.value ?? NSURL()
        addSubnode(imageNode)
        
        titleTextNode.attributedString = NSAttributedString(string: viewModel.title.value)
        titleTextNode.truncationMode = .ByTruncatingTail
        titleTextNode.maximumNumberOfLines = 2
        addSubnode(titleTextNode)
        
        descriptionTextNode.attributedString = NSAttributedString(string: viewModel.fullDescription.value)
        descriptionTextNode.truncationMode = .ByTruncatingTail
        descriptionTextNode.maximumNumberOfLines = 3
        addSubnode(descriptionTextNode)
    }

    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec! {
        imageNode.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: 100.0)
        titleTextNode.preferredFrameSize = CGSize(width: constrainedSize.max.width/4, height: 100.0)
        descriptionTextNode.preferredFrameSize = CGSize(width: constrainedSize.max.width/4, height: 100.0)
        
        let layout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
            child: ASStackLayoutSpec(direction: .Vertical,
                spacing: 6.0,
                justifyContent: .Start,
                alignItems: .Start,
                children: [imageNode, titleTextNode, descriptionTextNode]))
        
        return layout
    }
}