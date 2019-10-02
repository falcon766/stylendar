//
//  STMedia.swift
//  Stylendar
//
//  Created by Paul Berg on 25/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STMedia {
    /**
     *  The preffered format to store the images: jpg.
     */
    class var format: String {
        get {
            return ".jpg"
        }
    }
    
    /**
     *  The default desired size of one Stylendar image.
     */
    class var defaultSize: Int {
        get {
            return 225 * 1024
        }
    }
        
    /**
     *  The preffered compressions to be used with UIImageJPEGRepresentation.
     */
    class var defaultJPEGCompression: CGFloat {
        get {
            return 0.7
        }
    }
    
    class var stylendarJPEGCompression: CGFloat {
        get {
            return 0.6
        }
    }
    
    /**
     *  This is used when we deal with images larger than 5m b.
     */
    class var stylendarJPEGCompressionSevere: CGFloat {
        get {
            return 0.4
        }
    }
}
