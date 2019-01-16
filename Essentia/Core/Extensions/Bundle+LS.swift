//
//  Bundle+LS.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore

public func SwizzleLocalizedFiles() {
    MethodSwizzleGivenClassName (
        cls: Bundle.self,
        originalSelector: #selector(Bundle.localizedString(forKey:value:table:)),
        overrideSelector: #selector(Bundle.specialLocalizedString(key:value:table:))
    )
}

extension Bundle {
    @objc func specialLocalizedString(key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = Bundle(path: pathForCurrentLanguageResources) else {
            fatalError("Resource framework is not connected!")
        }
        return bundle.specialLocalizedString(key: key, value: value, table: tableName)
    }
    
    private var pathForCurrentLanguageResources: String {
        let currentLanguage = EssentiaStore.shared.currentUser.profile.language.localizationFileName
        guard let resourcesBundle = Bundle(identifier: "Essentia.EssResources") else {
            fatalError("Resource framework is not connected!")
        }
        guard let path = resourcesBundle.path(forResource: currentLanguage, ofType: "lproj") else {
            return resourcesBundle.path(forResource: "Base", ofType: "lproj") ?? ""
        }
        return path
    }
}
