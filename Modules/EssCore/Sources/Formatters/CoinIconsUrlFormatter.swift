//
//  CoinIconsUrlFormatter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/2/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Constants {
    static var imagesUrl = "https://clogos.essdev.info/"
    static var imageUrlPostfix = ".png"
}

public enum CoinIconSize: String {
    case x128
    case x64
    case x32
    case x16
    
    public var sizeIdentifire: String {
        let prefix = self.rawValue.dropFirst()
        return prefix + self.rawValue + "/"
    }
}

public class CoinIconsUrlFormatter {
    private var name: String
    private var size: CoinIconSize
    
    public init(name: String, size: CoinIconSize) {
        self.name = name
        self.size = size
    }
    
    private var formattedName: String {
        let lowercased = name.lowercased()
        let formatted = lowercased.replacingOccurrences(of: " ", with: "-")
        return formatted
    }
    
    public var url: URL {
        let urlString = Constants.imagesUrl + size.sizeIdentifire + formattedName + Constants.imageUrlPostfix
        return URL(string: urlString)!
    }
    
    public static func urlFromPath(path: String) -> URL {
        let urlString = Constants.imagesUrl + path
        return URL(string: urlString)!
    }
}
