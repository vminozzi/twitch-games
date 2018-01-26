//
//  GameResultTests.swift
//  GamesTests
//
//  Created by Vinicius on 26/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import XCTest
@testable import Games

class GameResultTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testShouldValidateGameResult() {
        guard let mocked = readJSON(name: "Mock"), let games = GameResult(data: mocked) else {
            return
        }
        
        XCTAssert(games.top.object(index: 0)?.game?._id == 488552)
        XCTAssert(games.top.object(index: 0)?.game?.box?.large == "https://static-cdn.jtvnw.net/ttv-boxart/Overwatch-272x380.jpg")
        XCTAssert(games.top.object(index: 0)?.game?.name == "Overwatch")
        XCTAssert(games.top.object(index: 0)?.channels == 1399)
        XCTAssert(games.top.object(index: 0)?.viewers == 19251)
        XCTAssert(games.top.object(index: 0)?.game?.popularity == 19100)
        XCTAssert(games.top.object(index: 0)?.game?.giantbomb_id == 48190)
        XCTAssert(games.top.object(index: 0)?.game?.locale == "en-us")
    }
}
