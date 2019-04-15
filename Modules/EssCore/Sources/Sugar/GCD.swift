//
//  GCD.swift
//  EssCore
//
//  Created by Pavlo Boiko on 4/2/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public func main(_ f: @escaping () -> Void) {
    DispatchQueue.main.async {
        f()
    }
}
