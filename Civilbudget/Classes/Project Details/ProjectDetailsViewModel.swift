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
import PromiseKit

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
    let errorAlertWithDescription = Observable("")
    let infoAlertWithDescription = Observable("")
    let successAlertWithDescription = Observable("")
    
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
        UserViewModel.currentUser.votedProject.map { [weak self] in $0 == self?.project.id }.bindTo(supportButtonSelected)
    }
    
    func voteForCurrentProject() {
        if !User.isAuthorized() {
            if !User.warningWasShownBefore {
                infoAlertWithDescription.value = "BankID – це спосіб ідентифікації громадян.\nПри ідентифікації громадян через BankID НЕ ПЕРЕДАЄТЬСЯ фінансова та будь-яка інша приватна інформація. Тільки та інформація, що надається в паперовій формі при голосуванні за проекти Громадський Бюджет (ім’я, прізвище, по-батькові, стать, дата народження, адреса та ідентифікаційний номер).\nОтримані дані використовуються лише для ідентифікації громадян."
            }
            
            authorizationWithCompletion.value = handleBankIdAuthorizationResult
            return
        }
        
        loadingIndicatorVisible.value = true
        
        firstly {
            voteProject(project.id, withClid: User.currentUser.value!.clid)
        }.then { (voteResult: VoteResult) -> Void in
            if voteResult.isSuccessful {
                self.project.voted = true
                self.project.likes++
                self.updateFields()
                self.successAlertWithDescription.value = voteResult.success!
            } else {
                self.errorAlertWithDescription.value = voteResult.warning!
                // self?.votingState.value = LoadingState.VoteDeclined(warning: voteResult.warning)
            }
        }.always { _ in
            self.loadingIndicatorVisible.value = false
        }.error { (error: ErrorType) -> Void in
            let error = error as NSError
            self.errorAlertWithDescription.value = error.localizedDescription
        }
    }
    
    func handleBankIdAuthorizationResult(result: AuthorizationResult) {
        loadingIndicatorVisible.value = true
        
        firstly {
            checkBankIdResult(result)
        }.then { (auth: Authorization) -> Promise<User> in
            return self.authorizeToken(auth.accessToken)
        }.then { (user: User) -> Void in
            self.voteForCurrentProject()
        }.always { _ in
            self.loadingIndicatorVisible.value = false
        }.error { (error: ErrorType) -> Void in
            let error = error as NSError
            switch (error.domain, error.code) {
            case (BankIdSDK.Error.errorDomain, BankIdSDK.ErrorCode.Canceled.rawValue): break
            default: self.errorAlertWithDescription.value = error.localizedDescription
            }
        }
    }
    
    // MARK: Promises
    
    private func checkBankIdResult(authResult: AuthorizationResult) -> Promise<Authorization> {
        return Promise { fulfill, reject in
            guard let auth = authResult.value else {
                reject(authResult.error!)
                return
            }
            fulfill(auth)
        }
    }
    
    private func authorizeToken(accessToken: String) -> Promise<User> {
        return Promise { fulfill, reject in
            Alamofire.request(CivilbudgetAPI.Router.Authorize(accessToken: accessToken))
                .responseObject { (response: Response<User, NSError>) in
                    response.data
                    guard let user = response.result.value else {
                        reject(response.result.error!)
                        return
                    }
                    User.currentUser.value = user
                    fulfill(user)
                }
        }
    }
    
    private func voteProject(projectId: Int, withClid clid: String) -> Promise<VoteResult> {
        return Promise { fulfill, reject in
            Alamofire.request(CivilbudgetAPI.Router.LikeProject(id: projectId, clid: clid))
                .responseObject { (response: Response<VoteResult, NSError>) in
                    guard let voteResult = response.result.value else {
                        reject(response.result.error!)
                        return
                    }
                    
                    if voteResult.isSuccessful {
                        User.currentUser.value?.votedProjectId = projectId
                        UserViewModel.currentUser.recentlyVotedProject.value = projectId
                    }
                    
                    fulfill(voteResult)
            }
        }
    }
}