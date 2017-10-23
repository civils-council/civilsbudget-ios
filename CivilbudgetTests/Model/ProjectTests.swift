//
//  ProjectTests.swift
//  CivilbudgetTests
//
//  Created by Max Odnovolyk on 10/23/17.
//  Copyright © 2017 Max Odnovolyk. All rights reserved.
//

import XCTest

class ProjectTests: XCTestCase {
    
    func testDecodeFromJson() {
        let jsonData = """
        {
             "voted": false,
             "id": 125,
             "title": "0002-2017: Створення та забезпечення класів Робототехніки в Черкаській спеціалізованій школі I-III ступенів № 13 по вул. Гетьмана Сагайдачного, 146",
             "description": "Ремонт навчальних приміщень НВК; придбання базових наборів LEGO Mindstorms education та програмного забезпечення; організація навчання викладачів.",
             "charge": 320000,
             "source": "http://zaharcuk.com.ua/",
             "picture": null,
             "created_at": "2017-10-14T13:50:50+00:00",
             "likes_count": 5,
             "owner": "Сухарьков Іван Васильович",
             "owner_avatar": null
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let dateFormatter = ISO8601DateFormatter()
        
        let project = try! decoder.decode(Project.self, from: jsonData)
        
        XCTAssertEqual(project.id, 125)
        XCTAssertEqual(project.title, "0002-2017: Створення та забезпечення класів Робототехніки в Черкаській спеціалізованій школі I-III ступенів № 13 по вул. Гетьмана Сагайдачного, 146")
        XCTAssertEqual(project.description, "Ремонт навчальних приміщень НВК; придбання базових наборів LEGO Mindstorms education та програмного забезпечення; організація навчання викладачів.")
        XCTAssertEqual(project.source, "http://zaharcuk.com.ua/")
        XCTAssertEqual(project.picture, nil)
        XCTAssertEqual(project.createdAt, dateFormatter.date(from: "2017-10-14T13:50:50+00:00")!)
        XCTAssertEqual(project.owner, "Сухарьков Іван Васильович")
        XCTAssertEqual(project.ownerAvatar, nil)
        XCTAssertEqual(project.budget, 320_000)
        XCTAssertEqual(project.likes, 5)
        XCTAssertEqual(project.voted, false)
    }
}
