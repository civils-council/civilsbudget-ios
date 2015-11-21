//
//  ViewController.swift
//  BankIdSDK Demo
//
//  Created by Max Odnovolyk on 11/20/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import BankIdSDK
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure service
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInButtonTapped(sender: UIButton) {
        let authViewController = AuthorizationViewController(getOnlyAuthCode: false, patchIndexPage: true) { result in
            guard let authorization = result.value else {
                return
            }
            
            Service.authorization = authorization
            
            Alamofire.request(Service.Router.RequestInformation(fields: BankIdSDK.Constants.allInfoFields))
                .responseString { response in
                    print(response.result.value)
            }
        }
        let navigationController = UINavigationController(rootViewController: authViewController)
        presentViewController(navigationController, animated: true, completion: nil)

    }
}