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
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec! {
        return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .Default, child: logoImageNode);
    }
}