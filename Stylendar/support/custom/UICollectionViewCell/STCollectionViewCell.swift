//
//  STCollectionViewCell.swift
//  Stylendar
//
//  Created by Paul Berg on 03/02/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    /**
        Content resize issue solved!
     */
    
    override open func layoutSubviews() {
        let contentViewIsAutoresized = __CGSizeEqualToSize(frame.size, contentView.frame.size)
        if !contentViewIsAutoresized {
            var contentViewFrame = contentView.frame
            contentViewFrame.size = frame.size
            contentView.frame = contentViewFrame
        }
    }
}
