//
//  Constants.swift
//  BankIdSDK
//
//  Created by Max Odnovolyk on 11/20/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation

public struct Constants {
    
    /// Constant used to get all available user information from BankID service
    public static let allInfoFields: [String: AnyObject] = ["type": "physical", "fields": ["firstName", "middleName", "lastName", "phone", "inn", "clId", "clIdText", "birthDay", "email", "sex", "resident", "dateModification"], "scans": [["type": "passport", "fields": ["link", "dateCreate", "extension", "dateModification"]], ["type": "zpassport", "fields": ["link", "dateCreate", "extension", "dateModification"]], ["type": "inn", "fields": ["link", "dateCreate", "extension", "dateModification"]], ["type": "personalPhoto", "fields": ["link", "dateCreate", "extension", "dateModification"]]], "addresses": [["type": "factual", "fields": [ "country", "state", "area", "city", "street", "houseNo", "flatNo", "dateModification"]], ["type": "birth", "fields": [ "country", "state", "area", "city", "street", "houseNo", "flatNo", "dateModification"]]], "documents": [["type": "passport", "fields": ["series", "number", "issue", "dateIssue", "dateExpiration", "issueCountryIso2", "dateModification"]], ["type": "zpassport", "fields": ["series", "number", "issue", "dateIssue", "dateExpiration", "issueCountryIso2", "dateModification"]]]]
}