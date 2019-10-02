//
//  STBioTableViewController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit
import FirebaseAuth

extension STBioViewController {
    /**
     *  Appends the configured table view to the view controller.
     */
    func appendTableView() {
        tableView.register(UINib(nibName: String(describing: STProfileTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }
}

extension STBioViewController: UITableViewDataSource {
    
    /**
     *  The table view data source.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! STProfileTableViewCell
        cell.valueTextField.delegate = self

        switch indexPath.row {
            /**
             *  The username.
             */
            case 0:
                cell.accessoryType = .none
                cell.selectionStyle = .none
                
                cell.iconImageView.image = #imageLiteral(resourceName: "ic_compose")
                cell.iconImageView.tintColor = .iconGray
                cell.valueLabel.text = NSLocalizedString("Username", comment: "")
                
                usernameTextField = cell.valueTextField
                cell.valueTextField.text = STUser.shared.username
                cell.valueTextField.placeholder = NSLocalizedString("Value", comment: "")
                cell.valueTextField.returnKeyType = .next
                cell.valueTextField.isSecureTextEntry = false
                break
            /**
             *  The plain, simple first name of the user.
             */
            case 1:
                cell.accessoryType = .none
                cell.selectionStyle = .none
                
                cell.iconImageView.image = #imageLiteral(resourceName: "ic_profile")
                cell.iconImageView.tintColor = .iconGray
                cell.valueLabel.text = NSLocalizedString("First Name", comment: "")
                
                firstNameTextField = cell.valueTextField
                cell.valueTextField.text = STUser.shared.name.first
                cell.valueTextField.placeholder = NSLocalizedString("Value", comment: "")
                cell.valueTextField.returnKeyType = .next
                cell.valueTextField.isSecureTextEntry = false
                break
            /**
             *  The plain, simple last name of the user.
             */
            case 2:
                cell.accessoryType = .none
                cell.selectionStyle = .none
                
                cell.iconImageView.image = #imageLiteral(resourceName: "ic_profile")
                cell.iconImageView.tintColor = .iconGray
                cell.valueLabel.text = NSLocalizedString("Last Name", comment: "")
                
                lastNameTextField = cell.valueTextField
                cell.valueTextField.text = STUser.shared.name.last
                cell.valueTextField.placeholder = NSLocalizedString("Value", comment: "")
                cell.valueTextField.returnKeyType = .next
                cell.valueTextField.isSecureTextEntry = false
                break
            /**
             *  The plain, simple last name of the user.
             */
            case 3:
                cell.accessoryType = .none
                cell.selectionStyle = .none
                
                cell.iconImageView.image = #imageLiteral(resourceName: "ic_bio")
                cell.iconImageView.tintColor = .iconGray
                cell.valueLabel.text = NSLocalizedString("Bio", comment: "")
                
                bioTextField = cell.valueTextField
                cell.valueTextField.text = STUser.shared.bio
                cell.valueTextField.placeholder = NSLocalizedString("Bio", comment: "")
                cell.valueTextField.returnKeyType = .next
                cell.valueTextField.isSecureTextEntry = false
                break
            /**
             *  The email of the user.
             */
            case 4:
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
                
                cell.iconImageView.image = #imageLiteral(resourceName: "ic_email")
                cell.iconImageView.tintColor = .iconGray
                
                emailTextField = cell.valueTextField
                cell.valueLabel.text = NSLocalizedString("Email", comment: "")
                cell.valueTextField.isHidden = true
                break
        default:
            break
        }

        return cell
    }
}

extension STBioViewController: UITableViewDelegate {
    /**
        The table view delegate.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /**
         *  If this is the third row, we go the individual change email view controller.
         */
        if indexPath.row == 4 {
            goto(viewController: STChangeEmailViewController.self)
        }
    }
}
