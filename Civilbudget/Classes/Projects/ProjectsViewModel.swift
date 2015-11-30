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
    let projects = ObservableArray([ObservableArray<Project>([]), ObservableArray<Project>([])])
    let selectedProjectDetailsViewModel = Observable<ProjectDetailsViewModel?>(nil)
    let loadingState = Observable(LoadingState.Loaded)
    
    override init() {
        super.init()
        
        refreshProjectList()
    }
    
    func refreshProjectList() {
        loadingState.value = .Loading(label: "Завантаження проектів")
        Alamofire.request(CivilbudgetAPI.Router.GetProjects(clid: User.currentUser.value?.clid))
            .responseCollection { [weak self] (response: Response<[Project], NSError>) in
                switch response.result {
                case let .Success(projects):
                    self?.projects.array.last?.array = projects
                    let state = projects.count > 0 ? LoadingState.Loaded : LoadingState.NoData(label: "Список проектів порожній")
                    self?.loadingState.value = state
                case let .Failure(error):
                    log.error(error.localizedDescription)
                    self?.loadingState.value = .Failure(description: "Помилка завантаження")
                }
        }
    }
    
    func projectViewModelForIndexPath(indexPath: NSIndexPath, existingViewModel: ProjectDetailsViewModel? = nil) -> ProjectDetailsViewModel {
        let project = projects.array.last?[indexPath.row]
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