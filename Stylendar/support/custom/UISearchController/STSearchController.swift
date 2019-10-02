//
//  STSearchController.swift
//  Stylendar
//
//  Created by Paul Berg on 15/04/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STNoCancelButtonSearchController: UISearchController {
    let noCancelButtonSearchBar = STNoCancelButtonSearchBar()
    override var searchBar: UISearchBar { return noCancelButtonSearchBar }
}

class STNoCancelButtonSearchBar: UISearchBar {
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) { /* void */ }
}
