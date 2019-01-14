//
//  LocalizationLanguage.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public enum LocalizationLanguage: String, Codable, Equatable {
    case english
    case chinese
    case korean
    
    public init(languageCode: String) {
        let code = String(languageCode.prefix(2))
        switch code {
        case "zh":
            self = .chinese
        case "ko":
            self = .korean
        default:
            self = .english
        }
    }
    
    public var localizationFileName: String {
        switch self {
        case .english:
            return "en"
        case .chinese:
            return "zh-Hant"
        case .korean:
            return "ko"
        }
    }
    
    public var rawValue: String {
        return String(describing: self)
    }
    
   public static var defaultLanguage: LocalizationLanguage {
        guard let languageCode = Locale.current.languageCode?.prefix(2) else {
            return .english
        }
        return self.init(languageCode: String(languageCode))
    }
    
    public static var cases: [LocalizationLanguage] {
        return [.english, .chinese, .korean]
    }
}
