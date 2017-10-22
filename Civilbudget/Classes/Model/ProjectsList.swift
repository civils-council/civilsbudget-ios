//
//  ProjectsList.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/22/17.
//  Copyright © 2017 Max Odnovolyk. All rights reserved.
//

import Foundation

struct ProjectsList: Decodable {
    
    let items: [Project]
    
    private enum CodingKeys: String, CodingKey {
        case items = "projects"
    }
}
