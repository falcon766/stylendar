//
//  STErrorTests.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 28/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import XCTest
@testable import Stylendar

class STErrorTests: XCTestCase {
    
    var errorUnderTest: STError?
    
    override func setUp() {
        super.setUp()
        errorUnderTest = STError.usernameAlreadyExists
    }
    
    override func tearDown() {
        errorUnderTest = nil
        super.tearDown()
    }
    
    func testErrorCode() {
        XCTAssertEqual(errorUnderTest!.code, STError.usernameAlreadyExistsCode)
        
        var error: Error?
        error = errorUnderTest
    
        // This passes.
        if let stylendarError = error as? STError {
            XCTAssertEqual(stylendarError.code, STError.usernameAlreadyExistsCode)
        }
        
        // This fails, because it returns the NSError's code, not the STError's.
        XCTAssertEqual(error!.code, STError.usernameAlreadyExistsCode)
    }
}
