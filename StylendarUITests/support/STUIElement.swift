//
//  STUIElement.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 01/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import XCTest

extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
