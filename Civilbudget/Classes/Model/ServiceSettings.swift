//
//  ServiceSettings.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/2/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire

struct ServiceSettings {
    let bankIdClientId: String
    let bankIdAuthURL: String
    let bankIdRedirectURI: String
}

extension ServiceSettings: ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, let representation: AnyObject) throws {
        guard let bankIdClientId = representation.valueForKey("bi_client_id") as? String,
            bankIdAuthURL = representation.valueForKey("bi_auth_url") as? String,
            bankIdRedirectURI = representation.valueForKey("bi_redirect_uri") as? String
            else {
                let failureReason = "Can't create ServiceSettings without one of mandatory fields (bi_client_id, bi_auth_url, bi_redirect_uri)"
                throw Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
        }
        
        self.bankIdClientId = bankIdClientId
        self.bankIdAuthURL = bankIdAuthURL + "/DataAccessService"   // Base URL
        self.bankIdRedirectURI = bankIdRedirectURI
    }
}
