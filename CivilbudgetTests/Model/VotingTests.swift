//
//  VotingTests.swift
//  CivilbudgetTests
//
//  Created by Max Odnovolyk on 10/22/17.
//  Copyright © 2017 Max Odnovolyk. All rights reserved.
//

import XCTest

class VotingTests: XCTestCase {
    
    func testDecodeFromJson() {
        let jsonData = """
        {
            "voted": 3633,
            "id": 1,
            "status": "archived",
            "title": "виріши долю громадського бюджету міста Полтава на 2017 рік.",
            "description": "Опис Малих проектів",
            "max_votes_count": 1,
            "date_from": "2016-10-17T00:00:00+00:00",
            "date_to": "2016-10-31T23:59:00+00:00",
            "logo": "http://zaharcuk.com.ua/bundles/app/img/logo_poltava.png",
            "background_image": "http://zaharcuk.com.ua/bundles/app/img/homebanner_poltava.png",
            "location": "ПОЛТАВА"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let dateFormatter = ISO8601DateFormatter()
        
        let voting = try! decoder.decode(Voting.self, from: jsonData)
        
        XCTAssertEqual(voting.id, 1)
        XCTAssertEqual(voting.status, .archived)
        XCTAssertEqual(voting.title, "виріши долю громадського бюджету міста Полтава на 2017 рік.")
        XCTAssertEqual(voting.description, "Опис Малих проектів")
        XCTAssertEqual(voting.location, "ПОЛТАВА")
        XCTAssertEqual(voting.voted, 3633)
        XCTAssertEqual(voting.maxVotesCount, 1)
        XCTAssertEqual(voting.dateFrom, dateFormatter.date(from: "2016-10-17T00:00:00+00:00"))
        XCTAssertEqual(voting.dateTo, dateFormatter.date(from: "2016-10-31T23:59:00+00:00"))
        XCTAssertEqual(voting.logo, URL(string: "http://zaharcuk.com.ua/bundles/app/img/logo_poltava.png"))
        XCTAssertEqual(voting.backgroundImage, URL(string: "http://zaharcuk.com.ua/bundles/app/img/homebanner_poltava.png"))
    }
}
