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
        static let defaultEstimatedRowHeight = CGFloat(54.0)
        static let  showDetailsSegueIdentifier = "showProjectDetailsIdentifier"
    }
    
    var selectedProject: Project!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.defaultEstimatedRowHeight
        
        Project.allProjects.lift().bindTo(tableView) { indexPath, dataSource, tableView in
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.productCellIdentifier, forIndexPath: indexPath) as! ProjectTableViewCell
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(sender: UIBarButtonItem) {
        let authViewController = BIDAuthViewController(getOnlyAuthCode: false, patchIndexPage: true) { result in
            guard let authorization = result.value else {
                log.warning("Authorization through BankID failed")
                log.warning("\(result.error!.debugDescription)")
                return
            }
            
            BIDService.authorization = authorization
            log.info("Authorized")
            
            // Request info
            Alamofire.request(BIDService.Router.RequestInformation(fields: BIDService.allInfoFields))
                .responseObject { (response: Response<BIDService.Information, NSError>) in
                    log.info(response.debugDescription)
                    log.info(NSString(data: response.data!, encoding: NSUTF8StringEncoding) as? String)
            }
        }
        let navigationController = UINavigationController(rootViewController: authViewController)
        presentViewController(navigationController, animated: true, completion: nil)
        
        /*BankIdApi.requestCode { code in
            print(code)
        }*/
    }
}

extension ProjectsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedProject = Project.allProjects[indexPath.row]
        performSegueWithIdentifier(Constants.showDetailsSegueIdentifier, sender: nil)
    }
}
