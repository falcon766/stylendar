//
//  STTableView.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 11/09/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

final class STTableView: UITableView {
    private var reloadDataCompletionBlock: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
    }
    
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        reloadDataCompletionBlock = completion
        super.reloadData()
    }
}
