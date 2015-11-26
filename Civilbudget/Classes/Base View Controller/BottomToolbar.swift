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
    
    enum OpenLinkType:String {
        case Facebook = "https://www.facebook.com/civilscouncil"
        case VKontakte = "https://vk.com/civilscouncil"
        case Odnoklassniki = "http://ok.ru"
        case HomePage = "http://www.golos.ck.ua"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure UI
        self.backgroundColor = CivilbudgetStyleKit.themeDarkBlue
        yearLabel.textColor = CivilbudgetStyleKit.bottomCopyrightGrey
        fbShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        fbShareButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        fbShareButton.setTitle("\u{f09a}", forState: .Normal)
        vkShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        vkShareButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        vkShareButton.setTitle("\u{f189}", forState: .Normal)
        okShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        okShareButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        okShareButton.setTitle("\u{f263}", forState: .Normal)
    }
    
    
    @IBAction func siteLinkButtonTapped(sender: UIButton) {
        openLinkFor(OpenLinkType.HomePage)
    }
    
    @IBAction func fbShareButtonTapped(sender: UIButton) {
        openLinkFor(OpenLinkType.Facebook)
    }
    
    @IBAction func vkShareButtonTapped(sender: UIButton) {
        openLinkFor(OpenLinkType.VKontakte)
    }
    
    @IBAction func okShareButtonTapped(sender: UIButton) {
        openLinkFor(OpenLinkType.Odnoklassniki)
    }
    
    func openLinkFor(linkType: OpenLinkType) {
        var url : NSURL
        url = NSURL(string: linkType.rawValue)!
        UIApplication.sharedApplication().openURL(url)
    }
}
