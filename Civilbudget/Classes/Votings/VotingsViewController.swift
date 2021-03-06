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
    let selectedVotingViewModel = Observable<VotingViewModel?>(nil)
    var tableController: VotingsTableController!
    var loadingStateView: LoadingStateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureNavigationItems()
        configureLoadingStateView()
        configurePullDownToRefresh()
        
        tableController = VotingsTableController(tableView: tableView, viewModel: viewModel, selectedVoting: selectedVotingViewModel.value)
        
        viewModel.loadVotingsList()
    }
    
    func configureNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = CivilbudgetStyleKit.themeDarkBlue
            navigationBar.barStyle = .Black
            navigationBar.translucent = false
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
    }
    
    func configureNavigationItems() {
        if let _ = selectedVotingViewModel.value {
            let closeButton = UIButton(type: .System)
            closeButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 24.0)
            closeButton.setTitleColor(.whiteColor(), forState: .Normal)
            closeButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 2.0, right: 0.0)
            closeButton.setTitle("\u{00d7}", forState: .Normal)
            closeButton.sizeToFit()
            
            closeButton.bnd_tap.observeNew { [weak self] _ in
                self?.dismissViewControllerAnimated(true, completion: nil)
            }.disposeIn(bnd_bag)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        }
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
        
        combineLatest(viewModel.loadingState, viewModel.votingsListIsEmpty).bindTo(loadingStateView.state)
        
        loadingStateView.reloadButtonTap.observeNew { [weak self] in
            self?.viewModel.loadVotingsList()
        }.disposeIn(bnd_bag)
    }
    
    func configurePullDownToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.bnd_controlEvent.filter({ $0 == .ValueChanged }).observeNew { [weak self] _ in
            self?.viewModel.loadVotingsList()
        }.disposeIn(bnd_bag)
        
        viewModel.loadingState.map({ !($0 == VotingsViewModel.Constanst.loadingState) }).observeNew { [weak self] shouldStop in
            if shouldStop {
                self?.refreshControl?.endRefreshing()
            }
        }
        
        navigationController?.view.backgroundColor = .whiteColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let votingCell = tableView.cellForRowAtIndexPath(indexPath) as? VotingTableViewCell
        selectedVotingViewModel.value = votingCell?.viewModel
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
