//
//  STUserTableViewCell.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

@objc protocol STUserTableViewCellDelegate: class {
    @objc optional func didTapUserProfileArea(at indexPath: IndexPath)
    @objc optional func didRespondToFollowRequest(at indexPath: IndexPath, accepted: Bool)
}

class STUserTableViewCell: UITableViewCell {
    
    /**
     *  The default height of the cell.
     */
    class var height: CGFloat {
        get {
            return 56
        }
    }
    
    /**
     *  Used to communicate with the implementing class.
     */
    weak var delegate: STUserTableViewCellDelegate?
    var indexPath: IndexPath!
    
    /**
     *  The views.
     */
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let gestureRecognizers = profileView.gestureRecognizers, gestureRecognizers.isEmpty == false { return }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapProfileArea))
        tapGestureRecognizer.cancelsTouchesInView = true
        profileView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapProfileArea() {
        delegate?.didTapUserProfileArea?(at: indexPath)
    }
    
    @IBAction func didTapFollowRequestButton(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        delegate?.didRespondToFollowRequest?(at: indexPath, accepted: button.tag == 100 ? false : true)
    }
}
