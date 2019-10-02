//
//  STImage.swift
//  Stylendar
//
//  Created by Paul Berg on 15/02/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STImage {
    
    /**
     *  Creates a `width` x `height` image which basically is mono coloured.
     */
    func monocolor(width: Float, height: Float, color: UIColor) -> UIImage {
        return UIImage()
    }
}


extension UIImage {
    
    /**
     *  Resizes an image.
     */
    func resize(to newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /**
     *  Compresses the image until it reaches the given size.
     *
     *  Taken from https://gist.github.com/akshay1188/4749253
     */
    func compress() -> Data? {
        var actualHeight: CGFloat = size.height
        var actualWidth: CGFloat = size.width
        let maxHeight: CGFloat = 1136.0
        let maxWidth: CGFloat = 640.0
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        var compressionQuality: CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else{
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let imageData = UIImageJPEGRepresentation(img, compressionQuality)else{
            return nil
        }
        return imageData
    }
    
    /**
     *  Generates the size for this image. Be careful, don't use compression 1.0.
     *
     *  Read more: https://stackoverflow.com/questions/25248294/uiimagejpegrepresentation-received-memory-warning
     */
    func sizeInBytes(for compression: CGFloat) -> Double? {
        guard
            STStorage.mb(Int(ProcessInfo.processInfo.physicalMemory)) > 10,
            let jpeg = UIImageJPEGRepresentation(self, compression)
            else {
                STError.playground(STError.memoryError)
                return nil
        }
        
        let data = NSData(data: jpeg)
        return Double(data.length)
    }
}


extension STImage {
    /**
     *  Adds the rounded corners to the image itself.
     */
    class func rounded(image: UIImage, completion: (((UIImage?)->(Void)))?) {
        rounded(image: image, cornerRadius: 8, completion: completion)
    }
    
    class func rounded(image: UIImage, cornerRadius: CGFloat, completion: (((UIImage?)->(Void)))?) {
        DispatchQueue.global().async {
            // Begin a new image that will be the new image with the rounded corners
            // (here with the size of an UIImageView)
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            // Add a clip before drawing anything, in the shape of an rounded rect
            UIBezierPath(roundedRect: rect, cornerRadius: 16).addClip()
            
            // Draw your image
            image.draw(in: rect)
            
            // Get the image, here setting the UIImageView image
            guard let roundedImage = UIGraphicsGetImageFromCurrentImageContext() else {
                print("UIGraphicsGetImageFromCurrentImageContext failed")
                completion?(nil)
                return
            }
            
            // Lets forget about that we were drawing
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                completion?(roundedImage)
            }
        }
    }
}
