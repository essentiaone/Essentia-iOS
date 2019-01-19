//
//  LocalizationLanguage+LS.swift
//  Essentia
//
//  Created by Pavlo Boiko on 1/10/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import Foundation
import EssModel

extension LocalizationLanguage {
    public var titleString: String {
        switch self {
        case .english:
            return LS("LocalizationLanguage.English")
        case .korean:
            return LS("LocalizationLanguage.Korean")
        case .chinese:
            return LS("LocalizationLanguage.Chinese")
        }
    }
}
