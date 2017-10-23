//
//  ServiceSettingsTests.swift
//  CivilbudgetTests
//
//  Created by Max Odnovolyk on 10/23/17.
//  Copyright © 2017 Max Odnovolyk. All rights reserved.
//

import XCTest

class ServiceSettingsTests: XCTestCase {
    
    func testDecodeFromJson() {
        let jsonData = """
        {
            "bi_auth_url": "https://bankid.org.ua",
            "bi_client_id": "client-id",
            "bi_redirect_uri": "https://vote.imisto.com.ua/api/login"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        let serviceSettings = try! decoder.decode(ServiceSettings.self, from: jsonData)
        
        XCTAssertEqual(serviceSettings.bankIdClientId, "client-id")
        XCTAssertEqual(serviceSettings.bankIdAuthURL, URL(string: "https://bankid.org.ua/DataAccessService")!)
        XCTAssertEqual(serviceSettings.bankIdRedirectURI, URL(string: "https://vote.imisto.com.ua/api/login")!)
    }
}
