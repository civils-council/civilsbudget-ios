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
        static let baseURLString = "http://www.golos.ck.ua/api"
        
        case GetSettings
        case Authorize(accessToken: String)
        case GetProjects(clid: String?)
        case GetProject(id: Int)
        case LikeProject(id: Int, clid: String)
        
        var path: String {
            switch self {
            case .GetSettings:
                return "/settings"
            case .Authorize:
                return "/authorization"
            case .GetProjects(_):
                return "/projects"
            case let .GetProject(id):
                return "/projects/\(id)"
            case let .LikeProject(id, _):
                return "/projects/\(id)/like"
            }
        }
        
        var method:  Alamofire.Method {
            switch self {
            case .LikeProject:
                return .POST
            case .GetSettings, .Authorize, .GetProjects, .GetProject:
                return .GET
            }
        }
        
        var URLRequest: NSMutableURLRequest {
            let URL = NSURL(string: Router.baseURLString)!
            let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            request.HTTPMethod = method.rawValue
            
            switch self {
            case let .Authorize(accessToken):
                return Alamofire.ParameterEncoding.URL.encode(request, parameters: ["code": accessToken]).0
            case let .GetProjects(clid):
                let parameters: [String: AnyObject]? = clid != nil ? ["clid": clid!] : nil
                return Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters).0
            case let .LikeProject(_, clid):
                return Alamofire.ParameterEncoding.JSON.encode(request, parameters: ["clid": clid]).0
            default:
                return request
            }
        }
    }
}

enum LoadingState {
    case Loading(label: String?)
    case Loaded
    case NoData(label: String?)
    case Failure(description: String)
    case VoteAccepted(message: String)
    case VoteDeclined(warning: String)
}

func ==(a: LoadingState, b: LoadingState) -> Bool {
    switch (a, b) {
    case (.Loaded, .Loaded): return true
    case (.Loading, .Loading): return true
    case (.NoData, .NoData): return true
    case (.Failure, .Failure): return true
    case (.VoteAccepted, .VoteAccepted): return true
    case (.VoteDeclined, .VoteDeclined): return true
    default: return false
    }
}