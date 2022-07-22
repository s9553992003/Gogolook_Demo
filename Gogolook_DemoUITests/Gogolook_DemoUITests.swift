//
//  Gogolook_DemoUITests.swift
//  Gogolook_DemoUITests
//
//  Created by Helios Chen on 2022/7/18.
//

import XCTest

class Gogolook_DemoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.buttons["Top Anime"].tap()
        
        app.buttons["tv"].tap()
        sleep(2)
        app.buttons["airing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
        
        app.buttons["movie"].tap()
        sleep(2)
        app.buttons["airing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
        
        app.buttons["ova"].tap()
        sleep(2)
        app.buttons["airing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
        
        app.buttons["special"].tap()
        sleep(2)
        app.buttons["airing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
        
        app.buttons["ona"].tap()
        app.buttons["airing"].tap()
        app.buttons["upcoming"].tap()
        app.buttons["bypopularity"].tap()
        app.buttons["favorite"].tap()
        
        app.buttons["music"].tap()
        sleep(2)
        app.buttons["airing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)

        app/*@START_MENU_TOKEN@*/.buttons["Top Manga"]/*[[".segmentedControls[\"segmentedControlSelect\"].buttons[\"Top Manga\"]",".buttons[\"Top Manga\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2)
        
        app.buttons["manga"].tap()
        sleep(2)
        app.buttons["publishing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
        
        app.buttons["novel"].tap()
        sleep(2)
        app.buttons["publishing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
        
        app.buttons["lightnovel"].tap()
        sleep(2)
        app.buttons["publishing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
        
        app.buttons["oneshot"].tap()
        sleep(2)
        app.buttons["publishing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
        
        app.buttons["doujin"].tap()
        sleep(2)
        app.buttons["publishing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
        
        app.buttons["manhwa"].tap()
        sleep(2)
        app.buttons["publishing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
        
        app.buttons["manhua"].tap()
        sleep(2)
        app.buttons["publishing"].tap()
        sleep(2)
        app.buttons["upcoming"].tap()
        sleep(2)
        app.buttons["bypopularity"].tap()
        sleep(2)
        app.buttons["favorite"].tap()
        sleep(2)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
