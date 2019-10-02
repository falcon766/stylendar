//
//  STChangePasswordTableViewController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

extension STChangePasswordViewController {
    /**
     *  Appends the configured table view to the view controller.
     */
    func appendTableView() {
        tableView.register(UINib(nibName: String(describing: STProfileTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }
}

extension STChangePasswordViewController: UITableViewDataSource, UITableViewDelegate {
    
    /**
     *  The table view data source.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? STProfileTableViewCell else { return UITableViewCell() }
        cell.valueTextField.delegate = self
        cell.valueTextField.isSecureTextEntry = true
        
        switch indexPath.row {
            /**
             *  The current password of the user. Secured by the text field from being shown.
             */
            case 0:
                cell.iconImageView.image = #imageLiteral(resourceName: "ic_password")
                cell.valueLabel.text = NSLocalizedString("Current Password", comment: "")
                
                currentPasswordTextField = cell.valueTextField
                cell.valueTextField.text = ""
                cell.valueTextField.placeholder = NSLocalizedString("Enter", comment: "")
                cell.valueTextField.returnKeyType = .next
                break
            /**
             *  The new password of the user. Secured by the text field from being shown.
             */
            case 1:
                cell.iconImageView.image = #imageLiteral(resourceName: "ic_password")
                cell.valueLabel.text = NSLocalizedString("New Password", comment: "")

                newPasswordTextField = cell.valueTextField
                cell.valueTextField.text = ""
                cell.valueTextField.placeholder = NSLocalizedString("Set", comment: "")
                cell.valueTextField.returnKeyType = .next
                break
            /**
             *  The confirm new password of the user. Secured by the text field from being shown.
             */
            case 2:
                cell.iconImageView.image = #imageLiteral(resourceName: "ic_password")
                cell.valueLabel.text = NSLocalizedString("Confirm Password", comment: "")

                confirmNewPasswordTextField = cell.valueTextField
                cell.valueTextField.text = ""
                cell.valueTextField.placeholder = NSLocalizedString("Set", comment: "")
                cell.valueTextField.returnKeyType = .go
                break
            default:
                break
        }
        
        return cell
    }
}
