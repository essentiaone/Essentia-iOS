//
//  UserProfile.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers
public class UserProfile: Object, Codable {
    dynamic public var name: String = ""
    dynamic public var privateCurrency: String = ""
    dynamic public var imageData: Data?
    @objc private dynamic var privateLanguage: String = ""
    
    public var language: LocalizationLanguage {
        get { return LocalizationLanguage(rawValue: privateLanguage)! }
        set { privateLanguage = newValue.rawValue }
    }
    public var currency: FiatCurrency {
        get { return FiatCurrency(rawValue: privateCurrency)! }
        set { privateCurrency = newValue.rawValue }
    }
    
    convenience init(image: UIImage, name: String) {
        self.init()
        self.name = name
        self.imageData = image.jpegData(compressionQuality: 1.0)
        self.currency = .usd
        self.language = .defaultLanguage
    }
    
    public var icon: UIImage {
        guard let data = imageData,
            let image = UIImage(data: data) else {
                return UIImage()
        }
        return image
    }
}
