//
//  STProfileView.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 07/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
@IBDesignable

class STProfileView: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBInspectable var xibName: String?
    
    override func awakeFromNib() {
        guard let name = self.xibName,
            let xib = Bundle.main.loadNibNamed(name, owner: self),
            let views = xib as? [UIView], views.count > 0 else { return }
        self.addSubview(views[0] )
    }
}
