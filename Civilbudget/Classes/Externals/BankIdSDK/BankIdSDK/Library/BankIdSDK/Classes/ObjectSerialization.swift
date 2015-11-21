//
//  BankIdObjectSerialization.swift
//  BankIdSDK
//
//  Created by Max Odnovolyk on 11/20/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire

public protocol BankIdObjectSerializable {
    init(response: NSHTTPURLResponse, representation: AnyObject) throws
}

public protocol BankIdCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) throws -> [Self]
}

extension Request {
    public func responseBankIdObject<T: BankIdObjectSerializable>(completionHandler: Response<T, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    do {
                        return .Success(try T(response: response, representation: value))
                    } catch let error as NSError {
                        return .Failure(error)
                    }
                } else {
                    let failureReason = "Response could not be serialized due to nil response"
                    let error = Alamofire.Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    public func responseBankIdCollection<T: BankIdCollectionSerializable>(completionHandler: Response<[T], NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    do {
                        return .Success(try T.collection(response: response, representation: value))
                    } catch let error as NSError {
                        return .Failure(error)
                    }
                } else {
                    let failureReason = "Response collection could not be serialized due to nil response"
                    let error = Alamofire.Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}