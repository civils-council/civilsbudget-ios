//
//  ProjectsViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/21/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import Alamofire

class ProjectsViewModel: NSObject {
    let projects = ObservableArray<Project>([])
    let selectedProjectDetailsViewModel = Observable<ProjectDetailsViewModel?>(nil)
    let loadingError = Observable<NSError?>(nil)
    
    override init() {
        super.init()
        
        refreshProjectList()
    }
    
    func refreshProjectList() {
        Alamofire.request(CivilbudgetAPI.Router.GetProjects)
            .responseCollection { [weak self] (response: Response<[Project], NSError>) in
                switch response.result {
                case let .Success(project):
                    self?.projects.array = project
                case let .Failure(error):
                    log.error(error.localizedDescription)
                    self?.loadingError.value = error
                }
        }
    }
    
    func projectForIndexPath(indexPath: NSIndexPath) -> Project {
        return projects.array[indexPath.row]
    }
    
    func selectProjectWithIndexPath(indexPath: NSIndexPath) {
        let project = projects.array[indexPath.row]
        selectedProjectDetailsViewModel.value = ProjectDetailsViewModel(project: project)
    }
}