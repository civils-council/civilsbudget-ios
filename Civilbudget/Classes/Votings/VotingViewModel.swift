//
//  VotingViewModel.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/29/17.
//  Copyright © 2017 Build Apps. All rights reserved.
//

import Foundation

struct VotingViewModel {
    
    let id: Int
    let title: String
    let location: String?
    let endDate: String
    let terms: String
    let logo: NSURL?
    let background: NSURL?
    let isActive: Bool
    let votes: String?
    
    init(voting: Voting) {
        id = voting.id
        title = voting.title
        location = voting.location?.uppercaseString
        
        endDate = VotingViewModel.endDateFormatter.stringFromDate(voting.dateTo)
        terms = "\(VotingViewModel.rangeDateFormatter.stringFromDate(voting.dateFrom)) - \(VotingViewModel.rangeDateFormatter.stringFromDate(voting.dateTo))"
        
        logo = voting.logo
        background = voting.backgroundImage

        isActive = voting.status == .Active || voting.status == .Future
        
        votes = voting.status == .Future ? nil : "Підтримало: \(voting.voted ?? 0)"
    }
}

extension VotingViewModel {
    
    static var endDateFormatter: NSDateFormatter {
        let formatterDictionaryKey = "EndVotingDateFormatterKey"
        let threadDictionary = NSThread.currentThread().threadDictionary
        var formatter = threadDictionary[formatterDictionaryKey] as? NSDateFormatter
        if formatter.isNil {
            formatter = NSDateFormatter()
            formatter!.dateFormat = "dd.MM.YY"
            threadDictionary[formatterDictionaryKey] = formatter!
        }
        return formatter!
    }
    
    static var rangeDateFormatter: NSDateFormatter {
        let formatterDictionaryKey = "RangeDateFormatterKey"
        let threadDictionary = NSThread.currentThread().threadDictionary
        var formatter = threadDictionary[formatterDictionaryKey] as? NSDateFormatter
        if formatter.isNil {
            formatter = NSDateFormatter()
            formatter!.dateFormat = "dd.MM.YYYY"
            threadDictionary[formatterDictionaryKey] = formatter!
        }
        return formatter!
    }
}