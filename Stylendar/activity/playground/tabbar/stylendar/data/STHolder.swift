//
//  STSection.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 03/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import Foundation

/**
 *  To avoid shitty loading animations and to keep everything smooth, we pre-generate almost all the information required by the ecosystem.
 *
 *  The most important to note here are the adjustments, which is basically the distance between the 1st day of the month weekday's from Sunday (EG: Wednesday's adjustment is 2).
 *  If we'd not calculate them at startup, there'd be heavy calculations on each scroll.
 */
class STHolder {
    var printables = [Int:String]()
    var paths = [Int:String]()
}
