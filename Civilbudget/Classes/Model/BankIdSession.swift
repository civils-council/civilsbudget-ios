//
//  BankIdSession.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/20/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation

struct BankIdSession: Decodable {
    
    public let accessToken: String
    public let tokenType: String?
    public let refreshToken: String
    public let expiresIn: Int?
    public let scope: String?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope
    }
}
