//
//  VotingsTableController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/28/17.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class VotingsTableController: NSObject {
    
    let cellIdentifier = "votingCellIdentifier"
    
    init(tableView: UITableView, viewModel: VotingsViewModel) {
        
    }
}

extension VotingsTableController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        return cell
    }
}