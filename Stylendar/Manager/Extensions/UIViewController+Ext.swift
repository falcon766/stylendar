//
//  UIViewController+Ext.swift
//  Stylendar
//
//  Created by Apple on 10/14/19.
//  Copyright © 2019 Paul Berg. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    static func loadVC<T>(SB:SBName, identifier:String? = nil) -> T {
        return UIStoryboard(name: SB.rawValue, bundle: nil)
               .instantiateViewController(withIdentifier:identifier != nil ? identifier! : String(describing:type(of:T.self))) as! T
    }
}


