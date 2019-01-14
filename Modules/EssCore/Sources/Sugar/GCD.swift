//
//  GCD.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/26/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import Foundation
import UIKit

public func main(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async(execute: closure)
}

public func global(_ closure: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async(execute: closure)
}

public func asyncUIUpdate(backgroud: @escaping () -> Void, uiUpdate:  @escaping () -> Void) {
    global {
        backgroud()
        main {
            uiUpdate()
        }
    }
}

public func queueWithDelays(_ queue :[() -> Void], delayInNanosecods: UInt32) {
    DispatchQueue.global().async {
        queue.forEach { (action) in
            DispatchQueue.main.async {
                action()
            }
            usleep(delayInNanosecods)
        }

    }
}
