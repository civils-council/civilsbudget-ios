//
//  UserProfileViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/30/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation
import Bond
import PromiseKit
import Alamofire

class UserViewModel {
    static let currentUser = UserViewModel()
    
    let votedProject = Observable(User.currentUser.value?.votedProjectId)
    let recentlyVotedProject = Observable<Int?>(nil)
    let accountDialog = Observable<(String, ((UIAlertAction) -> Void), AnyObject?)?>(nil)
    
    func presentAccountDialog(sender: AnyObject?) {
        guard let fullName = User.currentUser.value?.fullName else {
            return
        }
        accountDialog.value = (fullName, { _ in User.clearCurrentUser() }, sender)
    }
    
    init() {
        User.currentUser.observeNew { [weak self] user in
            self?.votedProject.value = user?.votedProjectId
        }
    }
}