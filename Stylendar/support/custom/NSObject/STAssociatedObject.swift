//
//  STAssociatedObject.swift
//  Stylendar
//
//  Created by Paul Berg on 23/04/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import ObjectiveC

final class Lifted<T> {
    let value: T
    init(_ x: T) {
        value = x
    }
}

private func lift<T>(_ x: T) -> Lifted<T>  {
    return Lifted(x)
}

func associated<T>(to base: AnyObject,
                key: UnsafePointer<UInt8>,
                policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN,
                initialiser: () -> T) -> T {
    if let v = objc_getAssociatedObject(base, key) as? T {
        return v
    }
    
    if let v = objc_getAssociatedObject(base, key) as? Lifted<T> {
        return v.value
    }
    
    let lifted = Lifted(initialiser())
    objc_setAssociatedObject(base, key, lifted, policy)
    return lifted.value
}

func associate<T>(to base: AnyObject, key: UnsafePointer<UInt8>, value: T, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN) {
    if let v:AnyObject = value as? AnyObject {
        objc_setAssociatedObject(base, key, v, policy)
    }
    else {
        objc_setAssociatedObject(base, key, lift(value), policy)
    }
}
