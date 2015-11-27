//
//  AutoPrefferedWidthLabel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/26/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class AutoPrefferedLayoutWidthLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 9, *) {
            // - Do nothing -
            preferredMaxLayoutWidth = bounds.width
        } else /*if #available(iOS 8, *)*/ {
            preferredMaxLayoutWidth = bounds.width
        }
    }
}