//
//  TopToolbarView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/25/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import UIKit
import Bond

class ProjectsTopToolbarView: UIView {
    
    var viewModel: ProjectsViewModel? = nil {
        didSet {
            bindBag = DisposeBag()
            
            if let viewModel = viewModel {
                viewModel.votingTitle.bindTo(votingTitleLabel.bnd_text).disposeIn(bindBag)
                votingsListButton.bnd_tap.bindTo(viewModel.shouldPresentVotingsList).disposeIn(bindBag)
            }
        }
    }
    
    @IBOutlet var votingsListButton: UIButton!
    @IBOutlet var votingTitleLabel: UILabel!
    
    private var bindBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        votingsListButton.setTitle("\u{f0c9}", forState: .Normal)
    }
}