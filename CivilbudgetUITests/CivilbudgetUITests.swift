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
        app.launchEnvironment = ["mockvote" : "true"]
        app.launch()
    }
    
    func testVoteForRandomProject() {
        let app = XCUIApplication()
        
        let votings = app.tables.cells
        let checkVotingsCount = NSPredicate(format: "count > 0")
        expectationForPredicate(checkVotingsCount, evaluatedWithObject: votings, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
        let votingsCount = votings.count
        let votingsImages = app.images.containingPredicate(NSPredicate(format: "identifier == 'loadedImage'"))
        let checkVotingsImagesCount = NSPredicate(format: "count == %i", votingsCount * 2)
        expectationForPredicate(checkVotingsImagesCount, evaluatedWithObject: votingsImages, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
        snapshot("0VotingsList")
        
        let firstVoting = app.tables.cells.elementBoundByIndex(0)
        firstVoting.tap()
        
        // Wait until projects to be loaded
        let projects = app.collectionViews.cells
        let checkProjectsCount = NSPredicate(format: "count > 0")
        expectationForPredicate(checkProjectsCount, evaluatedWithObject: projects, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
        // Wait until all proeject pictures to be loaded
        let projectsCount = projects.count
        let projectImages = app.images.containingPredicate(NSPredicate(format: "identifier == 'loadedImage'"))
        let checkImagesCount = NSPredicate(format: "count == %i", projectsCount)
        expectationForPredicate(checkImagesCount, evaluatedWithObject: projectImages, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)

        snapshot("1ProjectList")
        
        // Open random visible project
        let randomVisibleCellIndex = UInt(arc4random_uniform(UInt32(projectsCount)))
        let cellToTap = app.collectionViews.cells.elementBoundByIndex(randomVisibleCellIndex)
        cellToTap.tap()

        snapshot("2ProjectDetails")
        
        app.buttons["supportButton"].tap()
        
        snapshot("3VoteResult")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
