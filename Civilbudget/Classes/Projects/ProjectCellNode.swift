//
//  ProjectCellNode.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import AsyncDisplayKit

class ProjectCellNode: ASCellNode {
    private var viewModel: ProjectDetailsViewModel!
    
    private var titleTextNode: ASTextNode!
    private var descriptionTextNode: ASTextNode!
    
    convenience init(viewModel: ProjectDetailsViewModel) {
        self.init()
        
        self.viewModel = viewModel
        
        backgroundColor = UIColor.whiteColor()
        
        titleTextNode = ASTextNode()
        titleTextNode.attributedString = NSAttributedString(string: viewModel.title.value)
        titleTextNode.truncationAttributedString = NSAttributedString(string: "...")
        titleTextNode.truncationMode = .ByTruncatingTail
        titleTextNode.maximumLineCount = 2
        addSubnode(titleTextNode)
        
        descriptionTextNode = ASTextNode()
        descriptionTextNode.attributedString = NSAttributedString(string: viewModel.fullDescription.value)
        descriptionTextNode.truncationAttributedString = NSAttributedString(string: "...")
        descriptionTextNode.truncationMode = .ByTruncatingTail
        descriptionTextNode.maximumLineCount = 3
        addSubnode(descriptionTextNode)
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec! {
        return ASStackLayoutSpec(direction: .Vertical,
            spacing: 6.0,
            justifyContent: .Start,
            alignItems: .Start,
            children: [ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 10.0), child: titleTextNode),
                ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0), child: descriptionTextNode)])
    }
}
