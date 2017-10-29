//
//  VotingTableViewCell.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/28/17.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class VotingTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    var viewModel: VotingViewModel? = nil {
        didSet {
            titleLabel.text = viewModel?.title
            locationLabel.text = viewModel?.location
        }
    }
}