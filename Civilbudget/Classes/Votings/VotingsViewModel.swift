//
//  VotingsViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/28/17.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation
import Bond

class VotingsViewModel {
    
    struct Constanst {
        static let loadingState = LoadingState.Loading(label: "Завантаження голосувань")
    }
    
    let loadingState = Observable(Constanst.loadingState)
    let projectListIsEmpty = Observable(true)
    
    func reloadVotingsList() {
        if loadingState.value == Constanst.loadingState {
            return
        }
        
        loadingState.value = Constanst.loadingState
    }
}