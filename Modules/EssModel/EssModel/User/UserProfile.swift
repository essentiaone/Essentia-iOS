//
//  UserProfile.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public class UserProfile: Codable {
    public var name: String?
    public var currency: FiatCurrency
    public var imageData: Data?
    public var language: LocalizationLanguage
    
    public init(image: UIImage, name: String) {
        self.name = name
        self.imageData = image.jpegData(compressionQuality: 1.0)
        self.currency = .usd
        self.language = .defaultLanguage
    }
    
    public var icon: UIImage {
        guard let data = imageData,
            let image = UIImage(data: data) else {
                return #imageLiteral(resourceName: "testAvatar")
        }
        return image
    }
}
