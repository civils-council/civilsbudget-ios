//
//  FullWidthImageView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/23/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class StretchyHeaderBackgroundImageView: UIImageView {
    @IBInspectable var maxOffset: CGFloat = 50.0
    
    override var image: UIImage? {
        set(value) {
            let screenSize = UIScreen.mainScreen().fixedCoordinateSpace.bounds
            let maxWidth = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? max(screenSize.width, screenSize.height) : screenSize.width
            let height = self.bounds.height + self.maxOffset
            let size = CGSize(width: maxWidth, height: height)
            super.image = value?.af_imageAspectScaledToFillSize(size)
        }
        get {
            return super.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentMode = .Center
        
        guard let image = image else {
            return
        }
        
        self.image = image
    }
}