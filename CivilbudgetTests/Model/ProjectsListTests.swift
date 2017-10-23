//
//  ProjectsListTests.swift
//  CivilbudgetTests
//
//  Created by Max Odnovolyk on 10/23/17.
//  Copyright © 2017 Max Odnovolyk. All rights reserved.
//

import XCTest

class ProjectsListTests: XCTestCase {
    
    func testDecodeFromJson() {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "projects", ofType: "json")!
        let jsonData = NSData(contentsOfFile: path)! as Data
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let projectsList = try! decoder.decode(ProjectsList.self, from: jsonData)
        
        XCTAssertEqual(projectsList.items.count, 106)
    }
}
