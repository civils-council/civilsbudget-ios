//
//  VoteResult.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/28/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation

struct VoteResult: Decodable {
    
    let warning: String?
    let success: String?
    
    var isSuccessful: Bool {
        return success != nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case warning = "danger"
        case success
    }
}
