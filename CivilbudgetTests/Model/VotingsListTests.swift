//
//  VotingsListTests.swift
//  CivilbudgetTests
//
//  Created by Max Odnovolyk on 10/22/17.
//  Copyright © 2017 Max Odnovolyk. All rights reserved.
//

import XCTest

class VotingsListTests: XCTestCase {
    
    func testDecodeFromJson() {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "votings", ofType: "json")!
        let jsonData = NSData(contentsOfFile: path)! as Data
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let votingsList = try! decoder.decode(VotingsList.self, from: jsonData)
        
        XCTAssertEqual(votingsList.items.count, 4)
    }
}
