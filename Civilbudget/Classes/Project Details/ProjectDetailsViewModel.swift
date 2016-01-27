//
//  ProjectDetailsViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/21/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond
import BankIdSDK
import Alamofire
import PromiseKit
import SCLAlertView
import Foundation

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
    
    let project: Project!
    
    let pictureURL = Observable<NSURL?>(nil)
    let title = Observable("")
    let fullDescription = Observable("")
    let supportedByCount = Observable("")
    let createdAt = Observable("")
    let author = Observable("")
    let budgetLabel = Observable("")
    let supportButtonSelected = Observable(false)
    let supportButtonEnabled = Observable(false)
    let supportButtonUserInterationEnabled = Observable(false)
    let userProfileButtonHidden = Observable(false)
    
    let loadingIndicatorVisible = Observable(false)
    
    let authorizationWithCompletion: Observable<(AuthorizationResult -> Void)?> = Observable(nil)
    let userAlertWithData = Observable((type: SCLAlertViewStyle.Success, title: "", message: ""))
    
    init(project: Project) {
        self.project = project
        
        super.init()

        // Already voted for current project
        UserViewModel.currentUser.votedProject.map({ [weak self] in $0 == self?.project.id }).bindTo(supportButtonSelected)
        combineLatest(supportButtonSelected, User.currentUser, UserViewModel.currentUser.votedProject)
            .map({ $0 || $1.isNil || $2.isNil })
            .bindTo(supportButtonEnabled)
        supportButtonSelected.map({ !$0 }).bindTo(supportButtonUserInterationEnabled)
        UserViewModel.currentUser.isAuthorized.map({ !$0 }).bindTo(userProfileButtonHidden)
        
        updateFieldsFromProject(project)
    }
    
    private func updateFieldsFromProject(project: Project) {
        pictureURL.value = NSURL(string: project.picture ?? "")
        title.value = project.title
        fullDescription.value = project.description
        supportedByCount.value = "\(project.likes ?? 0)"
        createdAt.value = self.dynamicType.dateFormatter.stringFromDate(project.createdAt ?? NSDate())
        author.value = project.owner ?? ""
        budgetLabel.value = "\u{f02b} Бюджет проекту: \(ProjectDetailsViewModel.currencyFormatter.stringFromNumber(project.budget ?? 0)!) грн"
    }
    
    func voteForCurrentProject() {
        if let mockvote = NSProcessInfo.processInfo().environment["mockvote"] {
            userAlertWithData.value = alertDataWithType(.Success, message: mockvote)
            return
        }
        
        if !User.isAuthorized() {
            authorize()
            return
        }
        
        loadingIndicatorVisible.value = true
        
        firstly {
            voteProject(project.id, withClid: User.currentUser.value!.clid)
        }.then { (voteResult: VoteResult) -> Void in
            if voteResult.isSuccessful {
                var mutableProject = self.project
                mutableProject.voted = true
                mutableProject.likes++
                self.updateFieldsFromProject(mutableProject)
                self.userAlertWithData.value = self.alertDataWithType(.Success, message: voteResult.success!)
            } else {
                self.userAlertWithData.value = self.alertDataWithType(.Error, message: voteResult.warning!)
            }
        }.always {
            self.loadingIndicatorVisible.value = false
        }.error { (error: ErrorType) -> Void in
            let error = error as NSError
            self.userAlertWithData.value = self.alertDataWithType(.Error, message: error.localizedDescription)
        }
    }
    
    func authorize() {
        loadingIndicatorVisible.value = true
        
        firstly {
            getSettings()
        }.then { (settings: ServiceSettings) -> Void in
            var configuaration = BankIdSDK.Service.configuration
            configuaration.clientID = settings.bankIdClientId
            configuaration.baseAuthURLString = settings.bankIdAuthURL
            configuaration.redirectURI = settings.bankIdRedirectURI
            Service.configuration = configuaration
            
            if !User.warningWasShownBefore {
                let message = "BankID – це спосіб ідентифікації громадян.\nПри ідентифікації громадян через BankID НЕ ПЕРЕДАЄТЬСЯ фінансова та будь-яка інша приватна інформація. Тільки та інформація, що надається в паперовій формі при голосуванні за проекти Громадський Бюджет (ім’я, прізвище, по-батькові, стать, дата народження, адреса та ідентифікаційний номер).\nОтримані дані використовуються лише для ідентифікації громадян."
                self.userAlertWithData.value = self.alertDataWithType(.Info, message: message)
            }
            self.authorizationWithCompletion.value = self.handleBankIdAuthorizationResult
        }.always {
            self.loadingIndicatorVisible.value = false
        }.error { (error: ErrorType) -> Void in
            let error = error as NSError
            self.userAlertWithData.value = self.alertDataWithType(.Error, message: error.localizedDescription)
        }
    }
    
    func handleBankIdAuthorizationResult(result: AuthorizationResult) {
        loadingIndicatorVisible.value = true
        
        firstly {
            checkBankIdResult(result)
        }.then { (auth: Authorization) -> Promise<User> in
            self.authorizeToken(auth.accessToken)
        }.then { (user: User) -> Void in
            self.voteForCurrentProject()
        }.always { _ in
            self.loadingIndicatorVisible.value = false
        }.error { (error: ErrorType) -> Void in
            // Workaround
            // https://github.com/mxcl/PromiseKit/issues/276
            let error = ((error as Any) as! NSError)
            switch (error.domain, error.code) {
            case (BankIdSDK.Error.errorDomain, BankIdSDK.ErrorCode.Canceled.rawValue):
                break
            default:
                self.userAlertWithData.value = self.alertDataWithType(.Error, message: error.localizedFailureReason ?? error.localizedDescription)
            }
        }
    }
    
    func alertDataWithType(type: SCLAlertViewStyle, message: String) -> (SCLAlertViewStyle, String, String) {
        let title: String
        switch type {
        case .Error:
            title = "Помилка"
        case .Success:
            title = "Дякуємо!"
        default:
            title = "Увага!"
            break
        }
        return (type, title, message)
    }
    
    // MARK: Promises
    
    private func getSettings() -> Promise<ServiceSettings> {
        return Promise { fulfill, reject in
            Alamofire.request(CivilbudgetAPI.Router.GetSettings)
                .responseObject { (response: Response<ServiceSettings, NSError>) in
                    guard let settings = response.result.value else {
                        reject(response.result.error!)
                        return
                    }
                    fulfill(settings)
                }
        }
    }
    
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