//
//  ViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/2/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import Bond
import Alamofire
import BankIdSDK

class ProjectsViewController: UIViewController {
    struct Constants {
        static let productCellIdentifier = "projectCell"
        static let productDetailsViewControllerIdentifier = "detailsViewController"
        static let collectionViewVerticalInset = CGFloat(10.0)
    }
    
    let projectsViewModel = ProjectsViewModel()
    var paddingTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var fbShareButton: UIButton!
    @IBOutlet weak var vkShareButton: UIButton!
    @IBOutlet weak var okShareButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UI
        bottomBarView.backgroundColor = CivilbudgetStyleKit.bottomBarBlue
        yearLabel.textColor = CivilbudgetStyleKit.bottomCopyrightGrey
        fbShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        fbShareButton.setTitleColor(CivilbudgetStyleKit.bottomBarBlue, forState: .Normal)
        fbShareButton.setTitle("\u{f09a}", forState: .Normal)
        vkShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        vkShareButton.setTitleColor(CivilbudgetStyleKit.bottomBarBlue, forState: .Normal)
        vkShareButton.setTitle("\u{f189}", forState: .Normal)
        okShareButton.setBackgroundImage(CivilbudgetStyleKit.imageOfBottomSocialButtonBackground, forState: .Normal)
        okShareButton.setTitleColor(CivilbudgetStyleKit.bottomBarBlue, forState: .Normal)
        okShareButton.setTitle("\u{f263}", forState: .Normal)
        
        
        // Top padding constraint
        paddingTopConstraint = NSLayoutConstraint(item: collectionView, attribute: .Top, relatedBy: .Equal,
            toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        view.addConstraint(paddingTopConstraint)
        
        // Bind View Model to UI
        projectsViewModel.projects.lift().bindTo(collectionView) { indexPath, dataSource, collectionView in
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.productCellIdentifier, forIndexPath: indexPath) as! ProjectCollectionViewCell
            cell/*.detailsViewModel*/.project = dataSource[indexPath.section][indexPath.row]
            return cell
        }
        
        // Bind Actions
        projectsViewModel.selectedProjectDetailsViewModel.observeNew { [weak self] detailsViewModel in
            let storyboard = UIStoryboard(name: GlobalConstants.mainBundleName, bundle: nil)
            let detailsViewController = storyboard.instantiateViewControllerWithIdentifier(Constants.productDetailsViewControllerIdentifier) as! ProjectDetailsViewController
            detailsViewController.detailsViewModel = detailsViewModel
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func signInButtonTapped(sender: UIBarButtonItem) {
        let authViewController = AuthorizationViewController(getOnlyAuthCode: true, patchIndexPage: true) { result in
            
            /*guard let authCode = result.value?.authCode else {
                log.warning("Authorization through BankID failed")
                log.warning("\(result.error!.debugDescription)")
                return
            }*/
            
            // log.info("Authorized with code \(authCode)")
            
            /*Alamofire.request(CivilbudgetAPI.Router.Authorize(code: authCode))
                .responseString { response in
                log.info(response.result.value)
            }*/
            
            guard let authorization = result.value else {
                return
            }
            
            Service.authorization = authorization
            
            Alamofire.request(Service.Router.RequestInformation(fields: BankIdSDK.Constants.allInfoFields))
                .responseString { response in
                    log.info(response.result.value)
                }
        }
        let navigationController = UINavigationController(rootViewController: authViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout delegated methods

extension ProjectsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let numberOfCells = floor(self.view.frame.size.width / ProjectCollectionViewCell.width)
        let horizontalEdgeInset = (self.view.frame.size.width - (numberOfCells * ProjectCollectionViewCell.width)) / (numberOfCells + 1);
        let verticalEdgeInset = numberOfCells < 2 ? Constants.collectionViewVerticalInset : horizontalEdgeInset
        return UIEdgeInsetsMake(verticalEdgeInset, horizontalEdgeInset, verticalEdgeInset, horizontalEdgeInset);
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        projectsViewModel.selectProjectWithIndexPath(indexPath)
    }
}
