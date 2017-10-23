//
//  Project.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation

struct Project: Decodable {
    
    let id: Int
    let title: String
    let description: String
    let source: String
    let picture: URL?
    let createdAt: Date
    let owner: String?
    let ownerAvatar: URL?
    let budget: Int
    var likes: Int
    var voted: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case source
        case picture
        case createdAt = "created_at"
        case owner
        case ownerAvatar = "owner_avatar"
        case budget = "charge"
        case likes = "likes_count"
        case voted
    }
}
