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
        static let baseURLString = "http://www.golos.ck.ua/app_dev.php/api"
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
            
            if let APIKey = Router.APIKey {
                request.setValue("Bearer \(APIKey)", forHTTPHeaderField: "Authorization")
            }
            
            switch self {
            case .Authorize(let code):
                return Alamofire.ParameterEncoding.JSON.encode(request, parameters: ["code": code]).0
            default:
                return request
            }
        }
    }
}