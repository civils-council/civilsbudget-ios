//
//  Authorization.swift
//  BankIdSDK
//
//  Created by Max Odnovolyk on 11/20/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire

public struct Authorization: BankIdObjectSerializable {
    let authCode: String?
    let accessToken: String
    let tokenType: String?
    let refreshToken: String
    let expiresIn: Int?
    let scope: String?
    
    init(authCode: String) {
        self.authCode = authCode
        accessToken = ""
        tokenType = nil
        refreshToken = ""
        expiresIn = nil
        scope = nil
    }
    
    public init(response: NSHTTPURLResponse, representation: AnyObject) throws {
        guard let accessToken = representation.valueForKey("access_token") as? String,
            refreshToken = representation.valueForKey("refresh_token") as? String else {
                var failureReason = "Can't serialize Authorization object from representation: \"\(representation)\""
                if let error = representation.valueForKey("error") as? String {
                    let description = (representation.valueForKey("error_description") as? String) ?? ""
                    failureReason = "\(error): \(description)"
                }
                throw Alamofire.Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
        }
        
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        tokenType = representation.valueForKey("token_type") as? String
        expiresIn = representation.valueForKey("expires_in") as? Int
        scope = representation.valueForKey("scope") as? String
        authCode = nil
    }
}