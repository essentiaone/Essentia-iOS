//
//  Bundle+LS.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

func SwizzleLocalizedFiles() {
    MethodSwizzleGivenClassName (
        cls: Bundle.self,
        originalSelector: #selector(Bundle.localizedString(forKey:value:table:)),
        overrideSelector: #selector(Bundle.specialLocalizedString(key:value:table:))
    )
}

extension Bundle {
    @objc func specialLocalizedString(key: String, value: String?, table tableName: String?) -> String {
        let currentLanguage = EssentiaStore.currentUser.profile.language.localizationFileName
        var bundle: Bundle
        if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            bundle = Bundle(path: _path)!
        } else {
            let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            bundle = Bundle(path: _path)!
        }
        return (bundle.specialLocalizedString(key: key, value: value, table: tableName))
    }
}
