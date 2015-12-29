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
        static let titleFont = UIFont(name: "HelveticaNeue", size: 24.0)!
    }
    
    let stretchedFrame = Observable(CGRect())
    
    private var viewModel: ProjectsViewModel!
    
    private var backgroundNode: ASDisplayNode!
    private let backgroundGradientNode = ASImageNode()
    private var pullDownNode: ASDisplayNode!
    private let logoImageNode = ASImageNode()
    private let titleTextNode = ASTextNode()
    private let userProfileNode = ASImageNode()
    
    private var titleTextSize = CGSize()
    
    convenience init(viewModel: ProjectsViewModel, height: CGFloat) {
        self.init()
        
        self.viewModel = viewModel
        
        // Create node hierarchy
        backgroundNode = ASDisplayNode { () -> UIView in
            let backgroundImageView = StretchyHeaderBackgroundImageView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: height))
            backgroundImageView.image = UIImage(named: "ProjectsHeaderBackground")
            return backgroundImageView
        }
        addSubnode(backgroundNode)
        
        backgroundGradientNode.image = UIImage(named: "ProjectsHeaderGradient")!
        addSubnode(backgroundGradientNode)
        
        titleTextNode.attributedString = NSAttributedString(string: "Громадський бюджет\n в місті Черкаси 2015".localized(),
            attributes: [NSFontAttributeName: Constants.titleFont, NSForegroundColorAttributeName: UIColor.whiteColor()])
        addSubnode(titleTextNode)
        
        pullDownNode = ASDisplayNode { () -> UIView in
            return RoundPullDownView(radius: 60.0)
        }
        
        
        
        logoImageNode.image = UIImage(named: "ProjectsHeaderLogo")!
        addSubnode(logoImageNode)
        
        addSubnode(pullDownNode)
        
        userProfileNode.image = CivilbudgetStyleKit.imageOfUserProfileImagePlaceholder
        userProfileNode.addTarget(self, action: "userProfileNodeTapped:", forControlEvents: .TouchUpInside)
        userProfileNode.hitTestSlop = UIEdgeInsets(top: -12.0, left: -12.0, bottom: -12.0, right: -12.0)
        addSubnode(userProfileNode)
        
        // Add bindings
        stretchedFrame.observeNew { [unowned self] frame in
            self.view.frame = frame
        }.disposeIn(bnd_bag)
        
        User.currentUser.map({ $0 == nil }).observe { [unowned self] hidden in
            self.userProfileNode.hidden = hidden
        }.disposeIn(bnd_bag)
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        logoImageNode.measure(constrainedSize)
        titleTextNode.measure(constrainedSize)
        
        // Round title size to prevent image misaligning
        var titleTextSize = titleTextNode.calculatedSize
        titleTextSize.width = ceil(titleTextSize.width)
        titleTextSize.height = ceil(titleTextSize.height)
        self.titleTextSize = titleTextSize
        
        userProfileNode.measure(constrainedSize)
        
        return constrainedSize
    }
    
    override func layout() {
        super.layout()
        
        // Select percents that will not misalign images
        let logoVerticalCenter = CGFloat(0.375)
        let titleVerticalCenter = CGFloat(0.8)
        let userProfileVerticalCenter = CGFloat(0.175)
        let userProfileRightPadding = CGFloat(9.0)
        
        backgroundNode.frame = bounds
        backgroundGradientNode.frame = bounds
        
        logoImageNode.frame = CGRect(origin: CGPoint(), size: logoImageNode.calculatedSize)
        logoImageNode.view.center = CGPoint(x: bounds.width / 2.0, y: bounds.height * logoVerticalCenter)
        pullDownNode.view.center = logoImageNode.view.center
        
        titleTextNode.frame = CGRect(origin: CGPoint(), size: titleTextSize)
        titleTextNode.view.center = CGPoint(x: bounds.width / 2.0, y: bounds.height * titleVerticalCenter)
        
        userProfileNode.frame = CGRect(origin: CGPoint(), size: userProfileNode.calculatedSize)
        userProfileNode.view.center = CGPoint(x: bounds.width - userProfileNode.frame.width / 2.0 - userProfileRightPadding,
            y: bounds.height * userProfileVerticalCenter)
    }
    
    func userProfileNodeTapped(sender: ASDisplayNode) {
        (pullDownNode.view as! RoundPullDownView).animateCircle(10.0)
        
        UserViewModel.currentUser.presentAccountDialog(sender.view)
    }
}