//
//  STStylendarCollectionViewCell.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 27/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

protocol STStylendarCollectionViewCellDelegate: class {
    func collectionView( collectionView: UICollectionView, didLongTapItemAt indexPath: IndexPath)
}
class STStylendarCollectionViewCell: UICollectionViewCell {
    var indexPath: IndexPath?
    weak var delegate: STStylendarCollectionViewCellDelegate?
    
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
}

