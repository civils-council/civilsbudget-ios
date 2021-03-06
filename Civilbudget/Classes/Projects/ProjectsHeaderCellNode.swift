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
        static let locationFont = UIFont(name: "HelveticaNeue-Light", size: 20.0)!
        static let pullCircleRadius = CGFloat(55)
        static let userProfileButtonTapzoneInset = UIEdgeInsets(top: -12.0, left: -12.0, bottom: -12.0, right: -12.0)
        static let votingsListButtonTapzoneInset = UIEdgeInsets(top: -22.0, left: -22.0, bottom: -22.0, right: -22.0)
    }
    
    let stretchedFrame = Observable(CGRect.zero)
    
    private var backgroundNode: ASDisplayNode!
    private var backgroundGradientNode = ASImageNode()
    private var pullDownNode: ASDisplayNode!
    private let logoImageNode = ASNetworkImageNode(cache: ASImageManger.sharedInstance, downloader: ASImageManger.sharedInstance)
    private let locationTextNode = ASTextNode()
    private let titleTextNode = ASTextNode()
    private let userProfileNode = ASButtonNode()
    private var pullDownView: RoundPullDownView!
    
    private var titleTextSize = CGSize.zero
    private var locationTextSize = CGSize.zero
    
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
        
        locationTextNode.maximumNumberOfLines = 1
        locationTextNode.displaysAsynchronously = false
        addSubnode(locationTextNode)
        
        titleTextNode.maximumNumberOfLines = 2
        titleTextNode.displaysAsynchronously = false
        titleTextNode.truncationMode = .ByWordWrapping
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
        
        logoImageNode.defaultImage = UIImage(named: "ProjectsHeaderLogo")!
        logoImageNode.clipsToBounds = true
        logoImageNode.contentMode = .ScaleAspectFill
        logoImageNode.displaysAsynchronously = false
        addSubnode(logoImageNode)
        
        userProfileNode.setImage(CivilbudgetStyleKit.imageOfUserProfileImagePlaceholder, forState: ASButtonStateNormal)
        userProfileNode.setImage(CivilbudgetStyleKit.imageOfUserProfileImagePlaceholder.tintedImageUsingColor(UIColor.blackColor().colorWithAlpha(0.4)), forState: ASButtonStateHighlighted)
        userProfileNode.addTarget(self, action: "userProfileNodeTapped:", forControlEvents: .TouchUpInside)
        userProfileNode.hitTestSlop = Constants.userProfileButtonTapzoneInset
        userProfileNode.displaysAsynchronously = false
        addSubnode(userProfileNode)
        
        // Add bindings
        stretchedFrame.observeNew { [unowned self] frame in
            self.view.frame = frame
            
            if frame.height == height + self.stretchDistance {
                self.pullDownView.startCountdown()
            } else {
                self.pullDownView.cancelCountdown()
            }
        }.disposeIn(bnd_bag)
        
        viewModel.votingTitle.observeNew { [weak self] title in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Center
            
            self?.titleTextNode.attributedString = NSAttributedString(string: title,
                                                                      attributes: [NSFontAttributeName: Constants.titleFont,
                                                                        NSParagraphStyleAttributeName: paragraphStyle,
                                                                        NSForegroundColorAttributeName: UIColor.whiteColor()])
            
            self?.setNeedsLayout()
        }.disposeIn(bnd_bag)
        
        viewModel.votingLogo.observeNew { [weak self] logo in
            self?.logoImageNode.URL = logo
        }.disposeIn(bnd_bag)
        
        viewModel.votingLocation.observeNew { [weak self] location in
            self?.locationTextNode.attributedString = NSAttributedString(string: location,
                                                                         attributes: [NSFontAttributeName: Constants.locationFont,
                                                                                      NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlpha(0.8)])
            
            self?.setNeedsLayout()
        }
        
        User.currentUser.map({ $0.isNil }).observe { [unowned self] hidden in
            self.userProfileNode.hidden = hidden
        }.disposeIn(bnd_bag)
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        logoImageNode.measure(constrainedSize)
        titleTextNode.measure(CGSize(width: constrainedSize.width - 70.0, height: constrainedSize.height))
        locationTextNode.measure(constrainedSize)
        
        // Round title size to prevent image misaligning
        var titleTextSize = titleTextNode.calculatedSize
        titleTextSize.width = ceil(titleTextSize.width) + 1.0
        titleTextSize.height = ceil(titleTextSize.height) + 1.0
        self.titleTextSize = titleTextSize
        
        var locationTextSize = locationTextNode.calculatedSize
        locationTextSize.width = ceil(locationTextSize.width) + 1.0
        locationTextSize.height = ceil(locationTextSize.height) + 1.0
        self.locationTextSize = locationTextSize
        
        userProfileNode.measure(constrainedSize)
        
        return constrainedSize
    }
    
    override func layout() {
        super.layout()
        
        // Select percents that will not misalign images
        let logoVerticalCenter = CGFloat(0.375)
        let titleVerticalCenter = CGFloat(0.85)
        let locationVerticalCenter = CGFloat(0.69)
        let userProfileVerticalCenter = CGFloat(0.175)
        let userProfileRightPadding = CGFloat(9.0)
        
        let logoSize = CGSize(width: 107, height: 107)
        
        backgroundNode.frame = bounds
        backgroundGradientNode.frame = bounds
        
        logoImageNode.frame = CGRect(origin: .zero, size: logoSize)
        logoImageNode.view.center = CGPoint(x: bounds.width / 2.0, y: bounds.height * logoVerticalCenter)
        pullDownNode.view.center = logoImageNode.view.center
        
        titleTextNode.frame = CGRect(origin: .zero, size: titleTextSize)
        titleTextNode.view.center = CGPoint(x: bounds.width / 2.0, y: bounds.height * titleVerticalCenter)
        
        locationTextNode.frame = CGRect(origin: .zero, size: locationTextSize)
        locationTextNode.view.center = CGPoint(x: bounds.width / 2.0, y: bounds.height * locationVerticalCenter)
        
        userProfileNode.frame = CGRect(origin: .zero, size: userProfileNode.calculatedSize)
        userProfileNode.view.center = CGPoint(x: bounds.width - userProfileNode.frame.width / 2.0 - userProfileRightPadding,
            y: bounds.height * userProfileVerticalCenter)
    }
    
    func userProfileNodeTapped(sender: ASDisplayNode) {        
        UserViewModel.currentUser.presentAccountDialog(sender.view)
    }
}