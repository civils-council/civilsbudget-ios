//
//  Error.swift
//  BankIdSDK
//
//  Created by Max Odnovolyk on 11/21/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation

public class Error: NSError {
    
    /// BankIdSDK error domain
    public static let errorDomain = "com.bankidsdk.error"
    
    convenience init(code: ErrorCode, description: String? = nil) {
        self.init(domain: Error.errorDomain, code: code.rawValue, userInfo: [NSLocalizedFailureReasonErrorKey: description ?? code.reason])
    }
}

public enum ErrorCode: Int {
    case Canceled = 1
    case Timeout = 2
    
    var reason: String {
        switch self {
        case .Canceled: return "Authorization was canceled by User"
        case .Timeout: return "Timeout"
        }
    }
}