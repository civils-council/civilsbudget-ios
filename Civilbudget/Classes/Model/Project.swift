//
//  Project.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import Alamofire

struct Project {
    let id: Int
    let title: String
    let description: String
    let source: String?
    let picture: String?
    let createdAt: NSDate?
    let likes: Int?
    let owner: String?
    let budget: Int?
    let voted: Bool
}

extension Project: ResponseObjectSerializable, ResponseCollectionSerializable {
    static var dateFormatter: NSDateFormatter {
        let formatterDictionaryKey = "CreatedDateFormatterKey"
        let threadDictionary = NSThread.currentThread().threadDictionary
        var formatter = threadDictionary[formatterDictionaryKey] as? NSDateFormatter
        if formatter == nil {
            formatter = NSDateFormatter()
            formatter!.dateFormat = "YYYY-MM-dd'T'HH:mm:ssxx"
            threadDictionary[formatterDictionaryKey] = formatter!
        }
        return formatter!
    }
    
    struct Constants {
        static let maxShortDescriptionLength = 10
    }
    
    init(response: NSHTTPURLResponse, var representation: AnyObject) throws {
        if let projectDictionary = representation.valueForKey("project") as? NSDictionary
            where representation.count == 1 {
            representation = projectDictionary
        }
        
        guard let id = representation.valueForKeyPath("id") as? Int,
            title = representation.valueForKeyPath("title") as? String,
            description = representation.valueForKeyPath("description") as? String
            else {
                let failureReason = "Can't create project without one of mandatory fields: id, title, description"
                throw Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
        }
        
        self.id = id
        self.title = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.description = description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        self.source = representation.valueForKeyPath("source") as? String
        self.picture = representation.valueForKeyPath("picture") as? String
        self.createdAt = Project.dateFormatter.dateFromString((representation.valueForKeyPath("createdAt") as? String) ?? "")
        self.likes = representation.valueForKeyPath("likes_count") as? Int
        self.owner = representation.valueForKeyPath("owner") as? String
        self.budget = representation.valueForKeyPath("charge") as? Int
        self.voted = (representation.valueForKeyPath("vote") as? Bool) ?? false
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) throws -> [Project] {
        guard let representation = representation.valueForKeyPath("projects") as? [[String: AnyObject]] else {
            let failureReason = "Can't cast root JSON collection to Project list"
            throw Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
        }
        
        return representation.flatMap { try! Project(response: response, representation: $0) }
    }
}