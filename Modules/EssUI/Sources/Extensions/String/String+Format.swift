//
//  String+Format.swift
//  EssUI
//
//  Created by Pavlo Boiko on 1/23/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public extension String {
    public func firstSimbolUppercased() -> String {
        guard !self.isEmpty else { return "" }
        let firstSimbol = String(self.first!).uppercased()
        let suffix = self.suffix(count - 1)
        return firstSimbol + suffix
    }
}
