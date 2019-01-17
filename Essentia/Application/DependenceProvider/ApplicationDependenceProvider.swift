//
//  ApplicationDependenceProvider.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssResources
import EssUI

class ApplicationDependenceProvider {
    func loadDependences() {
        loadAppStateEventProxy()
        loadCoreDependences()
        loadDesignDependences()
        loadLoginDependences()
    }
    
    private func loadCoreDependences() {
        loadAssets()
        loadServices()
        loadDaemons()
    }
    
    private func loadAssets() {
        loadImageSheme()
        loadColorSheme()
    }
    
    private func loadDesignDependences() {
        loadLoginDesign()
        loadBackupDesign()
    }
    
    private func loadAppStateEventProxy() {
        prepareInjection(AppStateEventProxy() as AppStateEventProxyInterface, memoryPolicy: .viewController)
    }
    
    // MARK: - Assets
    private func loadImageSheme() {
        let injection: AppImageProviderInterface = AppImageProvider()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadColorSheme() {
        let injection: AppColorInterface = DefaultColorSheme()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    // MARK: - Login
    private func loadLoginDependences() {
        loadLoginInteractor()
    }
    
    private func loadLoginInteractor() {
        let injection: LoginInteractorInterface = LoginInteractor()
        prepareInjection(injection, memoryPolicy: .viewController)
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
    
    // MARK: - Daemons
    
    private func loadDaemons() {
        loadRankDaemon()
    }
    
    private func loadRankDaemon() {
        let injection: CurrencyRankDaemonInterface = CurrencyRankDaemon()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    // MARK: - Services
    private func loadServices() {
        loadUserService()
        loadFileService()
        loadMnemonicService()
        loadLoader()
        loadLogger()
        loadTokens()
        loadWallets()
        loadCurrencyConvert()
    }
    
    private func loadCurrencyConvert() {
        let injection: CurrencyConverterServiceInterface = CurrencyConverterService()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadWallets() {
        let injection: WalletServiceInterface = WalletService()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadTokens() {
        let injection: TokensServiceInterface = TokenService()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadLogger() {
        let injection: LoggerServiceInterface = LoggerService()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadLoader() {
        let injection: LoaderInterface = Loader()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadMnemonicService() {
        let injection: MnemonicServiceInterface = MnemonicService()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadUserService() {
        let injection: UserStorageServiceInterface = UserStorageService()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadFileService() {
        let injection: LocalFilesServiceInterface = LocalFilesService()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
}
