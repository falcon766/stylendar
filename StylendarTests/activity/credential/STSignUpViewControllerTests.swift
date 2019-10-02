//
//  STSignUpViewControllerTests.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 27/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import XCTest
@testable import Stylendar

class STMockError: Error {
    public init() {}
}

class STSignUpViewControllerTests: XCTestCase {
    
    var error: Error?
    
    override func setUp() {
        super.setUp()
        error = STMockError()
    }
    
    override func tearDown() {
        error = nil
        super.tearDown()
    }
    
    /**
     *  Tests if the `case nil` snippet works.
     */
    func testHandleResponseErrorChecker() {

        var works: Bool = false
        if let _ = error, case nil = error as? STError {
            works = true
        } else {
            works = false
        }
        
        XCTAssertEqual(works, true)
    }
}
