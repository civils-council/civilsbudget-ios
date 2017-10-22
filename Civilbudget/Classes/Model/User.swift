//
//  User.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/6/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation

struct User {
    
    let id: Int
    let fullName: String
    let clid: String                    // From Ukrainian BankID System terminology :)
    var votedProjectId: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case clid
        case votedProjectId = "voted_project"
    }
}
