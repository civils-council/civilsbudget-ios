//
//  BankIdAPI.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire

struct BankIdApi {
    enum Router: URLRequestConvertible {
        static let baseURLString = "https://bankid.privatbank.ua/DataAccessService/das"
        static let clientId = "***REMOVED***"
        static let redirectUri = "civilbudgetua://returncode"
        
        case Authorize
        
        var URLRequest: NSMutableURLRequest {
            let result: (path: String, parameters: [String: AnyObject]?) = {
                switch self {
                case .Authorize:
                    return ("/authorize", ["response_type": "code", "client_id": Router.clientId, "redirect_uri": Router.redirectUri])
                }
                }()
            
            let URL = NSURL(string: Router.baseURLString)!
            let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: result.parameters).0
        }
    }
    
    typealias GetCodeHandler = (code: String) -> Void
    
    static var getCodeHandler: GetCodeHandler?
    
    static func requestCode(completionHandler: GetCodeHandler) {
        getCodeHandler = completionHandler
        
        UIApplication.sharedApplication().openURL(Router.Authorize.URLRequest.URL!)
    }
    
    static func handleResponseURL(url: NSURL) -> Bool {
        guard let code = url.queries["code"] else {
            return false
        }
        
        getCodeHandler?(code: code)
        
        return true
    }
}

extension NSURL {
    var queries: [String: String] {
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