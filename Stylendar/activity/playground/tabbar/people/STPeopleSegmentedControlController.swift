//
//  STPeopleSegmentedControlController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STPeopleViewController {
    
    /**
     *  Appends the configured segmented control to the view controller.
     */
    func appendSegmentedControl() {
        let appearance = { () -> BadgeSegmentControlAppearance in
            let appearance = BadgeSegmentControlAppearance()
            appearance.borderWidth = 1
            appearance.borderColor = .white
            appearance.cornerRadius = 4
            appearance.dividerColour = .white

            appearance.segmentOnSelectionColour = .white
            appearance.segmentOffSelectionColour = .main
            
        
            appearance.titleOnSelectionColour = .main
            appearance.titleOffSelectionColour = .white
            appearance.titleOffSelectionFont = UIFont.montserrat(size: 12)
            appearance.titleOnSelectionFont = UIFont.montserrat(size: 12)
            
            return appearance
        }
        segmentedControl.segmentAppearance = appearance()
        
        segmentedControl.addSegmentWith(title:NSLocalizedString("Followers".uppercased(), comment: ""),subtitle: "0")
        segmentedControl.addSegmentWith(title:NSLocalizedString("Following".uppercased(), comment: ""),subtitle: "0")
        segmentedControl.addSegmentWith(title:NSLocalizedString("Requests".uppercased(), comment: ""),subtitle: "0")
        segmentedControl.selectedSegmentIndex = 0
    }
    
    /**
     *  Updates the follow requests badge if the count has changed.
     */
    func updateFollowRequestsBadge(_ count: Int) {
        segmentedControl.updateBadge(forValue: count, andSection: STPeopleViewControllerState.requests.rawValue)
    }
    
    func updateFollowBadgeSubtitle(_ count: Int, section:Int) {
        segmentedControl.updateBadgeSubtitle(forValue: count, andSection: section)
     }
}

extension STPeopleViewController {
    /**
     *  Called when the user toggles the segments.
     */
    @IBAction func didChangeSegmentedControlValue(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        guard index != state.rawValue, let newState = STPeopleViewControllerState(rawValue: index) else { return }
        
        state = newState
    }
    
}
