//
//  BIDService.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/7/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire

public class BIDService {
    public struct Constants {
        public static let ErrorDomain = "com.modnovolyk.BIDSDK.error"
        public static let CanceledCode = 1
        public static let TimeoutCode = 2
    }
    
    enum Router: URLRequestConvertible {
        case Authorize
        
        var URLRequest: NSMutableURLRequest {
            let result: (path: String, parameters: [String: AnyObject]?) = {
                switch self {
                case .Authorize:
                    return ("/authorize", ["response_type": "code", "client_id": BIDService.clientID, "redirect_uri": BIDService.redirectURI])
                }
                }()
            
            let URL = NSURL(string: BIDService.baseURLString)!
            let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: result.parameters).0
        }
    }
    
    public typealias AuthorizationResult = Result<Authorization, NSError>
    
    public static var baseURLString = "https://bankid.privatbank.ua/DataAccessService/das"
    public static var clientID = "c693facc-767a-4a5d-a82a-81e020163e1a"
    public static var redirectURI = "civilbudgetua://returncode"
    
    public struct Authorization {
        let authCode: String
        
        init(authCode: String) {
            self.authCode = authCode
        }
    }
    
    public static func errorWithCode(code: Int, description: String) -> NSError {
        return NSError(domain: Constants.ErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}