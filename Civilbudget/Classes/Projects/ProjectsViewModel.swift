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
    let projectListIsEmpty = Observable(true)
    let selectedProjectDetailsViewModel = Observable<ProjectDetailsViewModel?>(nil)
    let loadingState = Observable(LoadingState.Loaded)
    let collectionViewUserInteractionEnabled = Observable(false)
    
    override init() {
        super.init()

        UserViewModel.currentUser.recentlyVotedProject.observeNew { [weak self] id in
            guard let id = id, projects = self?.projects.last,
                let index = projects.indexOf({ $0.id == id }) else {
                return
            }
            
            var project = projects[index]
            project.likes++
            projects[index] = project
        }.disposeIn(bnd_bag)
        
        combineLatest(loadingState, projectListIsEmpty)
            .map({ $0.0 == .Loaded || !$0.1})
            .bindTo(collectionViewUserInteractionEnabled)
        
        reloadProjectList()
    }
    
    func reloadProjectList() {
        if loadingState.value == .Loading(label: nil) {
            return
        }
        
        loadingState.value = .Loading(label: "Завантаження проектів")
        Alamofire.request(CivilbudgetAPI.Router.GetProjects(clid: User.currentUser.value?.clid))
            .responseCollection { [weak self] (response: Response<[Project], NSError>) in
                switch response.result {
                case let .Success(projects):
                    self?.projects.array.last?.array = projects
                    let state = projects.isEmpty ? LoadingState.NoData(label: "Список проектів порожній") : LoadingState.Loaded
                    self?.loadingState.value = state
                    self?.projectListIsEmpty.value = projects.isEmpty
                case let .Failure(error):
                    log.error(error.localizedDescription)
                    self?.loadingState.value = .Failure(description: "Помилка завантаження")
                }
        }
    }
    
    func projectViewModelForIndexPath(indexPath: NSIndexPath) -> ProjectDetailsViewModel {
        guard let project = projects.array.last?[indexPath.row] else {
            assert(false)
        }
    
        return ProjectDetailsViewModel(project: project)
    }
    
    func selectProjectWithIndexPath(indexPath: NSIndexPath) {
        selectedProjectDetailsViewModel.value = projectViewModelForIndexPath(indexPath)
    }
}