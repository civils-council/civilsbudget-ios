//
//  ServiceConfiguration.swift
//  BankIdSDK
//
//  Created by Max Odnovolyk on 11/20/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

extension Service {
    
    /**
        `Service.Configuration` used to configure all needed BankID parameters
    */
    public class Configuration {
        public var baseAuthURLString = "https://bankid.privatbank.ua/DataAccessService"
        public var baseDataURLString = "https://bankid.privatbank.ua/ResourceService"
        
        public var clientID = "c693facc-767a-4a5d-a82a-81e020163e1a"
        public var clientSecret = ""
        public var redirectURI = "bankidua://returncode"
    }
}