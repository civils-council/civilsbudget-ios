//
//  UIScreen+PixelHeight.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 1/27/16.
//  Copyright © 2016 Build Apps. All rights reserved.
//

import UIKit

extension UIScreen {
    var pixelHeight: CGFloat {
        return 1.0 / self.scale
    }
}
