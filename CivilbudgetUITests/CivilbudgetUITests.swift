//
//  CivilbudgetUITests.swift
//  CivilbudgetUITests
//
//  Created by Max Odnovolyk on 12/1/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import XCTest

class CivilbudgetUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setLanguage(app)
        app.launch()
    }
    
    func testExample() {
        snapshot("0ProjectList")
        
        XCUIApplication().collectionViews.staticTexts["1. Спортивний майданчик по Калініна"].tap()
        
        snapshot("1ProjectDetails")
    }
}
