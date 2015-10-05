//
//  Project.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation
import Bond
import Alamofire
import SwiftyJSON

struct Project {
    var id = 0
    var title = ""
    var description = ""
    var shortDescription = ""
    var source = ""
    var icon = ""
    var picture = ""
    var createdAt = ""
    var likes = 0
    var owner = ""
}

extension Project {
    static let allProjects: ObservableArray<Project> = {
        return ObservableArray([])
    }()
    
    static func reloadAllProjects() {
        Alamofire.request(CivilbudgetAPI.Router.Projects).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization

            if let data = response.data {
                var projectsArray: [Project] = []
                let json = JSON(data: data)
                let projects = json["projects"].arrayValue
                var i = 0
                for project in projects {
                    var prj = Project()
                    prj.id = ++i
                    prj.title = project["title"].stringValue
                    let description: NSString = project["description"].stringValue
                    prj.description = project["description"].stringValue
                    prj.shortDescription = description.substringToIndex(100)
                    projectsArray.append(prj)
                }
                allProjects.array = projectsArray
            }
        }
    }
}