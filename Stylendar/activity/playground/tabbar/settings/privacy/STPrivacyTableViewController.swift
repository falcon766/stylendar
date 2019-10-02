//
//  STPrivacyTableViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 09/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STPrivacyViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            if data.isStylendarPublic == false {
                data.isStylendarPublic = true
                publicTableViewCell.accessoryType = .checkmark
                privateTableViewCell.accessoryType = .none
            }
        } else {
            if data.isStylendarPublic == true {
                data.isStylendarPublic = false
                publicTableViewCell.accessoryType = .none
                privateTableViewCell.accessoryType = .checkmark
            }
        }
    }
}
