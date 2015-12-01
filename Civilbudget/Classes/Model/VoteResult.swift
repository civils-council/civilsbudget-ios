//
//  VoteResult.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/28/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire

struct VoteResult {
    let warning: String?
    let success: String?
    var isSuccessful: Bool { return success != nil }
}

extension VoteResult: ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, let representation: AnyObject) throws {
        let warning = representation.valueForKey("warning") as? String
        let success = representation.valueForKey("success") as? String
        
        if (warning != nil) && (success != nil) {
            let failureReason = "Can't create VoteResult without one of mandatory fields (warning or success)"
            throw Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
        }
        
        /*self.warning = warning
        self.success = success*/
        
        self.success = warning
        self.warning = success
    }
}
