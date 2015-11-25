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
    let projectTitle = Observable<String>("")
    let projectDescription = Observable<String>("")
    let projectPicture = Observable<String?>("")
    let projectOwner = Observable<String?>("")
    
    var project: Project! {
        didSet {
            updateFields()
        }
    }
    
    var project: Project! {
        didSet {
            updateFields()
        }
    }
    
    let pictureURL = Observable<NSURL?>(nil)
    let title = Observable("")
    let fullDescription = Observable("")
    let supportedBy = Observable("")
    let createdAt = Observable("")
    
    init(project: Project? = nil) {
        super.init()
        
        self.project = project
        updateFields()
    }
    
    func updateFields() {
        projectTitle.value = project.title
        projectDescription.value = project.description
        projectOwner.value = project.owner
        if let picURL = project.picture {
            projectPicture.value = picURL
        }
    }
}