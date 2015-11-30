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
    let clid: String                    // From Ukrainian BankID System terminology :)
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

// MARK: - Methods for storing and recovering data from keychain

extension User {
    static let keychainUserAccount = "DefaultUser"
    
    static func readFromSecureStorage() -> User? {
        guard let data = Locksmith.loadDataForUserAccount(User.keychainUserAccount),
            id = data["id"] as? Int,
            fullName = data["fullName"] as? String,
            clid = data["clid"] as? String else {
                return nil
        }
        
        return User(id: id, fullName: fullName, clid: clid)
    }
    
    func saveToSecureStorage() {
        let dictionary: [String: AnyObject] = ["id": id, "fullName": fullName, "clid": clid]
        let _ = try? Locksmith.saveData(dictionary, forUserAccount: User.keychainUserAccount)
    }
    
    func removeFromSecureStorage() {
        let _ = try? Locksmith.deleteDataForUserAccount(User.keychainUserAccount)
    }
}

// MARK: - Manage logged in user details

extension User {
    static let currentUser: Observable<User?> = {
        let user = /*User.readFromSecureStorage()*/ User(id: 1, fullName: "Max Odnovolyk", clid: "Test")
        let observable = Observable<User?>(user)
        observable.observeNew { $0?.saveToSecureStorage() }
        return observable
    }()
    
    static func clearCurrentUser() {
        User.currentUser.value?.removeFromSecureStorage()
        User.currentUser.value = nil
    }
    
    static func isAuthorized() -> Bool {
        return currentUser.value != nil
    }
}