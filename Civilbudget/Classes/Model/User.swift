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
    var votedProjectId: Int?
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
        self.votedProjectId = representation.valueForKey("voted_project") as? Int
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
        let votedProjectId = data["votedProjectId"] as? Int
        
        return User(id: id, fullName: fullName, clid: clid, votedProjectId: votedProjectId)
    }
    
    func saveToSecureStorage() {
        var dictionary: [String: AnyObject] = ["id": id, "fullName": fullName, "clid": clid]
        if votedProjectId != nil {
            dictionary["votedProjectId"] = votedProjectId
        }
        let _ = try? Locksmith.saveData(dictionary, forUserAccount: User.keychainUserAccount)
    }
    
    func removeFromSecureStorage() {
        let _ = try? Locksmith.deleteDataForUserAccount(User.keychainUserAccount)
    }
}

// MARK: - Manage logged in user details

extension User {
    static let currentUser: Observable<User?> = {
        let user = User.readFromSecureStorage()
        let observable = Observable<User?>(user)
        
        // Store user only during app launch
        /* observable.observeNew { user in
            user?.saveToSecureStorage()
        }*/
        
        return observable
    }()
    
    static func clearCurrentUser() {
        User.currentUser.value?.removeFromSecureStorage()
        
        let cookiesStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if let url = NSURL(string: CivilbudgetAPI.Router.rootURL), cookies = cookiesStorage.cookiesForURL(url) {
            for cookie in cookies {
                cookiesStorage.deleteCookie(cookie)
            }
        }
        
        User.currentUser.value = nil
    }
    
    static func isAuthorized() -> Bool {
        return currentUser.value != nil
    }
}

// MARK: - Warning was shown before

extension User {
    private static let warningWasShownBeforeKey = "WarningWasShownKey"
    
    static var warningWasShownBefore: Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        guard let _ = userDefaults.objectForKey(User.warningWasShownBeforeKey) else {
            userDefaults.setBool(true, forKey: User.warningWasShownBeforeKey)
            userDefaults.synchronize()
            return false
        }
        return true
    }
}
