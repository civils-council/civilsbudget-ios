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

class ProjectsViewController: UIViewController {
    struct Constants {
        static let productCellIdentifier = "projectCell"
        static let showDetailsSegueIdentifier = "showProjectDetailsIdentifier"
        static let collectionViewVerticalInset = CGFloat(10.0)
    }
    
    var selectedProject: Project!
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Project.allProjects.lift().bindTo(collectionView) { indexPath, dataSource, collectionView in
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.productCellIdentifier, forIndexPath: indexPath) as! ProjectCollectionViewCell
            cell.project = dataSource[indexPath.section][indexPath.row]
            return cell
        }
        
        Project.reloadAllProjects()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        if let detailsViewController = destinationViewController as? ProjectDetailsViewController {
            detailsViewController.project = selectedProject
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func signInButtonTapped(sender: UIBarButtonItem) {
        let authViewController = BIDAuthViewController(getOnlyAuthCode: true, patchIndexPage: true) { result in
            guard let authCode = result.value?.authCode else {
                log.warning("Authorization through BankID failed")
                log.warning("\(result.error!.debugDescription)")
                return
            }
            
            log.info("Authorized with code \(authCode)")
            
            Alamofire.request(CivilbudgetAPI.Router.Authorize(code: authCode))
                .responseObject { (response: Response<User, NSError>) in
                log.info(response.debugDescription)
            }
        }
        let navigationController = UINavigationController(rootViewController: authViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionView delegated methods

extension ProjectsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedProject = Project.allProjects[indexPath.row]
        performSegueWithIdentifier(Constants.showDetailsSegueIdentifier, sender: nil)
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
