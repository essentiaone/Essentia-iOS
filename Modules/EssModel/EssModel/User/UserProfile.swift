//
//  UserProfile.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate var defaultImage = UIImage(named: "testAvatar")!

public class UserProfile: Codable {
    public var name: String?
    public var currency: FiatCurrency
    public var imageData: Data?
    public var language: LocalizationLanguage
    
    public init() {
        self.currency = .usd
        self.language = LocalizationLanguage.defaultLanguage
        self.imageData = defaultImage.pngData()
    }
    
    public convenience init(image: UIImage, name: String) {
        self.init()
        self.name = name
        self.imageData = image.jpegData(compressionQuality: 1.0)
    }
    
    public var icon: UIImage {
        guard let data = imageData,
            let image = UIImage(data: data) else {
                return #imageLiteral(resourceName: "testAvatar")
        }
        return image
    }
}
