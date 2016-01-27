//
//  TestAccessibleImageView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/2/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class AccessibleImageView: UIImageView {
    
    // Used to diferentiate UIImageViews with loaded and not loaded images in UI Testing (for taking snapshots)
    struct Constants {
        static let notLoadedAccessibilityIdentifier = "emptyImage"
        static let loadedAccessibilityIdentifier = "loadedImage"
    }
    
    override var image: UIImage? {
        didSet {
            self.accessibilityIdentifier = image.isNil ? Constants.notLoadedAccessibilityIdentifier : Constants.loadedAccessibilityIdentifier
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isAccessibilityElement = true
    }
}