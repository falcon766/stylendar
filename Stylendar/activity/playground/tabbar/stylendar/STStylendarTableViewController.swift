//
//  STStylendarTableViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 27/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Device
import SwiftDate

extension STStylendarViewController {
    /**
     *  Appends the configured table view to the view controller.
     */
    func appendTableView() {
        color = .main
        tableView.register(UINib(nibName: String(describing: STStylendarTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }
    
    /**
     *  We want to auto-scroll the stylendar depending upon the screen height.
     */
    func appendAutoScroll() {
        guard
        let indexPaths = data.selector.indexPathsForToday(),
        var indexPath = indexPaths.first
        else { return }
        
        switch Device.size() {
            case .screen3_5Inch:  indexPath.row -= 1
            case .screen4Inch:    indexPath.row -= 1
            case .screen4_7Inch:  indexPath.row -= 1
            case .screen5_5Inch:  indexPath.row -= 2
            case .screen7_9Inch:  indexPath.row -= 1
            case .screen9_7Inch:  indexPath.row -= 1
            case .screen12_9Inch: indexPath.row -= 1
            default:              indexPath.row -= 1
        }
        
        guard indexPath.row > 0 else { return }
//        print("indexPath.row is: \(indexPath.row) and indexPath.section is: \(indexPath.section)")
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)

        if indexPaths.count > 1{
            let column: CGFloat = CGFloat(indexPaths[1].item)
            let size = STYLENDAR_CELL_WIDTH * (column >= 1 && column < 5 ? column - 1 : column)
            scrollView.scrollRectToVisible(CGRect(x: size, y: 0, width: UIScreen.main.bounds.width, height: 200), animated: true)
        }

    }
    
    /**
     *  Appends the table empty view to the view controller.
     */
    func appendTableEmptyView() {
        color = .appPink
        tableView.isHidden = true
        tableEmptyView.isHidden = false
    }
}

/**
 *  The table view's data source.
 */
extension STStylendarViewController: UITableViewDataSource {
    
    /**
     *  Represents how many months are in the Stylendar.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     *  Tells how many weeks are.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /**
         *  We're adding 1 if the day is not divisible with 7 because that's the extra incomplete row.
         */
        let days = data.selector.totalDays
        return days / 7 + (days % 7 != 0 ? 1 : 0)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? STStylendarTableViewCell else { return UITableViewCell() }
        
        cell.contentView.backgroundColor = color
        cell.collectionView.backgroundColor = color
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forIndexPath: indexPath)
        if state == .personal { cell.setCollectionViewLongTapGestureRecognizer() }
        return cell
    }
}

/**
 *  The table view's delegate.
 */
extension STStylendarViewController: UITableViewDelegate {
    /**
     *  Styling the section footers.
     */
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 22))
        containerView.backgroundColor = .clear
        return containerView
    }
    
    /**
     *  It' better to set the height through delegates because it's esaier to change them.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return STYLENDAR_CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 22
    }
}

extension STStylendarViewController {
    /**
     *  Sugar method to reload the visible collection views.
     */
    func tableViewReloadChildCollectionViewCells() {
        guard let cells = tableView.visibleCells as? [STStylendarTableViewCell] else { return }
        for cell in cells {
            cell.collectionView.reloadData()
        }
    }
}
