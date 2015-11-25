//
//  ProjectDetailsViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/21/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import Foundation
import Bond

class ProjectDetailsViewModel: NSObject {
    
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd.M.yy"
        return formatter
    }()
    
    let projectTitle = Observable<String>("")
    let projectDescription = Observable<String>("")
    let projectPictureURL = Observable<NSURL?>(nil)
    let projectOwner = Observable<String?>("")
    let supportedBy = Observable("")
    let createdAt = Observable("")
    
    var project: Project! {
        didSet {
            updateFields()
        }
    }
    
    init(project: Project? = nil) {
        super.init()
        
        if let project = project {
            self.project = project
            updateFields()
        }
    }
    
    func updateFields() {
        projectTitle.value = project.title
        projectDescription.value = project.description
        projectOwner.value = project.owner
        projectPictureURL.value = NSURL(string: project.picture ?? "")
        supportedBy.value = "\(project.likes ?? 0)"
        if let createdDate = project.createdAt {
            createdAt.value = self.dynamicType.dateFormatter.stringFromDate(createdDate)
        }
    }
}