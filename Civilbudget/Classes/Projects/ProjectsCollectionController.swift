//
//  ProjectsAsyncCollectionController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/19/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import AsyncDisplayKit

class ProjectsCollectionController: StretchyCollectionController {
    let selectedIndexPath = Observable<NSIndexPath?>(nil)
    
    private var viewModel: ProjectsViewModel!
    private var projects: ObservableArray<ObservableArray<Project>>!
    
    init(viewModel: ProjectsViewModel) {
        self.viewModel = viewModel
        projects = viewModel.projects
    }
}

extension ProjectsCollectionController: ASCollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return projects.count
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return projects[section].count
    }
    
    func collectionView(collectionView: ASCollectionView!, nodeForItemAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        return ProjectCellNode(viewModel: viewModel.projectViewModelForIndexPath(indexPath))
    }
    
    func collectionView(collectionView: ASCollectionView!, nodeForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        return ProjectsHeaderCellNode(viewModel: viewModel) // <- cache it and update height while stretching
    }
}

extension ProjectsCollectionController: ASCollectionViewDelegate {
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        viewModel.selectProjectWithIndexPath(indexPath)
    }
    
    func collectionView(collectionView: ASCollectionView!, layout collectionViewLayout: UICollectionViewLayout!, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: collectionView.bounds.width, height: exposedHeaderViewHeight) : CGSizeZero
    }
}