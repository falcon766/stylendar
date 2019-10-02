//
//  STSelectorTests.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 29/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import XCTest
@testable import Stylendar
@testable import SwiftDate

class STSelectorTests: XCTestCase {

    var selector: STSelector!
    
    override func setUp() {
        super.setUp()
        selector = STSelector()
    }
    
    override func tearDown() {
        selector = nil
        super.tearDown()
    }
}

extension STSelectorTests {
    
    /**
     *  Tests if the STSelector does its job properly.
     */
    func testSTSelector() {
        STUser.shared.createdAt = "2017-08-25T21:35:02Z"
        selector.gen()
        
        // Test the first day, which should always be Sunday
        XCTAssertEqual(selector.start.day, 20)
        
        // Test the order
        XCTAssertEqual(selector.holder.paths[0]!, "2017/08/20")
        XCTAssertEqual(selector.holder.paths[1]!, "2017/08/21")
        XCTAssertEqual(selector.holder.paths[2]!, "2017/08/22")
        XCTAssertEqual(selector.holder.paths[3]!, "2017/08/23")
        XCTAssertEqual(selector.holder.paths[4]!, "2017/08/24")
        XCTAssertEqual(selector.holder.paths[5]!, "2017/08/25")
        XCTAssertEqual(selector.holder.paths[6]!, "2017/08/26")
        XCTAssertEqual(selector.holder.paths[7]!, "2017/08/27")
        XCTAssertEqual(selector.holder.paths[8]!, "2017/08/28")
        XCTAssertEqual(selector.holder.paths[9]!, "2017/08/29")
        XCTAssertEqual(selector.holder.paths[10]!, "2017/08/30")
        XCTAssertEqual(selector.holder.paths[11]!, "2017/08/31")
        XCTAssertEqual(selector.holder.paths[12]!, "2017/09/01")

        // Test the `indexPaths(for: date)`
        let date = selector.start + 4.days
        let indexPaths = selector.indexPaths(for: date)!
        XCTAssertEqual(indexPaths[0].row, 0)
        XCTAssertEqual(indexPaths[1].item, 4)
    }
}
