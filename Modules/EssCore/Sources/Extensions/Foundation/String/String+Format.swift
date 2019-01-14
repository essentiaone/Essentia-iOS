//
//  String+Format.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public extension String {
    public func firstSimbolUppercased() -> String {
        guard !self.isEmpty else { return "" }
        let firstSimbol = String(self.first!).uppercased()
        let suffix = self.suffix(count - 1)
        return firstSimbol + suffix
    }
    
    public var formattedCoinName: String {
        let lowercased = self.lowercased()
        let formatted = lowercased.replacingOccurrences(of: " ", with: "-")
        return formatted
    }
}
