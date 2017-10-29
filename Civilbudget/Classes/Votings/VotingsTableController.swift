//
//  VotingsTableController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/28/17.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import Bond

class VotingsTableController: NSObject {
    
    private let cellIdentifier = "votingCellIdentifier"
    
    private weak var tableView: UITableView?
    private var votings: ObservableArray<Voting>
    private var selectedVoting: VotingViewModel?
    
    init(tableView: UITableView, viewModel: VotingsViewModel, selectedVoting: VotingViewModel?) {
        self.tableView = tableView
        self.votings = viewModel.votings
        self.selectedVoting = selectedVoting
        
        super.init()
        
        tableView.dataSource = self
        
        votings.observeNew { [weak self] arrayEvent in
            guard let tableView = self?.tableView else {
                return
            }
            
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
            
            if let selectedVoting = self?.selectedVoting,
               votings = self?.votings.array,
               selectedIndex = votings.indexOf({ $0.id == selectedVoting.id }) {
                    
                self?.tableView?.selectRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
            
            }
        }.disposeIn(bnd_bag)
    }
}

extension VotingsTableController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return votings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        if let cell = cell as? VotingTableViewCell {
            cell.viewModel = VotingViewModel(voting: votings[indexPath.row])
        }
        
        return cell
    }
}