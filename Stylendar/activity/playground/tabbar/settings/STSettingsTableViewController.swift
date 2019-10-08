//
//  STSettingsTableViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 07/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STSettingsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0:
            goto(viewController: STBioViewController.self)
            break
        case 1:
            goto(viewController: STChangePasswordViewController.self)
            break
        case 2:
            goto(viewController: STPrivacyViewController.self)
            break
        case 3:
            didTapInviteButton()
        break
        case 4:
            didTapLogoutButton()
            break
        default:
            break
        }
    }
}

extension STSettingsViewController {
    
    /**
     *  Called when the 4th row of the view controller was tapped.
     */
    func didTapLogoutButton() {
        let alertController = UIAlertController(title: nil,
                                                message:  NSLocalizedString("Are you sure?", comment: ""),
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Log Out", comment: ""), style: .destructive, handler: { [weak self] action in
            guard let strongSelf = self else { return }
            strongSelf.logout()
        }))
        self.present(alertController, animated: true, completion: nil)
    }

    /**
     * Invite friends
     */
    func didTapInviteButton() {
        let sharingText = "Hey! I’m on Stylendar as \(STUser.shared.name.full ?? ""). Install the app so we can share our OOTDs! \("itms-apps://itunes.apple.com/app/1263156515?mt=8")"
        let activityViewController = UIActivityViewController(activityItems: [sharingText], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .openInIBooks, .postToFlickr, .postToVimeo, .saveToCameraRoll]
        /**
         * Avoid crash on ipad
         */
        activityViewController.popoverPresentationController?.sourceView = self.view

        present(activityViewController, animated: true, completion: nil)
    }
}
