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
    let logo: NSURL?
    
    init(voting: Voting) {
        id = voting.id
        title = voting.title
        location = voting.location?.lowercaseString.capitalizedString
        endDate = VotingViewModel.endDateFormatter.stringFromDate(voting.dateTo)
        logo = voting.logo
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
}