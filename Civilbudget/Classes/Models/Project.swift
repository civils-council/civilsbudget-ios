//
//  Project.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import Alamofire

struct Project {
    var id = 0
    var title = ""
    var description = ""
    var shortDescription = ""
    var source: String?
    var picture: String?
    var createdAt: String?
    var likes: Int?
    var owner: String?
}

extension Project {
    typealias ProjectResponse = Response<[Project], NSError>
    
    static let allProjects: ObservableArray<Project> = {
        return ObservableArray([])
        }()
    
    static func reloadAllProjects(completionHandler: (ProjectResponse -> Void)? = nil) {
        Alamofire.request(CivilbudgetAPI.Router.Projects)
            .responseCollection { (response: ProjectResponse) in
                switch response.result {
                case .Success(let value):
                    allProjects.array = value
                case .Failure(let error):
                    log.error(error.localizedDescription)
                }
                completionHandler?(response)
        }
    }
}

extension Project: ResponseObjectSerializable, ResponseCollectionSerializable {
    struct Constants {
        static let maxShortDescriptionLength = 100
    }
    
    init?(response: NSHTTPURLResponse, var representation: AnyObject) {
        if let projectDictionary = representation.valueForKey("project") as? NSDictionary
            where representation.count == 1{
            representation = projectDictionary
        }
        
        guard let id = representation.valueForKeyPath("id") as? Int,
            title = representation.valueForKeyPath("title") as? String,
            description = representation.valueForKeyPath("description") as? String
            else {
                log.error("Can't create project without mandatory field (id, title, description)")
                return nil
        }
        
        self.id = id
        self.title = title
        self.description = description
        self.shortDescription = description.substringToIndex(description.startIndex.advancedBy(Constants.maxShortDescriptionLength))
        
        self.source = representation.valueForKeyPath("source") as? String
        self.picture = representation.valueForKeyPath("picture") as? String
        self.createdAt = representation.valueForKeyPath("createdAt") as? String
        self.likes = representation.valueForKeyPath("likes") as? Int
        self.owner = representation.valueForKeyPath("owner") as? String
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Project] {
        guard let representation = representation.valueForKeyPath("projects") as? [[String: AnyObject]] else {
            log.error("Can't cast root JSON collection to Project list")
            return []
        }
        
        return representation.flatMap { Project(response: response, representation: $0) }
    }
}