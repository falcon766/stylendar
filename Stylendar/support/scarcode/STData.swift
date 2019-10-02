//
//  STData.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 11/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import Foundation

extension Data {
    // Print Data as a string of bytes in hex, such as the common representation of APNs device tokens
    // See: http://stackoverflow.com/a/40031342/9849
    var hexByteString: String {
        return self.map { String(format: "%02.2hhx", $0) }.joined()
    }
}
