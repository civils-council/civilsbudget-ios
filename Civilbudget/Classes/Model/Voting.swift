//
//  Voting.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/22/17.
//  Copyright © 2017 Max Odnovolyk. All rights reserved.
//

import Foundation

struct Voting: Decodable {
    
    enum Status: String, Decodable {
        case archived
        case active
        case future
    }
    
    let id: Int
    let status: Status
    let title: String
    let description: String?
    let location: String
    let maxVotesCount: Int
    let dateFrom: Date
    let dateTo: Date
    let logo: URL?
    let backgroundImage: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case status
        case title
        case description
        case location
        case maxVotesCount = "max_votes_count"
        case dateFrom = "date_from"
        case dateTo = "date_to"
        case logo
        case backgroundImage = "background_image"
    }
}
