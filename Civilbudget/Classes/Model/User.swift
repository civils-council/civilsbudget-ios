//
//  User.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/6/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire
import Bond
import Locksmith

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

// MARK: - Locksmith protocols to support writting to Keychain

extension User: ReadableSecureStorable,
                CreateableSecureStorable,
                DeleteableSecureStorable,
                GenericPasswordSecureStorable {
    var service: String { return "civilbudget_api"}
    var account: String { return "current_user" }
    var data: [String: AnyObject] {
        return ["id": id,
                "fullName": fullName,
                "clid": clid]
    }
}

// MARK: - Manage logged in user details

extension User {
    static var currentUser: Observable<User?> = {
        let observable = Observable<User?>(nil)
        
        return observable
    }()
}