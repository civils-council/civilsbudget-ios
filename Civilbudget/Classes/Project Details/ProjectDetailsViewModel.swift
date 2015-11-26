//
//  ProjectDetailsViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/21/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation
import Bond
import BankIdSDK
import Alamofire

class ProjectDetailsViewModel: NSObject {
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter
    }()
    
    static let currencyFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        // formatter.locale = NSLocale(localeIdentifier: "ua_UKR")
        // formatter.numberStyle = .CurrencyStyle
        formatter.groupingSeparator = " "
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
    
    static let ownerImagePlaceholder: UIImage = CivilbudgetStyleKit.imageOfUserProfilePlaceholder.af_imageRoundedIntoCircle()
    
    var project: Project! {
        didSet {
            updateFields()
        }
    }
    
    let pictureURL = Observable<NSURL?>(nil)
    let title = Observable("")
    let fullDescription = Observable("")
    let supportedBy = Observable("")
    let createdAt = Observable("")
    let author = Observable("")
    let ownerImage = Observable(ProjectDetailsViewModel.ownerImagePlaceholder)
    let budgetLabel = Observable("")
    let loadingIndicatorVisible = Observable(false)
    
    let authorizeWithCompletion: Observable<(AuthorizationResult -> Void)?> = Observable(nil)
    let showAlertWithStatus = Observable<String?>(nil)
    
    init(project: Project? = nil) {
        super.init()
        
        if let project = project {
            self.project = project
            updateFields()
        }
    }
    
    func updateFields() {
        pictureURL.value = NSURL(string: project.picture ?? "")
        title.value = project.title
        fullDescription.value = project.description
        supportedBy.value = "\(project.likes ?? 0)"
        createdAt.value = self.dynamicType.dateFormatter.stringFromDate(project.createdAt ?? NSDate())
        author.value = project.owner ?? ""
        ownerImage.value = ProjectDetailsViewModel.ownerImagePlaceholder
        budgetLabel.value = "\u{f02b} Бюджет проекту: \(ProjectDetailsViewModel.currencyFormatter.stringFromNumber(15000)!) грн"
    }
    
    func voteForCurrentProject() {
        if true /*!authorized*/ {
            authorizeWithCompletion.value = handleAuthorizationResult
        }
    }
    
    func handleAuthorizationResult(result: AuthorizationResult) {
        if let error = result.error {
            showAlertWithStatus.value = error.localizedDescription
            return
        }
        
        guard let accessToken = result.value?.accessToken else {
            return
        }
        
        log.warning(accessToken)
        loadingIndicatorVisible.value = true
        
        Alamofire.request(CivilbudgetAPI.Router.Authorize(accessToken: accessToken))
            .responseObject { [weak self] (response: Response<User, NSError>) in
                print(response)
                
                guard let user = response.result.value, projectId = self?.project.id else {
                    self?.loadingIndicatorVisible.value = false
                    return
                }
                
                Alamofire.request(CivilbudgetAPI.Router.LikeProject(id: projectId, clid: user.clid)).responseString { response in
                    self?.loadingIndicatorVisible.value = false
                    
                    print(response.description)
                }
        }
    }
}