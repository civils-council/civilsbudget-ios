//
//  BottomToolbar.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/22/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class BootomToolbar: UIView {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var fbShareButton: UIButton!
    @IBOutlet weak var vkShareButton: UIButton!
    @IBOutlet weak var okShareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure UI
        self.backgroundColor = CivilbudgetStyleKit.bottomBarBlue
        yearLabel.textColor = CivilbudgetStyleKit.bottomCopyrightGrey
        fbShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        fbShareButton.setTitleColor(CivilbudgetStyleKit.bottomBarBlue, forState: .Normal)
        fbShareButton.setTitle("\u{f09a}", forState: .Normal)
        vkShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        vkShareButton.setTitleColor(CivilbudgetStyleKit.bottomBarBlue, forState: .Normal)
        vkShareButton.setTitle("\u{f189}", forState: .Normal)
        okShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        okShareButton.setTitleColor(CivilbudgetStyleKit.bottomBarBlue, forState: .Normal)
        okShareButton.setTitle("\u{f263}", forState: .Normal)
    }
    
    
    @IBAction func siteLinkButtonTapped(sender: UIButton) {
        log.warning("Open home page")
    }
    
    @IBAction func fbShareButtonTapped(sender: UIButton) {
        log.warning("Open fb page")
    }
    
    @IBAction func vkShareButtonTapped(sender: UIButton) {
        log.warning("Open vk page")
    }
    
    @IBAction func okShareButtonTapped(sender: UIButton) {
        log.warning("Open ok page")
    }
}
