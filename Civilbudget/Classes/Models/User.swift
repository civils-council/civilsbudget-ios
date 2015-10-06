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
    let apiKey: String
    let apiKeyExpired: String
}

extension User {
    typealias AuthorizeResponse = Response<User, NSError>
    
    static func authorizeWithBankIdCode(bankIdCode: String, completionHandler: (AuthorizeResponse -> Void)? = nil) {
        Alamofire.request(CivilbudgetAPI.Router.Authorize(code: bankIdCode))
            .responseObject { (response: AuthorizeResponse) in
                switch response.result {
                case .Success(let user):
                    CivilbudgetAPI.Router.APIKey = user.apiKey
                case .Failure(let error):
                    log.error(error.localizedDescription)
                }
                completionHandler?(response)
        }
    }
}

extension User: ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, var representation: AnyObject) {
        if let userDictionary = representation.valueForKey("project") as? NSDictionary
            where representation.count == 1 {
                representation = userDictionary
        }
        
        guard let id = representation.valueForKey("project") as? Int,
            fullName = representation.valueForKey("fullName") as? String,
            apiKey = representation.valueForKey("") as? String,
            apiKeyExpired = representation.valueForKey("") as? String
            else {
                log.error("Can't create user without mandatory field (id, fullName, apiKey, apiKeyExpired)")
                return nil
        }
        
        self.id = id
        self.fullName = fullName
        self.apiKey = apiKey
        self.apiKeyExpired = apiKeyExpired
    }
}