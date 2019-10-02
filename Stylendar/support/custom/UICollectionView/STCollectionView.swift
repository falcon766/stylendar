//
//  STCollectionView.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 02/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension UICollectionView {
    struct UICollectionViewKeys {
        static fileprivate var tableIndexPath: UInt8 = 0
    }
    
    var tableIndexPath: IndexPath {
        get {
            return associated(to: self, key: &UICollectionViewKeys.tableIndexPath) { IndexPath(row: 0, section: 0) }
        }
        set {
            associate(to: self, key: &UICollectionViewKeys.tableIndexPath, value: newValue)
        }
    }
}
