//
//  BIDService.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/7/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire
import CryptoSwift

public let BIDErrorDomain = "com.bankidsdk.error"
public let BIDCanceledCode = 1
public let BIDTimeoutCode = 2

public class BIDService {
    public typealias AuthorizationResponse = Response<Authorization, NSError>
    public typealias AuthorizationResult = Result<Authorization, NSError>
    
    public static var baseAuthURLString = "https://bankid.privatbank.ua/DataAccessService"
    public static var baseDataURLString = "https://bankid.privatbank.ua/ResourceService"
    
    public static var clientID = "c693facc-767a-4a5d-a82a-81e020163e1a"
    public static var clientSecret = ""
    public static var redirectURI = "bankidua://returncode"
    
    public static let allInfoFields: [String: AnyObject] = ["type": "physical", "fields": ["firstName", "middleName", "lastName", "phone", "inn", "clId", "clIdText", "birthDay", "email", "sex", "resident", "dateModification"], "scans": [["type": "passport", "fields": ["link", "dateCreate", "extension", "dateModification"]], ["type": "zpassport", "fields": ["link", "dateCreate", "extension", "dateModification"]], ["type": "inn", "fields": ["link", "dateCreate", "extension", "dateModification"]], ["type": "personalPhoto", "fields": ["link", "dateCreate", "extension", "dateModification"]]], "addresses": [["type": "factual", "fields": [ "country", "state", "area", "city", "street", "houseNo", "flatNo", "dateModification"]], ["type": "birth", "fields": [ "country", "state", "area", "city", "street", "houseNo", "flatNo", "dateModification"]]], "documents": [["type": "passport", "fields": ["series", "number", "issue", "dateIssue", "dateExpiration", "issueCountryIso2", "dateModification"]], ["type": "zpassport", "fields": ["series", "number", "issue", "dateIssue", "dateExpiration", "issueCountryIso2", "dateModification"]]]]
    
    public static var authorization: Authorization?
    
    enum Router: URLRequestConvertible {
        case Authorize
        case GetAccessToken(authCode: String)
        case RefreshAccessToken(refreshToken: String)
        case RequestInformation(fields: [String: AnyObject])
        case GetDocument(link: String)
        
        var baseURLString: String {
            switch self {
            case .Authorize, .GetAccessToken, .RefreshAccessToken:
                return BIDService.baseAuthURLString
            case .RequestInformation, .GetDocument:
                return BIDService.baseDataURLString
            }
        }
        
        var path: String {
            switch self {
            case .Authorize:
                return "/das/authorize"
            case .GetAccessToken:
                return "/oauth/token"
            case .RequestInformation:
                return "/checked/data"
            default:
                return ""
            }
        }
        
        var method: Alamofire.Method {
            switch self {
            case .Authorize, .GetAccessToken, .RefreshAccessToken, .GetDocument:
                return .GET
            case .RequestInformation:
                return .POST
            }
        }
        
        var URLRequest: NSMutableURLRequest {
            let URL = NSURL(string: baseURLString)!
            let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            request.HTTPMethod = method.rawValue
            
            switch self {
            case .Authorize:
                return Alamofire.ParameterEncoding.URL.encode(request,
                    parameters: ["response_type": "code", "client_id": clientID, "redirect_uri": redirectURI]).0
            case .GetAccessToken(let code):
                let calculatedClientSecret = "\(clientID)\(clientSecret)\(code)".sha1()
                return Alamofire.ParameterEncoding.URL.encode(request,
                    parameters: ["grant_type": "authorization_code",
                                 "client_id": clientID,
                                 "client_secret":  calculatedClientSecret,
                                 "code": code,
                                 "redirect_uri": redirectURI]).0
            case .RequestInformation(let fields):
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                if let authorization = BIDService.authorization {
                    request.setValue("Bearer \(authorization.accessToken), Id \(BIDService.clientID)", forHTTPHeaderField: "Authorization")
                }
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                return Alamofire.ParameterEncoding.JSON.encode(request, parameters: fields).0
            default:
                return request
            }
        }
    }
    
    public struct Authorization: ResponseObjectSerializable {
        let authCode: String?
        let accessToken: String
        let tokenType: String?
        let refreshToken: String
        let expiresIn: Int?
        let scope: String?
        
        init(authCode: String) {
            self.authCode = authCode
            accessToken = ""
            tokenType = nil
            refreshToken = ""
            expiresIn = nil
            scope = nil
        }
        
        public init(response: NSHTTPURLResponse, representation: AnyObject) throws {
            guard let accessToken = representation.valueForKey("access_token") as? String,
                refreshToken = representation.valueForKey("refresh_token") as? String else {
                    var failureReason = "Can't serialize Authorization object from representation: \"\(representation)\""
                    if let error = representation.valueForKey("error") as? String {
                        let description = (representation.valueForKey("error_description") as? String) ?? ""
                        failureReason = "\(error): \(description)"
                    }
                    throw Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
            }
            
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            tokenType = representation.valueForKey("token_type") as? String
            expiresIn = representation.valueForKey("expires_in") as? Int
            scope = representation.valueForKey("scope") as? String
            authCode = nil
        }
    }
    
    public struct Information: ResponseObjectSerializable {
        
        
        public init(response: NSHTTPURLResponse, representation: AnyObject) throws {
            
        }
    }
    
    public class func errorWithCode(code: Int, description: String) -> NSError {
        return NSError(domain: BIDErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}