//
//  ProjectDetailsViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/3/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: BaseCollectionViewController {
    struct Constants {
        static let detailsCellIdentifier = "detailsCell"
    }
    
    var viewModel: ProjectDetailsViewModel!
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UI
        backButton.setTitle("\u{f104}", forState: .Normal)
        
        // Register Projects details cell class
        collectionView.registerNib(UINib(nibName: "ProjectDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.detailsCellIdentifier)
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: - UICollectionViewDataSource methods

extension ProjectDetailsViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.detailsCellIdentifier, forIndexPath: indexPath) as! ProjectDetailsCollectionViewCell
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath) as! ProjectDetailsHeaderReusableView
        view.viewModel = viewModel
        return view
    }
}