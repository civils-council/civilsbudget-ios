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
    
    let viewModel = Observable<ProjectsViewModel?>(nil)
    
    @IBOutlet var votingsListButton: UIButton!
    @IBOutlet var votingTitleLabel: UILabel!
    
    private var bindBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        votingsListButton.setTitle("\u{f0c9}", forState: .Normal)
        
        viewModel.observeNew { [weak self] viewModel in
            self?.bindBag = DisposeBag()
            
            if let viewModel = viewModel, let strongSelf = self {
                viewModel.votingTitle.bindTo(strongSelf.votingTitleLabel.bnd_text).disposeIn(strongSelf.bindBag)
                strongSelf.votingsListButton.bnd_tap.bindTo(viewModel.shouldPresentVotingsList).disposeIn(strongSelf.bindBag)
            }
        }
    }
}