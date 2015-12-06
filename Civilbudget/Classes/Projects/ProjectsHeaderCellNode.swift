//
//  ProjectsSupplementaryNode.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/4/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import AsyncDisplayKit

class ProjectsHeaderCellNode: ASCellNode {
    private var viewModel: ProjectsViewModel!
    
    private let logoImageNode = ASImageNode()
    
    convenience init(viewModel: ProjectsViewModel) {
        self.init()
        
        self.viewModel = viewModel
        
        backgroundColor = UIColor.greenColor()
        
        logoImageNode.image = UIImage(named: "ProjectsHeaderLogo")!
        addSubnode(logoImageNode)
        
        /*addSubnode(ASDisplayNode(viewBlock: {
            return HeaderBackgroundView()
        }))*/
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec! {
        return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .Default, child: logoImageNode);
    }
    
    override func layout() {
        super.layout()
    }
}

class HeaderBackgroundView: UIView {
    override func didMoveToWindow() {
        if let _ = window {
            let sv = self.superview
            //sv?.autoresizingMask = .None
            //sv?.translatesAutoresizingMaskIntoConstraints = false
            //sv?.addConstraintsToFitSuperview()
        }
    }
}