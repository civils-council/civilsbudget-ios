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

class ProjectDetailsViewModel {
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
    
    var project: Project! {
        didSet {
            updateFields()
        }
    }
    
    let pictureURL = Observable<NSURL?>(nil)
    let title = Observable("")
    let fullDescription = Observable("")
    let supportedByCount = Observable("")
    let createdAt = Observable("")
    let author = Observable("")
    let budgetLabel = Observable("")
    let supportButtonSelected = Observable(false)
    let loadingIndicatorVisible = Observable(false)
    
    let authorizationWithCompletion: Observable<(AuthorizationResult -> Void)?> = Observable(nil)
    let alertWithStatus = Observable<String?>(nil)
    
    
    init(project: Project? = nil) {
        if let project = project {
            self.project = project
            updateFields()
        }
    }
    
    func updateFields() {
        pictureURL.value = NSURL(string: project.picture ?? "")
        title.value = project.title
        fullDescription.value = project.description
        supportedByCount.value = "\(project.likes ?? 0)"
        createdAt.value = self.dynamicType.dateFormatter.stringFromDate(project.createdAt ?? NSDate())
        author.value = project.owner ?? ""
        budgetLabel.value = "\u{f02b} Бюджет проекту: \(ProjectDetailsViewModel.currencyFormatter.stringFromNumber(project.budget ?? 0)!) грн"
        supportButtonSelected.value = project.voted
    }
    
    func voteForCurrentProject() {
        if !User.isAuthorized() {
            authorizationWithCompletion.value = handleBankIdAuthorizationResult
        } else {
            
        }
    }
    
    func handleBankIdAuthorizationResult(result: AuthorizationResult) {
        if let error = result.error {
            alertWithStatus.value = error.localizedDescription
            return
        }
        
        guard let accessToken = result.value?.accessToken else {
            log.error("Unhandled unexpected error occured")
            return
        }
        
        loadingIndicatorVisible.value = true
        
        log.info("BankID Access token: \(accessToken)")
        
        Alamofire.request(CivilbudgetAPI.Router.Authorize(accessToken: accessToken))
            .responseObject { [weak self] (response: Response<User, NSError>) in
                log.info(NSString(data: response.data!, encoding: NSUTF8StringEncoding)?.description)
                log.info(response.description)
                
                guard let user = response.result.value, projectId = self?.project.id else {
                    self?.loadingIndicatorVisible.value = false
                    return
                }
                
                User.currentUser.value = user
                
                Alamofire.request(CivilbudgetAPI.Router.LikeProject(id: projectId, clid: user.clid)).responseString { response in
                    self?.loadingIndicatorVisible.value = false
                    
                    log.info(response.description)
                }
        }
    }
}