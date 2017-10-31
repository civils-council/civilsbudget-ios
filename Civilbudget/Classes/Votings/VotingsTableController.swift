//
//  VotingsTableController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/28/17.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import Bond

struct VotingGroup {
    let status: VotingStatus
    let items: [Voting]
}

class VotingsTableController: NSObject {
    
    private let cellIdentifier = "votingCellIdentifier"
    
    private weak var tableView: UITableView?
    private let votings: ObservableArray<Voting>
    private let sections = Observable<[VotingGroup]>([])
    private let selectedVoting: VotingViewModel?
    
    init(tableView: UITableView, viewModel: VotingsViewModel, selectedVoting: VotingViewModel?) {
        self.tableView = tableView
        self.votings = viewModel.votings
        self.selectedVoting = selectedVoting
        
        super.init()
        
        tableView.dataSource = self
        tableView.hidden = true
        
        votings.map(groupVotings).bindTo(sections)

        sections.observeNew { [weak self] sections in
            guard let tableView = self?.tableView else {
                return
            }
            
            tableView.reloadData()
            
            if tableView.hidden {
                self?.presentTableView(tableView)
            }
            
            if let selectedVoting = self?.selectedVoting,
               let selectedIndexPath = self?.indexPathFor(selectedVoting, within: sections) {
                    
                self?.tableView?.selectRowAtIndexPath(selectedIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.Middle)
            
            }
        }.disposeIn(bnd_bag)
    }
    
    func groupVotings(event: ObservableArrayEvent<Array<Voting>>) -> [VotingGroup] {
        let votings = event.sequence
        var groupedVotings: [VotingStatus: [Voting]] = [:]
        
        votings.forEach { voting in
            if case nil = groupedVotings[voting.status]?.append(voting) {
                groupedVotings[voting.status] = [voting]
            }
        }
        
        let groups = groupedVotings.map { VotingGroup(status: $0.0, items: $0.1) }
        let sortedGroups = groups.sort { $0.0.status.sortingIndex < $0.1.status.sortingIndex }
        
        return sortedGroups
    }
    
    func indexPathFor(selectedVoting: VotingViewModel, within sections: [VotingGroup]) -> NSIndexPath? {
        for (sectionIndex, section) in sections.enumerate() {
            if let rowIndex = section.items.indexOf({ $0.id == selectedVoting.id }) {
                return NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
            }
        }
        
        return nil
    }
    
    func presentTableView(tableView: UITableView) {
        tableView.alpha = 0.0
        tableView.hidden = false
        
        UIView.animateWithDuration(0.3) {
            tableView.alpha = 1.0
        }
    }
}

extension VotingsTableController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.value.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.value[section].items.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections.value[section].status.title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        if let cell = cell as? VotingTableViewCell {
            cell.viewModel = VotingViewModel(voting: sections.value[indexPath.section].items[indexPath.row])
        }
        
        return cell
    }
}