//
//  LoadableView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 1/27/16.
//  Copyright © 2016 Build Apps. All rights reserved.
//

import UIKit

protocol LoadableView: class {
    static var defaultNibName: String { get }
}

extension LoadableView where Self: UIView {
    static var defaultNibName: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last ?? "UnknownNibName"
    }
}