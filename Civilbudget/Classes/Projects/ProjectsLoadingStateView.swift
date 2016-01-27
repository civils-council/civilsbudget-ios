//
//  ProjectsLoadingStateView.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/28/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import Bond

class ProjectsLoadingStateView: UIView, LoadableView {
    @IBOutlet weak var loadingFailedContainerView: UIView!
    @IBOutlet weak var loadingErrorLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var loadingContainerView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    let state = Observable(loading: LoadingState.NoData(label: nil), isEmpty: true)
    let reloadButtonTap = Observable()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure UI
        backgroundColor = CivilbudgetStyleKit.loadingStatusBackgroundGrey
        reloadButton.setTitle("Спробувати ще раз\n\u{f021}", forState: .Normal)
        reloadButton.titleLabel?.lineBreakMode = .ByWordWrapping
        reloadButton.titleLabel?.textAlignment = .Center
        reloadButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        loadingErrorLabel.textColor = CivilbudgetStyleKit.bottomCopyrightGrey

        // Configure bindings
        state.observeNew { [weak self] state in
            self?.superview?.hidden = true
            
            if !state.isEmpty {
                return
            }
            
            self?.loadingFailedContainerView.hidden = true
            self?.loadingContainerView.hidden = true
            switch state.loading {
            case let .Loading(label):
                self?.superview?.hidden = false
                self?.loadingLabel.text = label
                self?.loadingContainerView.hidden = false
            case let .Failure(description):
                self?.superview?.hidden = false
                self?.loadingErrorLabel.text = description
                self?.loadingFailedContainerView.hidden = false
            case let .NoData(description):
                self?.superview?.hidden = false
                self?.loadingErrorLabel.text = description
                self?.loadingFailedContainerView.hidden = false
            default: break
            }
        }.disposeIn(bnd_bag)
        
        reloadButton.bnd_tap.bindTo(reloadButtonTap).disposeIn(bnd_bag)
    }
}
