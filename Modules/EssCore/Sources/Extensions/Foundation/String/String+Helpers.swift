//
//  String+Helpers.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/2/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
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
