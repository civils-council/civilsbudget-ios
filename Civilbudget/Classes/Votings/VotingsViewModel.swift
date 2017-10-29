//
//  VotingsViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/28/17.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation
import Alamofire
import Bond

class VotingsViewModel {
    
    struct Constanst {
        static let loadingState = LoadingState.Loading(label: "Завантаження голосувань")
    }
    
    let votings = ObservableArray<Voting>([])
    let loadingState = Observable(LoadingState.Loaded)
    let votingsListIsEmpty = Observable(true)
    
    func loadVotingsList() {
        if loadingState.value == Constanst.loadingState {
            return
        }
        
        loadingState.value = Constanst.loadingState
        Alamofire.request(CivilbudgetAPI.Router.GetVotings)
            .responseCollection { [weak self] (response: Response<[Voting], NSError>) in
                switch response.result {
                case let .Success(votings):
                    self?.votings.array = votings
                    let state = votings.isEmpty ? LoadingState.NoData(label: "Список голосувань порожній") : LoadingState.Loaded
                    self?.loadingState.value = state
                    self?.votingsListIsEmpty.value = votings.isEmpty
                case let .Failure(error):
                    log.error(error.localizedDescription)
                    self?.loadingState.value = .Failure(description: "Помилка завантаження")
                }
        }
    }
}