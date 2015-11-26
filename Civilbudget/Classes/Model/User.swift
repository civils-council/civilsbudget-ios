//
//  User.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/6/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire

struct User {
    let id: Int
    let fullName: String
    let clid: String
}

extension User: ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, var representation: AnyObject) throws {
        if let userDictionary = representation.valueForKey("user") as? NSDictionary
            where representation.count == 1 {
                representation = userDictionary
        }
        
        guard let id = representation.valueForKey("id") as? Int,
            fullName = representation.valueForKey("full_name") as? String,
            clid = representation.valueForKey("clid") as? String
            else {
                let failureReason = "Can't create user without one of mandatory fields (id, fullName, clid)"
                throw Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
        }
        
        self.id = id
        self.fullName = fullName
        self.clid = clid
    }
}