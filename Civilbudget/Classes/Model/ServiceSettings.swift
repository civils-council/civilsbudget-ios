//
//  ServiceSettings.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/2/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation

struct ServiceSettings: Decodable {
    
    let bankIdClientId: String
    let bankIdAuthURL: URL
    let bankIdRedirectURI: URL
    
    private enum CodingKeys: String, CodingKey {
        case bankIdClientId = "bi_client_id"
        case bankIdAuthURL = "bi_auth_url"
        case bankIdRedirectURI = "bi_redirect_uri"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        bankIdClientId = try container.decode(String.self, forKey: .bankIdClientId)
        bankIdAuthURL = try container.decode(URL.self, forKey: .bankIdAuthURL).appendingPathComponent("DataAccessService")
        bankIdRedirectURI = try container.decode(URL.self, forKey: .bankIdRedirectURI)
    }
}
