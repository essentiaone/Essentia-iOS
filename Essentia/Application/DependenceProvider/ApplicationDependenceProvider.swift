//
//  ApplicationDependenceProvider.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class ApplicationDependenceProvider {
    func loadDependences() {
        loadCoreDependences()
        loadDesignDependences()
    }
    
    private func loadCoreDependences() {
        loadColorSheme()
        loadImageSheme()
        loadMnemonicProvider()
    }
    
    private func loadImageSheme() {
        let injection: AppImageProviderInterface = AppImageProvider()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadColorSheme() {
        let injection: AppColorInterface = DefaultColorSheme()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadDesignDependences() {
        loadLoginDesign()
        loadBackupDesign()
    }
    
    // MARK: - Design
    private func loadLoginDesign() {
        let injection: LoginDesignInterface = LoginDesign()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadBackupDesign() {
        let injection: BackupDesignInterface = BackupDesign()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    // MARK: - Mnemonic
    
    private func loadMnemonicProvider() {
        let injection: MnemonicProviderInterface = MnemonicProvider(language: .english)
        prepareInjection(injection, memoryPolicy: .viewController)
    }
}
