//
//  VotingsViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/26/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import UIKit
import Bond

class VotingsViewController: UITableViewController {
    
    let viewModel = VotingsViewModel()
    var tableController: VotingsTableController!
    var loadingStateView: LoadingStateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoadingStateView()
        
        tableController = VotingsTableController(tableView: tableView, viewModel: viewModel)
        
        refreshControl = UIRefreshControl()
        refreshControl?.bnd_controlEvent.filter({ $0 == .ValueChanged }).observeNew { _ in
            print("Load something")
        }.disposeIn(bnd_bag)
    }
    
    func configureLoadingStateView() {
        
        if let loadingStateView = UIView.loadFirstViewFromNibNamed(LoadingStateView.defaultNibName) as? LoadingStateView,
           let navigationController = navigationController {
            
            let navigationBar = navigationController.navigationBar
            let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
            let statusBarHeight = min(statusBarFrame.height, statusBarFrame.width)
            let topOffset = navigationBar.frame.height + statusBarHeight
            
            navigationController.view.insertSubview(loadingStateView, belowSubview: navigationBar)
            loadingStateView.addConstraintsToFitSuperview(UIEdgeInsets(top: topOffset, left: 0.0, bottom: 0.0, right: 0.0))
            self.loadingStateView = loadingStateView
        }
        
        combineLatest(viewModel.loadingState, viewModel.projectListIsEmpty).bindTo(loadingStateView.state)
        
        loadingStateView.reloadButtonTap.observeNew { [weak self] in
            self?.viewModel.reloadVotingsList()
        }.disposeIn(bnd_bag)
    }
    
    deinit {
        print("Deinit")
    }
}
