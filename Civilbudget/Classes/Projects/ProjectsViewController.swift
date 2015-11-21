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
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = projectsViewModel
        
        // Bind View Model to UI
        projectsViewModel.projects.lift().bindTo(collectionView) { indexPath, dataSource, collectionView in
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.productCellIdentifier, forIndexPath: indexPath) as! ProjectCollectionViewCell
            cell/*.detailsViewModel*/.project = dataSource[indexPath.section][indexPath.row]
            return cell
        }
        
        // Actions
        projectsViewModel.selectedProjectDetailsViewModel.observeNew { [weak self] detailsViewModel in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
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
}
