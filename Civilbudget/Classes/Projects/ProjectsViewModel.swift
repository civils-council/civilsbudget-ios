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
    
    func projectViewModelForIndexPath(indexPath: NSIndexPath, existingViewModel: ProjectDetailsViewModel? = nil) -> ProjectDetailsViewModel {
        let project = projects.array[indexPath.row]
        guard let existingViewModel = existingViewModel else {
            return ProjectDetailsViewModel(project: project)
        }
        existingViewModel.project = project
        return existingViewModel
    }
    
    func selectProjectWithIndexPath(indexPath: NSIndexPath) {
        selectedProjectDetailsViewModel.value = projectViewModelForIndexPath(indexPath)
    }
}