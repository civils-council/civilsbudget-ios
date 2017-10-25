//
//  ProjectsSupplementaryNode.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/4/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import AsyncDisplayKit

class ProjectsHeaderCellNode: ASCellNode {
    struct Constants {
        static let titleFont = UIFont(name: "HelveticaNeue", size: 24.0)!
        static let fontAwesome = UIFont(name: "FontAwesome", size: 20.0)!
        static let pullCircleRadius = CGFloat(55)
        static let userProfileButtonTapzoneInset = UIEdgeInsets(top: -12.0, left: -12.0, bottom: -12.0, right: -12.0)
        static let votingsListButtonTapzoneInset = UIEdgeInsets(top: -22.0, left: -22.0, bottom: -22.0, right: -22.0)
    }
    
    let stretchedFrame = Observable(CGRect.zero)
    
    private var backgroundNode: ASDisplayNode!
    private var backgroundGradientNode = ASImageNode()
    private let votingsListNode = ASButtonNode()
    private var pullDownNode: ASDisplayNode!
    private let logoImageNode = ASImageNode()
    private let titleTextNode = ASTextNode()
    private let userProfileNode = ASButtonNode()
    private var pullDownView: RoundPullDownView!
    
    private var titleTextSize = CGSize.zero
    
    var stretchDistance: CGFloat = StretchyCollectionController.Constants.defaultMaxHorizontalBounceDistance
    
    convenience init(viewModel: ProjectsViewModel, height: CGFloat) {
        self.init()
        
        // Create node hierarchy
        backgroundNode = ASDisplayNode { () -> UIView in
            let backgroundImageView = StretchyHeaderBackgroundImageView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: height))
            backgroundImageView.image = UIImage(named: "ProjectsHeaderBackground")
            return backgroundImageView
        }
        addSubnode(backgroundNode)
        
        backgroundGradientNode.image = UIImage(named: "ProjectsHeaderGradient")
        backgroundGradientNode.displaysAsynchronously = false
        addSubnode(backgroundGradientNode)
        
        titleTextNode.attributedString = NSAttributedString(string: "Громадський бюджет\n в місті Черкаси 2016",
            attributes: [NSFontAttributeName: Constants.titleFont, NSForegroundColorAttributeName: UIColor.whiteColor()])
        titleTextNode.displaysAsynchronously = false
        addSubnode(titleTextNode)
        
        pullDownNode = ASDisplayNode { [unowned self] () -> UIView in
            let pullDownView = RoundPullDownView(radius: Constants.pullCircleRadius, progressColor: CivilbudgetStyleKit.themeDarkBlue)
            viewModel.loadingState.bindTo(pullDownView.loadingState)
            pullDownView.loadingState.filter({ $0 == .Loading(label: nil) })
                .observeNew { _ in
                    viewModel.reloadProjectList()
                }.disposeIn(self.bnd_bag)
            self.pullDownView = pullDownView
            return pullDownView
        }
        
        addSubnode(pullDownNode)
        
        logoImageNode.image = UIImage(named: "ProjectsHeaderLogo")!
        logoImageNode.displaysAsynchronously = false
        addSubnode(logoImageNode)
        
        userProfileNode.setImage(CivilbudgetStyleKit.imageOfUserProfileImagePlaceholder, forState: ASButtonStateNormal)
        userProfileNode.setImage(CivilbudgetStyleKit.imageOfUserProfileImagePlaceholder.tintedImageUsingColor(UIColor.blackColor().colorWithAlpha(0.4)), forState: ASButtonStateHighlighted)
        userProfileNode.addTarget(self, action: "userProfileNodeTapped:", forControlEvents: .TouchUpInside)
        userProfileNode.hitTestSlop = Constants.userProfileButtonTapzoneInset
        userProfileNode.displaysAsynchronously = false
        addSubnode(userProfileNode)

        let hamburgerIcon = NSAttributedString(string: "\u{f0c9}",
                                               attributes: [NSFontAttributeName: Constants.fontAwesome,
                                                            NSForegroundColorAttributeName: UIColor.whiteColor()])
        let hamburgerIconHighlighted = NSAttributedString(string: "\u{f0c9}",
                                                          attributes: [NSFontAttributeName: Constants.fontAwesome,
                                                                       NSForegroundColorAttributeName: UIColor(white: 0.7, alpha: 1.0)])
        votingsListNode.setAttributedTitle(hamburgerIcon, forState: ASButtonStateNormal)
        votingsListNode.setAttributedTitle(hamburgerIconHighlighted, forState: ASButtonStateHighlighted)
        votingsListNode.addTarget(self, action: "votingsListNodeTapped:", forControlEvents: .TouchUpInside)
        votingsListNode.hitTestSlop = Constants.votingsListButtonTapzoneInset
        votingsListNode.displaysAsynchronously = false
        addSubnode(votingsListNode)
        
        // Add bindings
        stretchedFrame.observeNew { [unowned self] frame in
            self.view.frame = frame
            
            if frame.height == height + self.stretchDistance {
                self.pullDownView.startCountdown()
            } else {
                self.pullDownView.cancelCountdown()
            }
        }.disposeIn(bnd_bag)
        
        User.currentUser.map({ $0.isNil }).observe { [unowned self] hidden in
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
        votingsListNode.measure(constrainedSize)
        
        return constrainedSize
    }
    
    override func layout() {
        super.layout()
        
        // Select percents that will not misalign images
        let logoVerticalCenter = CGFloat(0.375)
        let titleVerticalCenter = CGFloat(0.8)
        let userProfileVerticalCenter = CGFloat(0.175)
        let userProfileRightPadding = CGFloat(9.0)
        let votingsListVerticalCenter = CGFloat(0.156)
        let votingsListRightPadding = CGFloat(4.0)
        
        backgroundNode.frame = bounds
        backgroundGradientNode.frame = bounds
        
        logoImageNode.frame = CGRect(origin: .zero, size: logoImageNode.calculatedSize)
        logoImageNode.view.center = CGPoint(x: bounds.width / 2.0, y: bounds.height * logoVerticalCenter)
        pullDownNode.view.center = logoImageNode.view.center
        
        titleTextNode.frame = CGRect(origin: .zero, size: titleTextSize)
        titleTextNode.view.center = CGPoint(x: bounds.width / 2.0, y: bounds.height * titleVerticalCenter)
        
        userProfileNode.frame = CGRect(origin: .zero, size: userProfileNode.calculatedSize)
        userProfileNode.view.center = CGPoint(x: bounds.width - userProfileNode.frame.width / 2.0 - userProfileRightPadding,
            y: bounds.height * userProfileVerticalCenter)
        
        votingsListNode.frame = CGRect(origin: .zero, size: votingsListNode.calculatedSize)
        votingsListNode.view.center = CGPoint(x: userProfileNode.frame.width / 2.0 + votingsListRightPadding,
            y: bounds.height * votingsListVerticalCenter)
    }
    
    func userProfileNodeTapped(sender: ASDisplayNode) {        
        UserViewModel.currentUser.presentAccountDialog(sender.view)
    }
    
    func votingsListNodeTapped(sender: ASDisplayNode) {
        print("votingsListNodeTapped")
    }
}