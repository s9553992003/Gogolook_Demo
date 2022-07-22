//
//  ListModelTest.swift
//  Gogolook_DemoTests
//
//  Created by Helios Chen on 2022/7/21.
//

import XCTest
@testable import Gogolook_Demo

class ListModelTest: XCTestCase {

    var mainListViewController: MainListViewController!
    
    override func setUp() {
        super.setUp()

//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        mainListViewController = MainListViewController()
    }
    
    func testGetInitialAnimeCount() {
        let animeCount = 0
        let result = mainListViewController.getTopAnimeData()
        XCTAssertEqual(result, animeCount, "anime count is wrong.")
    }
    
    func testGetInitialMangaCount() {
        let mangaCount = 0
        let result = mainListViewController.getTopMangaData()
        XCTAssertEqual(result, mangaCount, "manga count is wrong.")
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
}
