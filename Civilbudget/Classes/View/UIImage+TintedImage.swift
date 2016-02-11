//
//  UIImage+TintedImage.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 1/27/16.
//  Copyright © 2016 Build Apps. All rights reserved.
//

import UIKit

extension UIImage {
    func tintedImageUsingColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let drawRect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        self.drawInRect(drawRect)
        
        color.set()
        UIRectFillUsingBlendMode(drawRect, .SourceAtop)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return tintedImage
    }
}