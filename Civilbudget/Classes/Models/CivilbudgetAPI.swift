//
//  CivilbudgetAPI.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Alamofire

struct CivilbudgetAPI {
    enum Router: URLRequestConvertible {
        static let baseURLString = "http://golos.ck.ua/api"
        static var APIKey: String?
        
        case Authorize(code: String)
        case GetProjects
        case GetProject(id: Int)
        case LikeProject(id: Int)
        
        var path: String {
            switch self {
            case .Authorize:
                return "/authorization"
            case .GetProjects:
                return "/projects"
            case .GetProject(let id):
                return "/projects/\(id)"
            case .LikeProject(let id):
                return "/projects/\(id)/like"
            }
        }
        
        var method:  Alamofire.Method {
            switch self {
            case .Authorize, .LikeProject:
                return .POST
            case .GetProjects, .GetProject:
                return .GET
            }
        }
        
        var URLRequest: NSMutableURLRequest {
            let URL = NSURL(string: Router.baseURLString)!
            let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            request.HTTPMethod = method.rawValue
            
            if let token = Router.APIKey {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            switch self {
            case .Authorize(let code):
                return Alamofire.ParameterEncoding.JSON.encode(request, parameters: ["user" : ["code": code]]).0
            default:
                return request
            }
        }
    }
    
    struct Error: ResponseObjectSerializable {
        let code: Int
        let message: String
        
        init?(response: NSHTTPURLResponse, var representation: AnyObject) {
            if let errorDictionary = representation.valueForKey("error") as? NSDictionary
                where representation.count == 1 {
                    representation = errorDictionary
            }
            
            guard let code = representation.valueForKey("code") as? Int,
                message = representation.valueForKey("message") as? String
                else {
                    log.error("Can't create error without mandatory field (code, message)")
                    return nil
            }
            
            self.code = code
            self.message = message
        }
    }
}