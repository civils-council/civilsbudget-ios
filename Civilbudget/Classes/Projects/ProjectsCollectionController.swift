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
    private weak var collectionView: ASCollectionView?
    private var viewModel: ProjectsViewModel
    private var projects: ObservableArray<ObservableArray<Project>>
    private var headerNode: ProjectsHeaderCellNode?
    
    init(collectionView: ASCollectionView, viewModel: ProjectsViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        projects = viewModel.projects
        
        super.init()
        
        assert(projects.count == 2, "Projects array must contain 2 sections (header + list of projects)")
        
        projects.last?.observeNew { [weak self] arrayEvent in
            guard let collectionView = self?.collectionView else {
                return
            }
            
            collectionView.performBatchAnimated(true, updates: {
                collectionView.reloadSections(NSIndexSet(index: 1))
            }, completion: { _ in })
        }.disposeIn(bnd_bag)
    }
}

// MARK: - ASCollectionView data source methods

extension ProjectsCollectionController: ASCollectionDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return projects.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects[section].count
    }
    
    func collectionView(collectionView: ASCollectionView, nodeForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        return ProjectCellNode(viewModel: viewModel.projectViewModelForIndexPath(indexPath))
    }
    
    func collectionView(collectionView: ASCollectionView, nodeForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> ASCellNode {
        if headerNode.isNil {
            headerNode = ProjectsHeaderCellNode(viewModel: viewModel, height: exposedHeaderViewHeight)
            stretchDistance
                .map({ [unowned self] stretchDistance in
                        let origin = CGPoint(x: 0.0, y: stretchDistance < 0 ? -stretchDistance : 0)
                        let size = CGSize(width: self.collectionView!.frame.width, height: self.exposedHeaderViewHeight + stretchDistance)
                        return CGRect(origin: origin, size: size)
                    })
                .bindTo(headerNode!.stretchedFrame)
                .disposeIn(bnd_bag)
        }
        return headerNode!
    }
}

// MARK: - ASCollectionView delegate methods

extension ProjectsCollectionController: ASCollectionDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        viewModel.selectProjectWithIndexPath(indexPath)
    }
    
    func collectionView(collectionView: ASCollectionView!, layout collectionViewLayout: UICollectionViewLayout!, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: collectionView.bounds.width, height: exposedHeaderViewHeight) : CGSize.zero
    }
}