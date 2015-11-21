//
//  BankIdService.swift
//  BankIdSDK
//
//  Created by Max Odnovolyk on 11/20/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire

public typealias AuthorizationResult = Result<Authorization, NSError>

/**
    `Service` is responsible for holding all necessary information to perform requests
    to BankID service. Currently only one instance of a class can be created at the same time.
*/
public class Service {
    
    /// `Service.Configuration` object used to configure BankID's `client_id`, `client_secret` and URLs
    public static let configuration = Configuration()
    
    /// `Authorization` is an struct that contains current session data (`auth_code`, `access_token`, etc)
    public static var authorization: Authorization?
}