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
    var sizingCell: ProjectDetailsCollectionViewCell?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UI
        backButton.setTitle("\u{f104}", forState: .Normal)
        supportButton.setBackgroundImage(CivilbudgetStyleKit.imageOfSupportButtonBackground, forState: .Normal)
        supportButton.setTitleColor(CivilbudgetStyleKit.themeDarkBlue, forState: .Normal)
        
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
        cell.viewModel = viewModel
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath) as! ProjectDetailsHeaderReusableView
        view.viewModel = viewModel
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods (layout customization)

extension ProjectDetailsViewController {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let targetWidth: CGFloat = self.collectionView.bounds.width
        
        if sizingCell == nil {
            sizingCell = NSBundle.mainBundle().loadNibNamed("ProjectDetailsCollectionViewCell", owner: self, options: nil).first as? ProjectDetailsCollectionViewCell
        }
        
        guard let sizingCell = sizingCell else {
            return CGSize()
        }
        
        sizingCell.viewModel = viewModel
        sizingCell.bounds = CGRectMake(0, 0, targetWidth, sizingCell.bounds.height)
        sizingCell.contentView.bounds = sizingCell.bounds
        
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        var size = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        size.width = targetWidth
        return size
    }
}
