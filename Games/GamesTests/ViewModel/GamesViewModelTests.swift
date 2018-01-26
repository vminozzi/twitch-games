//
//  GamesTests.swift
//  GamesTests
//
//  Created by Vinicius on 23/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import XCTest
@testable import Games

extension XCTestCase {
    func readJSON(name: String) -> Data? {
        let path = Bundle.main.path(forResource: name, ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return data
    }
}

class GamesTests: XCTestCase {
    
    let viewModel = HomeViewModel()
    
    override func setUp() {
        super.setUp()
        
        guard let mocked = readJSON(name: "Mock"), let games = GameResult(data: mocked) else {
            return
        }
        viewModel.games = games.top
    }
    
    func testShouldValidateNumberOfSections() {
        XCTAssert(viewModel.numberOfSections() == 1)
    }
    
    func testShouldValidateNumberOfItems() {
        XCTAssert(viewModel.numberOfItems() == 10)
    }
    
    func testShouldValidateGetGameDTO() {
        XCTAssert(viewModel.getGameDTO(at: 0).id == 488552)
        XCTAssert(viewModel.getGameDTO(at: 0).favorite == false)
        XCTAssert(viewModel.getGameDTO(at: 0).identifier == "https://static-cdn.jtvnw.net/ttv-boxart/Overwatch-272x380.jpg")
        XCTAssert(viewModel.getGameDTO(at: 0).name == "Overwatch")
    }
    
    func testShouldValidateGetGameDetailDTO() {
        XCTAssert(viewModel.getGameDetailDTO(at: 0).channels == 1399)
        XCTAssert(viewModel.getGameDetailDTO(at: 0).views == 19251)
        XCTAssert(viewModel.getGameDetailDTO(at: 0).name == "Overwatch")
    }
}
