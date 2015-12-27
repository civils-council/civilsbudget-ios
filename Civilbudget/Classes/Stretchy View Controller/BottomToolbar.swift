//
//  BottomToolbar.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/22/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class BootomToolbar: UIView {
    enum Link: String {
        case Facebook = "https://www.facebook.com/civilscouncil"
        case VKontakte = "https://vk.com/civilscouncil"
        case Odnoklassniki = "http://ok.ru"
        case HomePage = "http://www.golos.ck.ua"
    }
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var fbShareButton: UIButton!
    @IBOutlet weak var vkShareButton: UIButton!
    
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
    }
    
    
    @IBAction func siteLinkButtonTapped(sender: UIButton) {
        openPage(.HomePage)
    }
    
    @IBAction func fbShareButtonTapped(sender: UIButton) {
        openPage(.Facebook)
    }
    
    @IBAction func vkShareButtonTapped(sender: UIButton) {
        openPage(.VKontakte)
    }
    
    @IBAction func okShareButtonTapped(sender: UIButton) {
        openPage(.Odnoklassniki)
    }
    
    func openPage(link: Link) {
        guard let URL = NSURL(string: link.rawValue) else {
            return
        }
        UIApplication.sharedApplication().openURL(URL)
    }
}
