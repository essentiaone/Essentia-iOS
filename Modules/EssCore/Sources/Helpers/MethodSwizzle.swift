//
//  MethodSwizzle.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!
    if class_addMethod(cls,
                       originalSelector,
                       method_getImplementation(overrideMethod),
                       method_getTypeEncoding(overrideMethod)) {
        class_replaceMethod(cls,
                            overrideSelector,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod))
    } else {
        method_exchangeImplementations(origMethod, overrideMethod)
    }
}
