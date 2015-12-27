//
//  ProjectsSupplementaryNode.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/4/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import Localize_Swift
import AsyncDisplayKit

class ProjectsHeaderCellNode: ASCellNode {
    struct Constants {
        static let titleFont = UIFont(name: "HelveticaNeue", size: 18.0)!
    }
    
    let stretchedFrame = Observable(CGRect())
    
    private var viewModel: ProjectsViewModel!
    
    private var backgroundNode: ASDisplayNode!
    private let backgroundGradientNode = ASImageNode()
    private let logoImageNode = ASImageNode()
    private let titleTextNode = ASTextNode()
    
    convenience init(viewModel: ProjectsViewModel, height: CGFloat) {
        self.init()
        
        self.viewModel = viewModel
        
        backgroundColor = UIColor.greenColor()
        
        backgroundNode = ASDisplayNode { () -> UIView in
            let backgroundImageView = StretchyHeaderBackgroundImageView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: height))
            backgroundImageView.image = UIImage(named: "ProjectsHeaderBackground")
            return backgroundImageView
        }
        addSubnode(backgroundNode)
        
        backgroundGradientNode.image = UIImage(named: "ProjectsHeaderGradient")!
        addSubnode(backgroundGradientNode)
        
        titleTextNode.attributedString = NSAttributedString(string: "Громадський бюджет в місті Черкаси 2015".localized(),
            attributes: [NSFontAttributeName: Constants.titleFont, NSForegroundColorAttributeName: UIColor.whiteColor()])
        addSubnode(titleTextNode)
        
        logoImageNode.image = UIImage(named: "ProjectsHeaderLogo")!
        addSubnode(logoImageNode)
        
        stretchedFrame.observeNew { [unowned self] frame in
            self.view.frame = frame
        }.disposeIn(bnd_bag)
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        logoImageNode.measure(constrainedSize)
        titleTextNode.measure(constrainedSize)
        
        return constrainedSize
    }
    
    override func layout() {
        super.layout()
        
        backgroundNode.frame = bounds
        backgroundGradientNode.frame = bounds
        titleTextNode.frame = CGRect(origin: CGPoint(), size: titleTextNode.calculatedSize)
        logoImageNode.frame = CGRect(origin: CGPoint(), size: logoImageNode.calculatedSize)
        logoImageNode.view.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }
}