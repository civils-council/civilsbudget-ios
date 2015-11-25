//
//  FullWidthImageView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/23/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class FullScreenWidthImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let image = image else {
            return
        }
        
        // Resize current image on ipad to fit max screen side
        // Should add separate wider resource for iPad case
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let screenSize = UIScreen.mainScreen().bounds
            let maxWidth = max(screenSize.width, screenSize.height)
            if maxWidth > image.size.width {
                let newSize = CGSize(width: maxWidth, height: maxWidth / image.size.width * image.size.height)
                UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
                image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
                let newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                self.image = newImage
            }
        }
    }
}