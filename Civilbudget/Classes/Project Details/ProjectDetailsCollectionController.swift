//
//  ProjectDetailsCollectionController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 1/26/16.
//  Copyright © 2016 Build Apps. All rights reserved.
//

class ProjectDetailsCollectionController: StretchyCollectionController {
    struct Constants {
        static let sectionsCount = 2
        static let headerSectionItemsCount = 0
        static let detailsSectionItemsCount = 1
        static let detailsCellIdentifier = "detailsCell"
        static let headerCellIdentifier = "headerCell"
    }
    
    private weak var collectionView: UICollectionView?
    private var viewModel: ProjectDetailsViewModel
    
    private var headerView: ProjectDetailsHeaderReusableView?
    private var detailsView: ProjectDetailsCollectionViewCell?
    
    init(collectionView: UICollectionView, viewModel: ProjectDetailsViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        
        super.init()
        
        collectionView.registerNib(UINib(nibName: ProjectDetailsCollectionViewCell.defaultNibName, bundle: nil), forCellWithReuseIdentifier: Constants.detailsCellIdentifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: StretchyCollectionController.Constants.defaultExposedHeaderViewHeight);
        }
    }
}

extension ProjectDetailsCollectionController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return Constants.sectionsCount
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? Constants.headerSectionItemsCount : Constants.detailsSectionItemsCount
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if !headerView.isNil {
            return headerView!
        }
        
        headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.headerCellIdentifier, forIndexPath: indexPath) as? ProjectDetailsHeaderReusableView
        headerView!.viewModel = viewModel
        return headerView!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if !detailsView.isNil {
            return detailsView!
        }
        
        detailsView = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.detailsCellIdentifier, forIndexPath: indexPath) as? ProjectDetailsCollectionViewCell
        detailsView!.viewModel = viewModel
        return detailsView!
    }
}

extension ProjectDetailsCollectionController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: collectionView.bounds.width, height: StretchyCollectionController.Constants.defaultExposedHeaderViewHeight): CGSize.zero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return ProjectDetailsCollectionViewCell.sizeWithViewModel(viewModel, constrainedWidth: collectionView.bounds.width)
    }
}