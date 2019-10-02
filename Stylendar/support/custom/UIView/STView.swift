//
//  STView.swift
//  Stylendar
//
//  Created by Paul Berg on 02/02/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    func fadeTransition(for duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
    
    func fade(for duration: CFTimeInterval) {
        alpha = 0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 1.0
        })
    }
}
