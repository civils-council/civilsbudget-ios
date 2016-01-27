//
//  FullWidthImageView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/23/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class StretchyHeaderBackgroundImageView: UIImageView {
    static let defaultMaxOffset = CGFloat(50.0)
    
    @IBInspectable var maxOffset = StretchyHeaderBackgroundImageView.defaultMaxOffset
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpDefaults()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpDefaults()
    }
    
    func setUpDefaults() {
        contentMode = .Center
        
        guard let image = image else {
            return
        }
        
        self.image = image
    }
}