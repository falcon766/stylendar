//
//  STChangeEmailTableViewController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

extension STChangeEmailViewController {
    /**
        Appends the configured table view to the view controller.
     */
    func appendTableView() {
        tableView.register(UINib(nibName: String(describing: STProfileTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }
}


extension STChangeEmailViewController: UITableViewDataSource {
    
    /**
        The table view data source.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! STProfileTableViewCell
        cell.valueTextField.delegate = self
        
        switch indexPath.row {
            /**
                The current password of the user. Secured by the text field from being shown.
             */
            case 0:
                cell.iconImageView.image = UIImage(named: "ic_password")
                cell.valueLabel.text = NSLocalizedString("Re-Enter Password", comment: "")
                
                passwordTextField = cell.valueTextField
                cell.valueTextField.text = ""
                cell.valueTextField.placeholder = NSLocalizedString("Enter", comment: "")
                cell.valueTextField.isSecureTextEntry = true
                cell.valueTextField.returnKeyType = .next
                break
            /**
                The email of the user.
             */
            case 1:
                cell.iconImageView.image = UIImage(named: "ic_email")
                cell.valueLabel.text = NSLocalizedString("Email", comment: "")
                
                emailTextField = cell.valueTextField
                cell.valueTextField.text = STUser.shared.email
                cell.valueTextField.placeholder = NSLocalizedString("Value", comment: "")
                cell.valueTextField.isSecureTextEntry = false
                cell.valueTextField.returnKeyType = .go
                break
            default:
                break
        }
        return cell
    }
}
