//
//  STStylendarViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 01/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import XCTest

class STStylendarViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIDevice.shared.orientation = .portrait
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let table = app.tables.element(boundBy: 0)
        let lastCell = table.cells.element(boundBy: table.cells.count-1)
        table.scrollToElement(element: lastCell)
//        
//        let app = XCUIApplication()
//        app.tables.buttons["Moments"].tap()
//        app.collectionViews["PhotosGridView"].cells["Photo, Portrait, 27 July, 19:34"].tap()
    }
}
