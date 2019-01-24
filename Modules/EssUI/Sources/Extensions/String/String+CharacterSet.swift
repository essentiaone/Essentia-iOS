//
//  String+CharacterSet.swift
//  EssUI
//
//  Created by Pavlo Boiko on 1/23/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public extension String {
    
    /// Removes specified characters from string
    public func replacing(charactersIn characterSet: CharacterSet, with replacement: String) -> String {
        return components(separatedBy: characterSet).joined(separator: replacement)
    }
    
    public func contains(charactersIn characterSet: CharacterSet, options: String.CompareOptions = []) -> Bool {
        return rangeOfCharacter(from: characterSet, options: options) != nil
    }
}
