//
//  Voting.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/29/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import Bond
import Alamofire

/*"logo": "https://test.vote.imisto.com.ua/bundles/app/img/logo_poltava.png",
"background_image": "https://test.vote.imisto.com.ua/bundles/app/img/homebanner_poltava.png",
"voted": 3633,
"id": 1,
"status": "archived",
"short_description": "виріши долю громадського бюджету міста Полтава на 2017 рік.",
"title": "Малі проекти",
"description": "Опис Малих проектів",
"max_votes_count": 1,
"date_from": "2016-10-17T00:00:00+00:00",
"date_to": "2016-10-31T23:59:00+00:00",
"location": "ПОЛТАВА"*/

enum VotingStatus: String {
    case Archived = "archived"
    case Active = "active"
    case Future = "future"
    case Other
}

struct Voting {
    let id: Int
    let title: String
    let description: String
    let shortDescription: String
    let status: VotingStatus
    let logo: NSURL?
    let backgroundImage: NSURL?
    let dateFrom: NSDate
    let dateTo: NSDate
    let maxVotesCount: Int
    let location: String?
    let voted: Int?
}

extension Voting: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    init(response: NSHTTPURLResponse, representation: AnyObject) throws {
        guard let id = representation.valueForKeyPath("id") as? Int,
            title = representation.valueForKeyPath("title") as? String,
            description = representation.valueForKeyPath("description") as? String,
            shortDescription = representation.valueForKeyPath("short_description") as? String,
            maxVotesCount = representation.valueForKeyPath("max_votes_count") as? Int,
            dateFrom = Project.dateFormatter.dateFromString((representation.valueForKeyPath("date_from") as? String) ?? ""),
            dateTo = Project.dateFormatter.dateFromString((representation.valueForKeyPath("date_to") as? String) ?? "")
            else {
                let failureReason = "Can't create project without one of mandatory fields: id, title, short_description"
                throw Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
        }
        
        self.id = id
        self.title = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.description = description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.shortDescription = shortDescription.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.status = VotingStatus(rawValue: (representation.valueForKey("status") as? String) ?? "") ?? .Other
        self.logo = NSURL(string: (representation.valueForKeyPath("logo") as? String) ?? "")
        self.backgroundImage = NSURL(string: (representation.valueForKeyPath("background_image") as? String) ?? "")
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.maxVotesCount = maxVotesCount
        self.location = representation.valueForKeyPath("location") as? String
        self.voted = representation.valueForKeyPath("voted") as? Int
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) throws -> [Voting] {
        guard let representation = representation.valueForKeyPath("votings") as? [[String: AnyObject]] else {
            let failureReason = "Can't cast root JSON collection to Votings list"
            throw Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
        }
        
        return representation.flatMap { try! Voting(response: response, representation: $0) }
    }
}