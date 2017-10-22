//
//  VotingsList.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/22/17.
//  Copyright © 2017 Max Odnovolyk. All rights reserved.
//

import Foundation

struct VotingsList: Decodable {
    
    let items: [Voting]
    
    private enum CodingKeys: String, CodingKey {
        case items = "votings"
    }
}
