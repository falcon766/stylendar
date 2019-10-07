//
//  STPostMultipleCarouselController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 05/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import iCarousel
import LKAlertController

extension STPostMultipleViewController {
    
    /**
     *  Appends the configured carousel to the view controller.
     */
    func appendCarousel() {
        carousel.clipsToBounds = true
        carousel.bounceDistance = 0.4
        
        /**
         *  We do this after a lil bit of time because the carousel needs time to calculate its frame size.
         */
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.carousel.scrollToItem(at: self.data.selected, animated: false)
        })
    }
}

extension STPostMultipleViewController: iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return data.selector.totalDays
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: STPostItemView

        //reuse view if available, otherwise create a new view
        if let view = view as? STPostItemView {
            itemView = view
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = STPostItemView.fromNib()
            itemView.frame = carousel.frame
        }
        if let path = data.selector.holder.paths[index], let downloadUrl = data.urls[path], let url = URL(string: downloadUrl) {
            itemView.postImageView.isHidden = false
            itemView.postImageView.fade(with: url)
        } else {
            itemView.postImageView.image = nil
            itemView.postImageView.isHidden = true
            itemView.fillerView.backgroundColor = data.selector.todayIndex == index ? UIColor.main : UIColor.appGray
            itemView.logoImageView.image = data.selector.todayIndex == index ? UIImage(named: "logo-white") : UIImage(named: "logo-blue")
        }
        
        return itemView
    }
}

extension STPostMultipleViewController: iCarouselDelegate {
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        /**
         *  We added a failsafe because of this strange bug: https://fabric.io/vansoftware/ios/apps/com.stylendar/issues/59a8a45ebe077a4dcce9de41
         */
        guard let user = data.user else {
            STAlert.top(STString.unknownError, isPositive: false)
            return
        }
        /**
         *  Allow the user to remove this post, but obviously only if:
         *
         *  1. She carousel displays the self user's profile.
         *  2. There is an image connected to this item.
         */
        guard
            let selfUid = Auth.auth().currentUser?.uid, selfUid == user.uid,
            let path = data.selector.holder.paths[index],
            let _ = data.urls[path]
        else { return }
        
        ActionSheet()
            .addAction(NSLocalizedString("Remove", comment: ""), style: .destructive, handler: { [weak self] (action) in
                guard let strongSelf = self else { return }
                strongSelf.postDelegate?.didTapRemoveButton()
                strongSelf.navigationController?.popViewController(animated: true)
            })
            .addAction(STString.cancel, style: .cancel)
            .show(animated: true)
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        let index = carousel.currentItemIndex
        
        guard let path = data.selector.holder.paths[index] else { return }
        guard let americanized = STDate.americanize(path) else { return }
        profileView.dateLabel.text = americanized
    }
}
