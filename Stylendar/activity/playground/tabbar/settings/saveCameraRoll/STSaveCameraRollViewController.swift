//
//  STSettingSaveCameraRollViewController.swift
//  Stylendar
//
//  Created by Tony on 2/14/20.
//  Copyright © 2020 Paul Berg. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class STSaveCameraRollViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = NSLocalizedString("CAMERA OPTIONS", comment: "")
    }
     
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let settingCell = cell as? STSaveCameraRollTableViewCell {
            settingCell.settingSwitch.isOn = Defaults[.saveToCameraRoll]
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = tableView.backgroundColor
        return view
    }
}
