//
//  TestAccessibleImageView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/2/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class AccessibleImageView: UIImageView {
    override var image: UIImage? {
        didSet {
            self.accessibilityIdentifier = image.isNil ? "emptyImage" : "loadedImage"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isAccessibilityElement = true
    }
}