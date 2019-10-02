//
//  UITableViewCell+SCFunction.swift
//  Stylendar
//
//  Created by Paul Berg on 26/06/16.
//  Copyright © 2016 Paul Berg. All rights reserved.
//

import UIKit

class STTableViewCell: UITableViewCell {
    var indexPath: IndexPath!

    /**
        We're overriding every `init` function of the cell to always make the separator full width.
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        appendFullWidthSeparator()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        appendFullWidthSeparator()
    }
}

extension UITableViewCell {
    /**
        Makes the table view cell separator full width.
     */
    func appendFullWidthSeparator() {
        preservesSuperviewLayoutMargins = false
        separatorInset = .zero
        layoutMargins = .zero
    }
}
