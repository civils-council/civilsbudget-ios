//
//  VotingViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/29/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import Foundation

struct VotingViewModel {
    
    let title: String
    let location: String?
    
    init(voting: Voting) {
        title = voting.title
        location = voting.location?.lowercaseString.capitalizedString
    }
}