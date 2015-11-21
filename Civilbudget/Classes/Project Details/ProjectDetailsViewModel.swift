//
//  ProjectDetailsViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/21/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import Foundation

class ProjectDetailsViewModel: NSObject {
    let projectTitle = Observable<String>("")
    let projectDescription = Observable<String>("")
    let projectPicture = Observable<String?>("")
    
    var project: Project! {
        didSet {
            updateFields()
        }
    }
    
    init(project: Project) {
        super.init()
        
        self.project = project
        updateFields()
    }
    
    func updateFields() {
        projectTitle.value = project.title
        projectDescription.value = project.description
        if let picURL = project.picture {
            projectPicture.value = picURL
        }
    }
}