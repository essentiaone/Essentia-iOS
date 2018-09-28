//
//  UserProfile.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

struct UserProfile: Codable {
    var name: String?
    var currency: Currency
    var imageData: Data?
    var language: LocalizationLanguage
    
    init() {
        self.currency = .usd
        self.language = LocalizationLanguage.defaultLanguage
        self.imageData = UIImage(named: "testAvatar")!.jpegData(compressionQuality: 1.0)!
    }
    
    init(image: UIImage, name: String) {
        self.init()
        self.name = name
        self.imageData = image.jpegData(compressionQuality: 1.0)
    }
    
    var icon: UIImage {
        guard let data = imageData,
            let image = UIImage(data: data) else {
                return #imageLiteral(resourceName: "testAvatar")
        }
        return image
    }
}
