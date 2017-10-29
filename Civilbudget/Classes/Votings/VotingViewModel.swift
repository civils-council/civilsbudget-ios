//
//  VotingViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/29/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import Foundation

struct VotingViewModel {
    
    let id: Int
    let title: String
    let location: String?
    
    init(voting: Voting) {
        id = voting.id
        title = voting.title
        location = voting.location?.lowercaseString.capitalizedString
    }
}

extension VotingViewModel: Equatable { }

func ==(lhs: VotingViewModel, rhs: VotingViewModel) -> Bool {
    return lhs.id == rhs.id
}