//
//  ServiceSettings.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/2/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire

struct ServiceSettings {
    let bankIdAuthURL: String
}

extension ServiceSettings: ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, let representation: AnyObject) throws {
        guard let bankIdAuthURL = representation.valueForKey("bi_auth_url") as? String else {
            let failureReason = "Can't create ServiceSettings without one of mandatory fields (bi_auth_url)"
            throw Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
        }
        
        self.bankIdAuthURL = bankIdAuthURL
    }
}
