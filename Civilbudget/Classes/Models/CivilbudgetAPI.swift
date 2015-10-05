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
        static let baseURLString = "http://civils.server/api"
        
        case Projects
        case Project(id: Int)
        
        var URLRequest: NSMutableURLRequest {
            let result: (path: String, parameters: [String: AnyObject]?) = {
                switch self {
                case .Projects:
                    return ("/projects", nil)
                default:
                    return ("", nil)
                }
                }()
            
            let URL = NSURL(string: Router.baseURLString)!
            let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: result.parameters).0
        }
    }
}