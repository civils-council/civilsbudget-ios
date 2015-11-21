//
//  Extensions.swift
//  BankIdSDK
//
//  Created by Max Odnovolyk on 11/20/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation

// MARK: - NSURL extension

/*
    Adds ability to get queries from URL in handy dictionary representation
*/
extension NSURL {
    
    /// Dictionary representation of `queriesItem`
    var bid_queries: [String: String] {
        guard let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else {
                return [:]
        }
        
        var queries: [String: String] = [:]
        for item in queryItems {
            queries[item.name] = item.value
        }
        
        return queries
    }
}