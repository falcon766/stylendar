//
//  SettingTableViewCell.swift
//  Stylendar
//
//  Created by Tony on 2/13/20.
//  Copyright © 2020 Paul Berg. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onChangeSetting(_ sender: Any) {
        Defaults[.saveToCameraRoll] = settingSwitch.isOn
    }

}
