//
//  TopToolbarView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/25/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import UIKit

class ProjectsTopToolbarView: UIView {
    
    @IBOutlet var votingsListButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        votingsListButton.setTitle("\u{f0c9}", forState: .Normal)
    }
    
    @IBAction func votingsListButtonTapped(sender: UIButton) {
        print("votingsListButtonTapped")
    }
}