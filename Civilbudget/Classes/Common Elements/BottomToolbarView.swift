//
//  BottomToolbar.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/22/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class BottomToolbarView: UIView, LoadableView {
    enum Link: String {
        case Facebook = "https://www.facebook.com/civilscouncil"
        case VKontakte = "https://vk.com/civilscouncil"
        case Odnoklassniki = "http://ok.ru"
        case HomePage = "http://www.golos.ck.ua"
    }
    
    struct Constants {
        static let facebookIconSymbol = "\u{f09a}"
        static let vkontakteIconSymbol = "\u{f189}"
    }
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var facebookShareButton: UIButton!
    @IBOutlet weak var vkontakteShareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure UI
        self.backgroundColor = CivilbudgetStyleKit.themeDarkBlue
        yearLabel.textColor = CivilbudgetStyleKit.bottomCopyrightGrey
        facebookShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        facebookShareButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        facebookShareButton.setTitle(Constants.facebookIconSymbol, forState: .Normal)
        vkontakteShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        vkontakteShareButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        vkontakteShareButton.setTitle(Constants.vkontakteIconSymbol, forState: .Normal)
    }
    
    @IBAction func siteLinkButtonTapped(sender: UIButton) {
        openPage(.HomePage)
    }
    
    @IBAction func facebookShareButtonTapped(sender: UIButton) {
        openPage(.Facebook)
    }
    
    @IBAction func vkontakteShareButtonTapped(sender: UIButton) {
        openPage(.VKontakte)
    }
    
    func openPage(link: Link) {
        guard let URL = NSURL(string: link.rawValue) else {
            return
        }
        
        UIApplication.sharedApplication().openURL(URL)
    }
}
